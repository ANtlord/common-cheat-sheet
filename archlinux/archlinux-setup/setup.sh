#!/bin/bash
# Run inside target OS.
[ -v $s_host ] || echo 'set variable $s_host in order to set hostname'
[ -v $s_user ] || echo 'set variable $s_user in order to create a user'
[ -v $s_font ] || echo 'set variable $s_font in order to TTY font'

ln -sf /usr/share/zoneinfo/Asia/Irkutsk /etc/adjtime
hwclock --systohc
sed -i 's/#en_US.UTF-8/en_US.UTF-8/g' /etc/locale.gen
sed -i 's/#ru_RU.UTF-8/ru_RU.UTF-8/g' /etc/locale.gen
locale-gen
[ -f /etc/locale.conf ] && grep LANG=en_US.UTF-8 /etc/locale.conf || echo LANG=en_US.UTF-8 > /etc/locale.conf
[ -f /etc/vconsole.conf ] && grep KEYMAP=ru /etc/vconsole.conf || cat <<EOT> /etc/vconsole.conf
KEYMAP=ru
FONT=$s_font
EOT
[ -f /etc/hostname ] && grep $s_host /etc/hostname || echo $s_host > /etc/hostname
cat <<EOT> /etc/hosts
127.0.0.1	localhost
::1		localhost
EOT
pacman -S intel-ucode vim iw grub efibootmgr git wpa_supplicant sudo
grep consolefont /etc/mkinitcpio.conf || sed -i 's/^HOOKS=\([^)]*\)/HOOKS=\1 consolefont/g' /etc/mkinitcpio.conf
mkinitcpio -p linux
grub-install --target=x86_64-efi --efi-directory /efi --bootloader-id=archlinux
grub-mkconfig -o /boot/grub/grub.cfg
cat <<EOT> /etc/modprobe.d/blacklist.conf
blacklist nouveau
blacklist fivafb
blacklist nvidiafb
blacklist rivatv 
#blacklist nv
#blacklist ucvideo
EOT
useradd -m -s /bin/bash -g users -G video,audio,wheel,storage $s_user
echo $s_user' ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/$s_user
sed -i 's/#DefaultTimeoutStopSec=90s/DefaultTimeoutStopSec=10s/g' /etc/systemd/system.conf
