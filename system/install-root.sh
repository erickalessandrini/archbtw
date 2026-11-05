#!/usr/bin/env bash
# install-root.sh — Part 3 polish, root-level steps. Run:  sudo bash ~/dotfiles/system/install-root.sh
# Order: packages -> backups -> greetd -> plymouth theme -> kernel cmdline -> mkinitcpio HOOKS -> initramfs LAST.
set -euo pipefail
[[ $EUID -eq 0 ]] || { echo "run with sudo"; exit 1; }
U="${SUDO_USER:-$USER}"; H=$(getent passwd "$U" | cut -d: -f6); S=$H/dotfiles/system
B=$H/dotfiles-backup/system-$(date +%F-%H%M%S); mkdir -p "$B/loader-entries" "$B/initramfs"
P=/usr/share/plymouth/themes/cyberpunk-neon
VT_RED=0,255,0,249,10,234,0,215,19,255,0,249,10,234,0,255
VT_GRN=11,42,255,240,189,0,184,255,62,42,255,240,189,0,184,255
VT_BLU=30,109,159,2,198,217,255,254,124,109,159,2,198,217,255,255
PARAMS="splash loglevel=3 rd.udev.log_level=3 vt.global_cursor_default=0 vt.default_red=$VT_RED vt.default_grn=$VT_GRN vt.default_blu=$VT_BLU"

echo "== 1/7 packages (official repos only — wlogout is AUR, NOT installed here)"
pacman -S --needed --noconfirm plymouth swayosd swappy

echo "== 2/7 backups -> $B"
cp -a /etc/greetd/config.toml /etc/mkinitcpio.conf "$B/"
cp -a /boot/loader/entries/*.conf "$B/loader-entries/"
cp -a /boot/initramfs-linux*.img "$B/initramfs/"
chown -R $U:$U "$B"

echo "== 3/7 greetd + tuigreet, swayosd caps-lock backend"
install -m 0644 "$S/greetd/banner.txt"  /etc/greetd/banner.txt
install -m 0644 "$S/greetd/config.toml" /etc/greetd/config.toml
diff -u "$B/config.toml" /etc/greetd/config.toml || true
systemctl enable --now swayosd-libinput-backend.service

echo "== 4/7 plymouth theme (spinner base, neon throbber, #000b1e background)"
rm -rf "$P"; cp -a /usr/share/plymouth/themes/spinner "$P"
rm -f "$P"/throbber-*.png; install -m 0644 "$S"/plymouth/cyberpunk-neon/throbber-*.png "$P/"
mv "$P/spinner.plymouth" "$P/cyberpunk-neon.plymouth"
setkey() { local f="$P/cyberpunk-neon.plymouth"
  if grep -q "^$1=" "$f"; then sed -i "s|^$1=.*|$1=$2|" "$f"; else sed -i "/^\[two-step\]/a $1=$2" "$f"; fi; }
setkey ImageDir "$P"
setkey BackgroundStartColor 0x000b1e
setkey BackgroundEndColor   0x000b1e
setkey ProgressBarBackgroundColor 0x133e7c
setkey ProgressBarForegroundColor 0x00ff9f
sed -i 's|^Name=.*|Name=Cyberpunk Neon|' "$P/cyberpunk-neon.plymouth"
cat "$P/cyberpunk-neon.plymouth"
plymouth-set-default-theme cyberpunk-neon        # no -R: initramfs is rebuilt once, at the end

echo "== 5/7 kernel cmdline (rescue entry first, then append missing params; LUKS params untouched)"
main=$(ls /boot/loader/entries/*.conf | grep -v -e fallback -e nosplash | head -1)
if [[ ! -e /boot/loader/entries/arch-nosplash.conf ]]; then
  sed 's|^title .*|title   Arch Linux (no splash, rescue)|' "$main" > /boot/loader/entries/arch-nosplash.conf
fi
for f in /boot/loader/entries/*.conf; do
  case "$f" in *fallback*|*nosplash*) echo "skip $f (kept plain for rescue)"; continue ;; esac
  for p in $PARAMS; do
    k=${p%%=*}
    grep -qE "^options(.* )?${k//./\\.}(=| |\$)" "$f" || sed -i "0,/^options/ s|^options.*|& $p|" "$f"
  done
  grep -q 'rd.luks.name=' "$f" && grep -q 'rd.luks.options=discard' "$f" || { echo "LUKS params missing in $f — restoring and aborting"; cp -a "$B/loader-entries/$(basename "$f")" "$f"; exit 1; }
  diff -u "$B/loader-entries/$(basename "$f")" "$f" || true
done

echo "== 6/7 mkinitcpio HOOKS: plymouth after kms, before sd-encrypt"
sed -i -E '/^HOOKS=/{/plymouth/! s/\bkms\b/kms plymouth/}' /etc/mkinitcpio.conf
grep '^HOOKS=' /etc/mkinitcpio.conf
grep -qE '^HOOKS=.*plymouth.*sd-encrypt' /etc/mkinitcpio.conf || { echo "plymouth not before sd-encrypt — restoring and aborting"; cp -a "$B/mkinitcpio.conf" /etc/mkinitcpio.conf; exit 1; }

echo "== 7/7 regenerate initramfs (LAST). Auto-rollback on failure."
if ! mkinitcpio -P; then
  echo "mkinitcpio FAILED — restoring mkinitcpio.conf + previous initramfs images"
  cp -a "$B/mkinitcpio.conf" /etc/mkinitcpio.conf; cp -a "$B"/initramfs/*.img /boot/; exit 1
fi
lsinitcpio /boot/initramfs-linux.img | grep -E 'plymouthd$|cyberpunk-neon/throbber-0001.png|systemd-cryptsetup$' || true
echo "DONE. Backups in $B. Reboot to test."
