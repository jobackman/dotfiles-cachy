# dotfiles

Selective, public-safe configuration for this CachyOS/Hyprland system. The
repository uses [GNU Stow](https://www.gnu.org/software/stow/) to create
symlinks in the home directory.

## TL;DR

```sh
cd ~/git/dotfiles

# Keep Hyprland and Zed config directories local instead of folded symlinks.
mkdir -p "$HOME/.config/hypr/config" "$HOME/.config/zed"

# Preview changes without modifying the home directory.
stow --simulate --verbose=2 --target "$HOME" hypr noctalia shell terminal tools scripts

# Create or refresh all symlinks.
stow --restow --target "$HOME" hypr noctalia shell terminal tools scripts

# Remove one package's symlinks without deleting repository files.
stow --delete --target "$HOME" terminal

# Review and record configuration changes.
git status
git diff
git add <paths>
git commit -m "Describe the change"
```

## Layout

Each top-level directory is a Stow package. Its contents mirror their target
paths below `$HOME`.

| Package | Contents |
| --- | --- |
| `hypr` | Hyprland configuration |
| `noctalia` | Noctalia Shell configuration |
| `shell` | Bash, Zsh, and Fish startup configuration |
| `terminal` | Kitty configuration |
| `tools` | Micro, Mise, and Zed configuration (settings and keybindings) |
| `scripts` | Personal scripts in `~/.local/bin` |

## Install

Install GNU Stow on Arch/CachyOS:

```sh
sudo pacman -S stow
```

Clone the repository, then preview every package before making changes:

```sh
cd ~/git/dotfiles
# Keep Hyprland and Zed config directories local instead of folded symlinks.
mkdir -p "$HOME/.config/hypr/config" "$HOME/.config/zed"
stow --simulate --verbose=2 --target "$HOME" hypr noctalia shell terminal tools scripts
```

If the preview is clean, create or refresh the symlinks:

```sh
stow --restow --target "$HOME" hypr noctalia shell terminal tools scripts
```

Keep `~/.config/hypr/config` in place when restowing the `hypr` package. This
causes Stow to link the individual configuration files rather than folding
`~/.config/hypr` into one directory symlink, which Hyprland cannot load.

Keep `~/.config/zed` as a real directory too, so only its settings and keymap
are symlinked. Generated themes and other local Zed files should stay outside
this repository.

Stow will not replace conflicting files. Back up, remove, or move any
conflicting target before running the non-simulated command. To remove a
package's symlinks without deleting the repository files:

```sh
stow --delete --target "$HOME" terminal
```

## Day-to-day use

Edit the configuration through its normal path under `$HOME`; it is a symlink
into this repository. Review and record changes as usual:

```sh
cd ~/git/dotfiles
git status
git diff
git add <paths>
git commit -m "Describe the change"
git push
```

To add a configuration, create the matching path inside a package, back up the
live target, preview with `stow --simulate`, then apply with `stow --restow`.
Use a new package when the configuration is independently useful.

## Noctalia saved settings

GUI preferences live in `~/.local/state/noctalia/settings.toml`; never symlink
that raw file into this repository. The Python 3.11+ scripts export approved
appearance/layout settings, omitting API keys, calendar accounts, location,
wallpaper paths, and unapproved plugin fields. Histories and caches are ignored.

```sh
# Test an export, inspect the JSON, then preview restoring it.
./scripts/.local/bin/noctalia-settings-export --snapshot /tmp/noctalia-settings.json
./scripts/.local/bin/noctalia-settings-import --snapshot /tmp/noctalia-settings.json

# Save a reviewed snapshot in the Stow package.
./scripts/.local/bin/noctalia-settings-export \
  --snapshot noctalia/.local/share/dotfiles/noctalia/settings.json
```

Review commands, URLs, and other free-form text before publishing; automated
checks cannot catch every secret. After restowing, both commands default to
`~/.local/share/dotfiles/noctalia/settings.json` and can be run by name.

Import previews by default. **Stop Noctalia before using `--apply`**, then
restart it afterward. Applying merges preferences while preserving local
credentials, replaces lists, and creates a private backup beside the live
settings. TOML comments/formatting are not preserved. Use `--help` for options.

## Public repository policy

Only deliberately reviewed, non-sensitive configuration belongs here. Do not
add credentials, API tokens, private keys, SSH or GnuPG data, browser profiles,
application databases, caches, histories, or unreviewed machine state. The
sanitized Noctalia snapshot above is an intentional exception. `.gitconfig`
and Fish `fish_variables` are intentionally excluded.

Noctalia generates `~/.config/kitty/themes/noctalia.conf` and
`~/.config/zed/themes/noctalia.json`; both are excluded and will be recreated
when Noctalia applies its theme.
