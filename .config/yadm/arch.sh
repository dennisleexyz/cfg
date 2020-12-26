#!/bin/sh

sudo sed -Ei 's/.*(en_US.UTF-8 UTF-8).*/\1/' /etc/locale.gen
sudo locale-gen
echo 'LANG=en_US.UTF-8' | sudo tee /etc/locale.conf

grep '^\[multilib\]$' /etc/pacman.conf || echo '
[multilib]
Include = /etc/pacman.d/mirrorlist' |
	sudo tee -a /etc/pacman.conf

#shellcheck disable=2016
grep '^\[nonprism\]$' /etc/pacman.conf || echo '
[nonprism]
Server = https://mirror.fsf.org/parabola/$repo/os/$arch' |
	sudo tee -a /etc/pacman.conf
#shellcheck disable=2016
grep '^\[libre\]$' /etc/pacman.conf || echo '
[libre]
Server = https://mirror.fsf.org/parabola/$repo/os/$arch' |
	sudo tee -a /etc/pacman.conf

ping example.com -w 1 && {
	sudo sed -Ei 's/.*(RemoteFileSigLevel = ).*/\1Never/' /etc/pacman.conf
	curl -L 'archlinux.org/mirrorlist/?country=US&protocol=https&ip_version=6&use_mirror_status=on' |
		sed 's/#//' | sudo tee /etc/pacman.d/mirrorlist
	pacman -Q parabola-keyring || sudo pacman -U \
		https://www.parabola.nu/packages/core/i686/archlinux32-keyring-transition/download \
		https://www.parabola.nu/packages/libre/x86_64/parabola-keyring/download
	sudo sed -Ei 's/.*(RemoteFileSigLevel = ).*/\1Required/' /etc/pacman.conf

	sudo pacman -Syu --noconfirm

	lsblk -f | grep btrfs && install btrfs-progs

	if lsusb | grep -Ey 'upek touch[[:alpha:]]{2,3}ip'; then
		install '
			xf86-input-wacom
			gdm
			xinit-xsession
			fprintd
			xournalpp
			linux-hardened
			galileo-dev
		'
		sudo systemctl enable --now -f gdm
		sudo gpasswd -a dennis galileo
	else
		install '
			sx
			linux-zen
			linux-zen-headers
			nvidia-390xx-dkms
			lib32-nvidia-390xx-utils
			#lightdm-gtk-greeter
			#lightlocker
		'
	fi

	install '
		pmount
		gtk3-nocsd-git
		simple-scan
		iriunwebcam-bin
		x2x
		droidcam
		x11-ssh-askpass
		signal-desktop
		ntfs-3g
		flameshot
		mtpfs
		android-tools
		xdg-user-dirs
		linux-firmware
		udiskie
		sunwait
		dvtm
		# zsh-autosuggestions
		# zsh-completions
		# zsh-history-substring-search
		# zsh-syntax-highlighting
		# zsh-doc
		syncthing
		# alsa-utils
		pulseaudio
		man
			man-pages
		neovim
			# ctags
		pass
			xdotool
		shellcheck
		mosh
		sx
			pcmanfm
				gvfs-mtp
				gvfs-gphoto2
			qemu
			xss-lock
			python-pillow-simd
			ueberzug
			xdo
			xcape
			imagemagick
			sxiv
			# dunst
			deadd-notification-center-bin
			indicator-kdeconnect
				breeze-icons
			network-manager-applet
			redshift
			volumeicon
			dex
			sxhkd
			dmenu
			xorg-xmodmap
			xcape
			# polybar
			# rofi
			xst
				xurls
			lxqt-policykit
			#lxsession
			lxqt-sudo
				# oxygen-icons
			xfce4-settings
			qt5-styleplugins
			iceweasel
				iceweasel-https-everywhere
				browserpass-firefox
				firefox-tridactyl-native
			brave-bin
				chromium-extension-adnauseam
				browserpass-chromium
			icedove
				birdtray
				# kdocker
				icedove-extension-enigmail
			fcitx-chewing
			fcitx-configtool
			steam
				cabextract
			xcompmgr
			i3-wm
				i3blocks
				i3blocks-contrib
		#ranger
		#autorandr
		#dragon-drag-and-drop
		noto-fonts
		noto-fonts-cjk
		noto-fonts-emoji
		ttf-fira-code
		ttf-nerd-fonts-symbols
		#surfraw
		grub
		efibootmgr
		os-prober
		#zathura
		#https://github.com/NixOS/nixpkgs/blob/release-20.03/nixos/modules/services/printing/cupsd.nix
		#cups
		#https://github.com/NixOS/nixpkgs/blob/release-20.03/nixos/modules/services/security/physlock.nix
		#physlock
		npm
		tzupdate
		xorg-xrdb
		#anki
		#bc
	'

	sudo tzupdate

	sudo curl \
		https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts \
		-o /etc/hosts
	mkdir -p ~/.local/src && cd ~/.local/src &&
	git clone git://bitreich.org/privacy-haters
	cd ~/.icedove &&
		cat user-overrides.js >> user.js

	npm install -g npm
	cd ~/.local/src &&
		git clone https://github.com/darkreader/darkreader
		cd darkreader && git pull
		npm install
		sed '/addons.mozilla.org/d' src/background/utils/extension-api.ts
		npm run release
		# grep -r "darkreader" ~/.mozilla/firefox >/dev/null ||
		iceweasel ~/.local/src/darkreader/build-firefox.xpi

	# shellcheck disable=2116
	[ -n "$DISPLAY" ] && for addon in $(echo "
		adnauseam
		browserpass
		buster-captcha-solver
		# darkreader
		decentraleyes
		disable-polymer-youtube
		firenvim
		invidition
		redirect-bypasser-webextension
		old-reddit-redirect
		reddit_comment_collapser
		# privacy-redirect
		clearurls
		canvasblocker
	" | sed 's/#.*//'); do
		grep -r "$addon" ~/.mozilla/firefox >/dev/null ||
			iceweasel "addons.mozilla.org/en-US/firefox/addon/$addon"
	done
	grep -r "tridactyl" ~/.mozilla/firefox >/dev/null ||
	iceweasel tridactyl.cmcaine.co.uk/betas/nonewtab/tridactyl_no_new_tab_beta-latest.xpi
}

sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi
# sudo alsactl store
sudo systemctl enable --now \
	systemd-timesyncd \
	NetworkManager \
	# alsa-restore \
	#sshd \

pacman -Q | grep nvidia &&
	#https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF#Enabling_IOMMU
	sudo sed -Ei '
		s/.*(GRUB_GFXPAYLOAD_LINUX=).*/\11920x1080,keep/;
		s/.*(GRUB_CMDLINE_LINUX=).*/\1iommu=soft/;
	' /etc/default/grub

sudo sed -Ei '
	s/.*(GRUB_TIMEOUT=).*/\10/;
	s/.*(GRUB_TIMEOUT_STYLE=).*/\1hidden/;
' /etc/default/grub

sudo grub-mkconfig -o /boot/grub/grub.cfg

sudo sed -Ei '
	s/.*(UseSyslog).*/\1/;
	s/.*(Color).*/\1/;
	s/.*(TotalDownload).*/\1/;
	s/.*(VerbosePkgLists).*/\1/;
' /etc/pacman.conf

echo '[global-dns-domain-*]
servers=94.140.14.14,94.140.15.15' |
	sudo tee /etc/NetworkManager/conf.d/dns-servers.conf

echo 'blacklist pcspkr' | sudo tee /etc/modprobe.d/pcspkr.conf

grep laptop-updates.brave.com /etc/hosts || echo '0.0.0.0 laptop-updates.brave.com' | sudo tee -a /etc/hosts

grep "$(id -un)" /etc/passwd | grep /bin/sh || chsh -s /bin/sh
for f in /etc/skel/.*; do rm ~/"$(basename "$f")"; done
