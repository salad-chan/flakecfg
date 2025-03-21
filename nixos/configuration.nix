# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" "https://cache.nixos.org"];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # AMD gpu driver
  boot.initrd.kernelModules = [ "amdgpu" ];

  networking.hostName = "system"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8"; LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.user = {
    isNormalUser = true;
    description = "user";
    extraGroups = [ "networkmanager" "wheel" "input" ];
    packages = with pkgs; [];
    initialHashedPassword = "$y$j9T$SbIfG.PMqcppUk8LBe1q9.$JSEjQHCANc3fBwDx92NhTP71lkurNUS9EUAPKRUHAD7";
  };

  users.users.root = {
    initialHashedPassword = "$y$j9T$Kk30oumJKar0YCVz7k3a3/$TzeX8MkGRGQffGoCc0YEYljCPX6bCermxeYQ5slWmGB";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  # Base
    git
  # neovim # using NVF right now

  # Hyprland
    kitty

  # Basic Hypr Eco system
    dunst
    pipewire
    wireplumber
    hyprpolkitagent

  # Additions to hypr
    rofi-wayland
    copyq
    kdePackages.dolphin
    wl-clipboard

  # utilities
    hypridle
    hyprlock
    waybar
    hyprcursor
    hyprutils
    hyprwayland-scanner
    hyprland-qtutils
    hyprgraphics
    hyprsysteminfo
    hyprsunset
    hyprlang

  # Screenshot utils
    grim
    slurp

  # Fonts and etc.
    font-awesome
    nerd-fonts.zed-mono

  # Sound GUI
    pavucontrol

  # User
    firefox
    keepassxc
    obsidian
    vesktop
    zed-editor
    vlc
    qbittorrent
  ];

  # Enabling Programs here instead of in packages
  # stuff goes here

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
  system.stateVersion = "24.11"; # Did you read the comment?

  programs.hyprland = {
    enable = true;
    # I dont know if i need this
    xwayland.enable = true;
    # set the flake package
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  nix.gc = {
    automatic = true;  # Enable automatic garbage collection
    dates = "weekly";  # Schedule (daily, weekly, or a cron expression)
    options = "--delete-older-than 7d";  # Keep only the last 7 days of generations
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Automatic Hyprland start up
  programs.hyprland.withUWSM = true;

  # For games
  services.xserver.videoDrivers = [ "amdgpu" ];

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;

  programs.gamemode.enable = true;

  # Virtual Machines
  programs.virt-manager.enable = true;

  users.groups.libvirtd.members = [ "user" ];

  virtualisation.libvirtd.enable = true;

  virtualisation.spiceUSBRedirection.enable = true;
  
  # Bluetooth
  hardware.bluetooth.enable = true;

  hardware.bluetooth.powerOnBoot = true;

  services.blueman.enable = true;

  # nvim NVF

  programs.nvf = {
    enable = true;
    settings = {
      vim.theme = {
        enable = true;
	name = "gruvbox";
	style = "dark";
      };

      vim.autocomplete.nvim-cmp.enable = true;

      vim.languages = {
        enableLSP = true;
	enableTreesitter = true;

	nix.enable = true;
	clang.enable = true;
      };
      
    };
  };
}
