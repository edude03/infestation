SHELL = /bin/bash
NIX_BINARY = http://hydra.nixos.org/build/25489771/download/1/nix-1.10-x86_64-linux.tar.bz2
PROOT_BINARY = http://static.proot.me/proot-x86_64
INSTALL_DIRECTORY = /home/$(USER)/opt
CHROOT_RUN = $(INSTALL_DIRECTORY)/bin/proot-x86_64 -b $(INSTALL_DIRECTORY)/nix-mnt/nix-1.10-x86_64-linux/:/nix bash -c
DOTFILE_REPO = https://github.com/edude03/dotfiles/archive/master.tar.gz

profile:
	echo "$(INSTALL_DIRECTORY)/bin/proot-x86_64 -b $(INSTALL_DIRECTORY)/nix-mnt/nix-1.10-x86_64-linux/:/nix bash -c \"source ~/.nix-profile/etc/profile.d/nix.sh; zsh\" " > ~/.profile

dotfiles:
	mkdir ~/dotfiles; \
	cd ~/dotfiles; \
	curl -L $(DOTFILE_REPO) | tar xvz; \
	# I'm sure there's a more elegant way to do this...
	mv ~/dotfiles/dotfiles-master/* ~/dotfiles
	rm -rf ~/dotfiles/dotfiles-master

	# Not technically part of the dotfiles config, but configure the nix
	# symlink so it can install our packages
	mkdir ~/.nixpkgs
	ln -s ~/dotfiles/nix/config.nix ~/.nixpkgs/config.nix

install: $(INSTALL_DIRECTORY)/bin/proot-x86_64 $(INSTALL_DIRECTORY)/nix-mnt dotfiles
	 $(CHROOT_RUN) "cd /nix && ./install && nix-env -iA nixpkgs.all"

$(INSTALL_DIRECTORY)/bin/proot-x86_64: $(INSTALL_DIRECTORY)
	cd $(INSTALL_DIRECTORY)/bin; \
	wget $(PROOT_BINARY); \
	chmod u+x proot-x86_64;

$(INSTALL_DIRECTORY)/nix-mnt: $(INSTALL_DIRECTORY)
	cd $(INSTALL_DIRECTORY)/nix-mnt; \
	wget $(NIX_BINARY); \
	tar xvjf nix-*bz2;

$(INSTALL_DIRECTORY):
	mkdir -p $(INSTALL_DIRECTORY)/{bin, nix-mnt}

.PHONY: profile dotfiles install
