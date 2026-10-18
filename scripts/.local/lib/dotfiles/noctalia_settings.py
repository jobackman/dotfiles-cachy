"""Public-safe Noctalia settings snapshots; Python 3.11+, standard library only."""
import argparse
import copy
import json
import os
from pathlib import Path
import re
import tempfile
import tomllib
from datetime import datetime, timezone

# Reviewed top-level sections. New sections are excluded until reviewed.
SECTIONS = {
    "bar", "control_center", "desktop_widgets", "dock", "lockscreen",
    "lockscreen_widgets", "notification", "osd", "plugins", "shell", "theme", "widget",
}
# Plugin settings are especially likely to contain credentials: allow individual fields.
PLUGIN_FIELDS = {"noctalia/wallhaven": {"browser_placement"}}
SENSITIVE = re.compile(r"api.?key|token|secret|password|credential|authorization|cookie|address|latitude|longitude", re.I)


def check_values(value, path="settings"):
    """Fail closed on suspicious nested fields/values, without printing their values."""
    if isinstance(value, dict):
        for key, child in value.items():
            if SENSITIVE.search(key) and not (key == "center_password_text" and isinstance(child, bool)):
                raise ValueError(f"Sensitive-looking field in approved section: {path}.{key}")
            check_values(child, f"{path}.{key}")
    elif isinstance(value, list):
        for child in value:
            check_values(child, path)
    elif isinstance(value, str):
        if re.search(r"(?:api.?key|token|secret|password|authorization)\s*[=:]|https?://[^/\s]+@", value, re.I):
            raise ValueError(f"Sensitive-looking value at {path}")
    elif type(value) not in (int, float, bool):
        raise ValueError(f"Unsupported value at {path}")


def sanitize(settings):
    result = {k: copy.deepcopy(v) for k, v in settings.items() if k in SECTIONS or k == "config_version"}
    plugins = {}
    for plugin, fields in PLUGIN_FIELDS.items():
        values = settings.get("plugin_settings", {}).get(plugin, {})
        approved = {k: copy.deepcopy(v) for k, v in values.items() if k in fields}
        if approved:
            plugins[plugin] = approved
    if plugins:
        result["plugin_settings"] = plugins
    check_values(result)
    return result


def merge(base, overlay):
    result = copy.deepcopy(base)
    for key, value in overlay.items():
        if isinstance(value, dict) and isinstance(result.get(key), dict):
            result[key] = merge(result[key], value)
        else:
            result[key] = copy.deepcopy(value)
    return result


def toml_value(value):
    if isinstance(value, str):
        return json.dumps(value, ensure_ascii=False)
    if isinstance(value, bool):
        return str(value).lower()
    if isinstance(value, (int, float)):
        return repr(value)
    if isinstance(value, list):
        return "[" + ", ".join(toml_value(v) for v in value) + "]"
    if isinstance(value, dict):
        return "{ " + ", ".join(f"{json.dumps(k)} = {toml_value(v)}" for k, v in value.items()) + " }"
    raise ValueError("Unsupported TOML value")


def encode_toml(settings):
    # Inline nested tables preserve arbitrary widget IDs and arrays without dependencies.
    text = "# Restored by noctalia-settings-import\n" + "\n".join(
        f"{json.dumps(k)} = {toml_value(v)}" for k, v in settings.items()
    ) + "\n"
    if tomllib.loads(text) != settings:
        raise ValueError("TOML round-trip verification failed")
    return text


def atomic_write(path, content):
    path.parent.mkdir(parents=True, exist_ok=True)
    fd, temporary = tempfile.mkstemp(prefix=f".{path.name}.", dir=path.parent)
    try:
        with os.fdopen(fd, "w") as stream:
            stream.write(content)
        os.replace(temporary, path)
    finally:
        if os.path.exists(temporary):
            os.unlink(temporary)


def changed_paths(before, after, prefix=""):
    for key, value in after.items():
        path = f"{prefix}.{key}" if prefix else key
        if isinstance(value, dict) and isinstance(before.get(key), dict):
            yield from changed_paths(before[key], value, path)
        elif key not in before or before[key] != value:
            yield path


def main(mode):
    state_home = Path(os.environ.get("XDG_STATE_HOME", Path.home() / ".local/state"))
    data_home = Path(os.environ.get("XDG_DATA_HOME", Path.home() / ".local/share"))
    parser = argparse.ArgumentParser(description=(
        "Export reviewed Noctalia settings (never the raw file)." if mode == "export" else
        "Preview merging a sanitized snapshot. Stop Noctalia before using --apply."
    ))
    parser.add_argument("--settings", type=Path, default=state_home / "noctalia/settings.toml")
    parser.add_argument("--snapshot", type=Path, default=data_home / "dotfiles/noctalia/settings.json")
    if mode == "import":
        parser.add_argument("--apply", action="store_true", help="Back up and write settings; Noctalia must be stopped")
    args = parser.parse_args()
    try:
        if mode == "export":
            settings = tomllib.loads(args.settings.read_text())
            safe = sanitize(settings)
            atomic_write(args.snapshot.resolve(), json.dumps({"format_version": 1, "settings": safe}, indent=2, ensure_ascii=False, allow_nan=False) + "\n")
            print(f"Exported sanitized snapshot: {args.snapshot}")
            print("Included sections: " + ", ".join(sorted(safe)))
            print("Omitted sections: " + ", ".join(sorted(set(settings) - set(safe))))
            print("Plugin settings: only explicitly approved fields exported; credentials omitted.")
            print("Review custom commands, labels, URLs, and monitor names before committing.")
        else:
            snapshot = json.loads(args.snapshot.read_text())
            if snapshot.get("format_version") != 1 or not isinstance(snapshot.get("settings"), dict):
                raise ValueError("Unsupported snapshot format")
            safe = snapshot["settings"]
            if sanitize(safe) != safe:
                raise ValueError("Snapshot contains unapproved sections or plugin fields")
            target = args.settings.resolve()
            original = target.read_text() if target.exists() else ""
            settings = tomllib.loads(original)
            if "config_version" in settings and safe.get("config_version", settings["config_version"]) != settings["config_version"]:
                raise ValueError("Configuration versions differ; review/migrate before importing")
            updated = merge(settings, safe)
            changes = list(changed_paths(settings, updated))
            print("Changed settings (values hidden):")
            for path in changes:
                print(f"  {path}")
            if not changes:
                print("  None")
                return
            encoded = encode_toml(updated)
            if not args.apply:
                print("Preview only. Stop Noctalia, then rerun with --apply to write these changes.")
                return
            if target.exists():
                backup = target.with_name(target.name + ".backup-" + datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%S%fZ"))
                # Backup contains secrets: create it privately, outside the repository.
                atomic_write(backup, original)
                print(f"Private backup: {backup}")
            atomic_write(target, encoded)
            print(f"Updated: {target}. Restart Noctalia to load it.")
    except (OSError, ValueError, TypeError, KeyError) as exc:
        # Parser errors may contain source snippets, so do not echo them.
        if isinstance(exc, (tomllib.TOMLDecodeError, json.JSONDecodeError)):
            parser.exit(1, "Error: invalid settings/snapshot syntax (details hidden).\n")
        parser.exit(1, f"Error: {exc}\n")
