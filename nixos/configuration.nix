# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      "${builtins.fetchTarball "https://github.com/nix-community/disko/archive/master.tar.gz"}/module.nix"
      ./disk-config.nix      
    ];

  # Bootloader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = [ pkgs.linuxPackages_latest , pkgs.linuxPackages_lts ];
    initrd = {
      kernelModules = [ "btrfs" "exfat" "usb_storage" "uas" ];
      supportedFilesystems = [ "btrfs" "vfat" "exfat" ];
      luks.devices = {
        crypt0 = {
          device = "/dev/disk/by-uuid/";
          preLVM = true;
          allowDiscards = true;
          keyFile = "/dev/disk/by-uuid/6CF7-6192:/.keys/lv0.key";
        };
        crypttabExtraOpts = [ "keyfile-timeout=5s" ];
      };
    };
    kernelParams = [ "rw" "root=/dev/vg1/lv0" "rootflags=subvol=@" "intel_iommu=on" "iommu=pt" "resume=/dev/vg1/swp0" ];
  };

  # Enable networking
  networking = {
    networkmanager.enable = true;
    hostName = "silverhand"; # define hostname.

    wireless = {
      enable = true; # enable wireless support via wpa_supplicant
    };

    interfaces = {
      enp8s0 = {
        ipv4.addresses = [{
          address = "192.168.0.2";
          prefixLength = 24;
          nameservers = [ "194.242.2.3" "192.168.0.1" ];
          defaultGateway = "192.168.0.1";
        }];
      };
    };

    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 80 443 ];
      trustedInterfaces = [ "lo" ];
    };
  };

  # Set your time zone.
  time.timeZone = "Canada/Eastern";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  hardware = {
    enableAllFirmware = true;
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPkgs = with pkgs; [ "intel-media-driver" "intel-vaapi-driver" ];
    };
  };

  services = {
    xserver = {
      enable = true;
      autorun = false;
      xkb.layout = "us";
      xkb.variant = "";
      videoDrivers = [ "modesetting" ];
      desktopManager.plasma6.enable = true;
      displayManager.sddm.enable = true;
    };

    openssh = {
      enable = true;
      permitRootLogin = "no";
    };
  
    # Enable the KDE Plasma Desktop Environment.
    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;
    
    # enable cups to print shit
    printing.enable = true;
    
    # enable sound with pipewire
    pulseaudio.enable = false;
    rtkit.enable = true;
    
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      #jack.enable = true;
      #media-session.enable = true;
    };
  };

  # configure user accounts
  users.users.j = {
    isNormalUser = true;
    description = "jacob";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
    ];

    initialHashedPassword = "$y$j9T$.TwhpvoNYVWYHSEjokQW/1$N/yMwStCdTMUkkjUVU2OKXk/I4h4LBAAGK0993EeRe/";
    packages = with pkgs; [
    ];
  };

  # set root password
  users.users.root = {
    initialHashedPassword = "$y$j9T$CIyOpmbDlWt1SZl/8hEYq0$ZeBkU9Y1fHCISV8UkdJVDMsdGRlB9oUv4NFsiLml81.";
  };

  # Install firefox.
  programs = {
    git = {
      enable = true;
      userName = "sudosteak";
      userEmail = "github.failing562@passmail.net";
    };

    steam = {
      enable = true;
    };

    firefox = {
      enable = true;
    };

    zsh.ohMyZsh = {
      enable = true;
      theme = "af-magic";
      
      plugins = [
        "git"
        "sudo"
        "man"
        "python"
      ];
      
      enableCompletion = true;
      enableSyntaxHighlighting = true;
      customPkgs = [
        pkgs.zsh-syntax-highlighting
        pkgs.nix-zsh-completions
      ];
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    neovim
    curl
    htop
    vim
    ffmpeg
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
