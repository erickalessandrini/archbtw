# archbtw — Cyberpunk Neon Hyprland rice

My Arch Linux desktop: Hyprland on Wayland, themed end-to-end in one neon palette, from the boot splash to the lock screen.

**Why Arch + BlackArch + a Kali VM:** Arch for a minimal desktop I fully understand, BlackArch repos for security tools on demand, and a Kali VM for anything I'd rather keep isolated from my daily driver.

## Screenshots

| Terminal | Launcher | Lock screen |
|---|---|---|
| ![terminal](screenshots/terminal.png) | ![rofi launcher](screenshots/app-search.png) | ![hyprlock](screenshots/lockscreen.png) |

## How this box was built

1. **Hardware:** a Dell Latitude 7490, bought used with no drive. I added an NVMe SSD.
2. **OS:** Arch Linux, installed by hand from the wiki. No `archinstall`.
3. **Disk:** LUKS2 full-disk encryption on the root partition, unlocked in the initramfs with `sd-encrypt`.
4. **Boot:** systemd-boot, with `rd.luks.options=discard` so TRIM reaches the SSD.
5. **Login:** greetd with tuigreet on the console. No display manager.
6. **Desktop:** Hyprland on Wayland.
7. **Tooling:** the BlackArch repo is added to pacman, so security tools install on demand, not all at once.
8. **Isolation:** Kali runs in a VM for work I keep off the host.
9. **Dotfiles:** managed with GNU stow, one package per program.
10. **Workflow:** the config was iterated over SSH from a separate VM running Claude Code. The laptop holds no GitHub or AI account credentials. Commits and pushes happen on the VM.

## Stack

| Role | Tool |
|---|---|
| Compositor | Hyprland (Lua config) |
| Bar | waybar |
| Launcher | rofi |
| Terminal | kitty |
| Shell / prompt | zsh + starship |
| Wallpaper | awww (formerly swww) |
| Lock / idle | hyprlock / hypridle |
| Notifications | mako |
| Power menu | wlogout (rofi fallback) |
| Volume / brightness OSD | swayosd |
| Clipboard history | cliphist |
| Eye candy | btop, cava, fastfetch |
| Boot / login | plymouth, greetd + tuigreet |

## Palette — Cyberpunk Neon

| Name | Hex | Used for |
|---|---|---|
| Base | `#000b1e` | backgrounds |
| Surface | `#0a1428` | pills, panels |
| Border | `#133e7c` | inactive borders |
| Text | `#d7fffe` | foreground |
| Neon green | `#00ff9f` | accent, active workspace |
| Neon blue | `#00b8ff` | clock, CPU |
| Cyan | `#0abdc6` | secondary text |
| Magenta | `#ea00d9` | temperature, highlights |
| Red | `#ff2a6d` | urgent, errors |
| Yellow | `#f9f002` | warnings |

## Keybinds

`Super` = Windows key.

| Keys | Action |
|---|---|
| `Super + Q` | terminal (kitty) |
| `Super + E` | file manager (Thunar) |
| `Super + R` | app launcher (rofi) |
| `Super + B` | browser (LibreWolf) |
| `Super + C` | close window |
| `Super + F` | toggle floating |
| `Super + P` | pseudo-tile |
| `Super + J` | toggle split |
| `Super + arrows` | move focus |
| `Super + left-drag` | move window |
| `Super + right-drag` | resize window |
| `Super + 1…0` | go to workspace |
| `Super + Shift + 1…0` | move window to workspace |
| `Super + S` | toggle scratchpad |
| `Super + Shift + S` | send window to scratchpad |
| `Super + L` | lock |
| `Super + Escape` | power menu |
| `Super + W` | next wallpaper |
| `Super + V` | clipboard history |
| `Super + M` | exit Hyprland |
| `Print` | screenshot region → clipboard |
| `Shift + Print` | screenshot region → annotate |
| `Ctrl + Print` | full screenshot → file |
| Media keys | volume, mic, brightness (with OSD), playback |
| Taskbar: left-click | focus window |
| Taskbar: right-click | maximize window (keeps the bar visible) |
| Taskbar: middle-click | close window |

## Install

Assumes a working Arch install with an AUR helper (`yay` or `paru`; the commands below use `yay`).

Official repos:

```sh
sudo pacman -S --needed hyprland hyprlock hypridle hyprpolkitagent xdg-desktop-portal-hyprland \
  waybar rofi kitty zsh zsh-autosuggestions zsh-syntax-highlighting starship fzf \
  awww mako swayosd cliphist wl-clipboard grim slurp swappy libnotify brightnessctl playerctl pavucontrol \
  btop cava fastfetch thunar nwg-look papirus-icon-theme ttf-jetbrains-mono-nerd stow \
  plymouth greetd greetd-tuigreet
```

AUR:

```sh
yay -S catppuccin-gtk-theme-mocha catppuccin-cursors-mocha wlogout
```

Dotfiles. Clone into `~/dotfiles`, not `~/archbtw`. Stow links everything relative to that path, and `install-root.sh` expects it there.

```sh
git clone https://github.com/erickalessandrini/archbtw.git ~/dotfiles
cd ~/dotfiles
stow awww btop cava fastfetch gtk hypr hyprlock kitty mako rofi scripts starship swappy swayosd waybar wlogout zsh
```

Optional, root-level (greetd, Plymouth theme, kernel cmdline, initramfs). Read it first: it edits your boot config and makes backups. It works out your user from `sudo`, so run it with `sudo`, not from a root shell.

```sh
sudo bash ~/dotfiles/system/install-root.sh
```

**Rollback:** backups go to `~/dotfiles-backup/system-<timestamp>/`. If the new entry won't boot, pick **"Arch Linux (no splash, rescue)"** in the boot menu, then run `sudo cp ~/dotfiles-backup/system-<timestamp>/loader-entries/*.conf /boot/loader/entries/`. The same folder holds `mkinitcpio.conf` and the old initramfs images.

## License

MIT, see [LICENSE](LICENSE).
