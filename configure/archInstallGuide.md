# Arch install guide

## Install

### Keyboard layout

`loadkeys uk` - Set console keyboard layout to UK

### Check if EFI

`ls /sys/firmware/efi/efivars` - If this returns loads of files, you are on UEFI system

### Internet

`iwctl`  
`device list`

`device *device* set-property Powered on`  
`adapter *adapter* set-property Powered on`

`station *device* scan` - Scan for networks  
`station *device* get-networks` - List networks  
`station *device* connect *SSID*` - Connect to network

### Timezone

`timedatectl set-timezone Europe/London` - Set timezone  
`timedatectl` - Check it worked

### Disc Partitioning

`fdisk -l`  
`fdisk /dev/DRIVE`

#### Create new partition table

> `o` - New partition table  
> `w` - Write changes

`fdisk /dev/DRIVE`

#### Boot partition

> `n` - New partition  
> `p` - Type = Primary  
> `1` - First partion  
> Enter - Starts at first avalible space  
> `+512M` - 512MB for boot partition

Change type to EFI

> `t` - Change type  
> `ef` - Code ef is EFI boot type

#### Swap Partition

> `n`  
> `p`  
> `2`  
> Enter  
> `+18G` - 18GB for swap partition as I have 16GB of RAM, enough for hybernation

Change type to swap

> `t`  
> `2`  
> `82` - Code 82 is swap type

#### Root Partition

> `n`  
> `p`  
> `3`  
> Enter  
> Enter - Will take up entire rest of drive

Make bootable

> `a` - Set bootable flag  
> `3`

#### Write Changes

> `w` - Write changes

### Formatting

`mkfs.ext4 /dev/ROOT_PARTITION`  
`mkswap /dev/SWAP_PARTITION`  
`mkfs.fat -F32 /dev/EFI_SYSTEM_PARTITION`

### Mounting

`mount /dev/ROOT_PARTITION /mnt`  
`mount --mkdir /dev/EFI_SYSTEM_PARTITION /mnt/boot`  
`swapon /dev/SWAP_PARTITION`

### Install

`pacstrap -K /mnt base linux linux-firmware nano networkmanager`

### Fstab

`genfstab -U /mnt >> /mnt/etc/fstab`

### Chroot

`arch-chroot /mnt`

### Time Zone

`ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime`  
`hwclock --systohc`

### Localization

`nano /etc/locale.gen`  
Uncomment `en_GB.UTF-8 UTF-8`

`locale-gen`

`nano /etc/locale.conf`  
Add `LANG=en_GB.UTF-8`

`nano /etc/vconsole.conf`  
Add `KEYMAP=uk`

### Hostname

`nano /etc/hostname`  
Add `MY_HOSTNAME`

### Root Password

`passwd`

### Check Mirrors 

`nano /etc/pacman.d/mirrorlist`  
`pacman -Syyu`

### Microcode

`pacman -Syu`  
`pacman -S amd-ucode grub efibootmgr sudo`  
or
`pacman -S intel-ucode grub efibootmgr sudo`  

### Grub

`grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB`  
`grub-mkconfig -o /boot/grub/grub.cfg`

### Exit and Reboot

`exit`  
`umount -R /mnt`  
`reboot`

## Post install

### WiFi Setup and Connect

`rfkill`  
`rfkill unblock wlan`

`systemctl enable NetworkManager.service`  
`reboot`

`nmtui`

### Create User

`useradd --create-home username`  
`usermod -aG wheel username`  
`passwd username`

`nano /etc/sudoers`  
Uncomment `%wheel ALL=(ALL) ALL`

`reboot`

### Install Things

`sudo pacman -Syu` - Update system  
`sudo pacman -S xfce4 xorg-server mousepad lightdm lightdm-gtk-greeter alacritty xfce4-pulseaudio-plugin xfce4-genmon-plugin git` - Install programs  
`sudo systemctl enable lightdm.service`  
`reboot`
