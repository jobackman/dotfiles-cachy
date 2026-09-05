# dotfiles

Selective, public-safe configuration for this CachyOS/Hyprland system. The
repository uses [GNU Stow](https://www.gnu.org/software/stow/) to create
symlinks in the home directory.

## Layout

Each top-level directory is a Stow package. Its contents mirror their target
paths below `$HOME`.

| Package | Contents |
| --- | --- |
| `hypr` | Hyprland configuration |
| `noctalia` | Noctalia Shell configuration |
| `shell` | Bash, Zsh, and Fish startup configuration |
| `terminal` | Kitty configuration |
| `tools` | Btop, Micro, and Mise configuration |
| `scripts` | Personal scripts in `~/.local/bin` |

## Install

Install GNU Stow on Arch/CachyOS:

```sh
sudo pacman -S stow
```

Clone the repository, then preview every package before making changes:

```sh
cd ~/git/dotfiles
# Hyprland requires its config directory to be a real directory, not a folded symlink.
mkdir -p "$HOME/.config/hypr/config"
stow --simulate --verbose=2 --target "$HOME" hypr noctalia shell terminal tools scripts
```

If the preview is clean, create or refresh the symlinks:

```sh
stow --restow --target "$HOME" hypr noctalia shell terminal tools scripts
```

Keep `~/.config/hypr/config` in place when restowing the `hypr` package. This
causes Stow to link the individual configuration files rather than folding
`~/.config/hypr` into one directory symlink, which Hyprland cannot load.

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

## Public repository policy

Only deliberately reviewed, non-sensitive configuration belongs here. Do not
add credentials, API tokens, private keys, SSH or GnuPG data, browser profiles,
application databases, caches, histories, or machine state. `.gitconfig` and
Fish `fish_variables` are intentionally excluded.

Noctalia generates `~/.config/kitty/themes/noctalia.conf`; it is excluded and
will be recreated when Noctalia applies its theme.

The initial pre-Stow backup is stored outside this repository at
`~/.local/share/dotfiles-backups/20260905T181244Z/`.
