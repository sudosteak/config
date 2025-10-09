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
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "silverhand"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Canada/Eastern";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Enable the X11 windowing system.
  services = {
    xserver = {
      enable = true;
      xkb.layout = "us";
      xkb.variant = "";
    };
    wayland = {
      enable = true;
    };
  
    # Enable the KDE Plasma Desktop Environment.
    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;
    
    # enable cups to print shit
    printing.enable = true;
    
    # Enable virtualization

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
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
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
    firefox = {
      enable = true;
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    neovim
    git
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
