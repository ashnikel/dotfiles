# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Include the necessary packagesand configuration for Apple Silicon support.
#      ./apple-silicon-support
#      <home-manager/nixos>
#      ./home.nix
    ];

      nix = {
        gc = {
          automatic = true;
          dates = "daily";
          options = "--delete-older-than 14d";
        };
      };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 30;
  boot.loader.efi.canTouchEfiVariables = false;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  networking.hostName = "nixos"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];
  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "ru_RU.UTF-8/UTF-8"
    "en_DK.UTF-8/UTF-8"
  ];

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  #  services.xserver.enable = true;
#  services.xserver.displayManager.enable = false;
#  services.xserver.windowManager.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.ash = {
     isNormalUser = true;
     extraGroups = [ "wheel" "networkmanager" "input" ]; # Enable ‘sudo’ for the user.
     shell = pkgs.fish;
     packages = with pkgs; [
       tree
     ];
   };

  programs.amnezia-vpn.enable = true;
  programs.hyprland.enable = true;
  programs.fish.enable = true;
#  programs.regreet.enable = true;


#####################
programs.regreet = {
  enable = true;

  settings = {
    background = {
      path = "/etc/background2.png";
      fit = "Cover";
    };

    GTK = {
      application_prefer_dark_theme = true;

      cursor_theme_name = "Adwaita";
      cursor_blink = true;

      font_name = "Cantarell 16";
      icon_theme_name = "Adwaita";
#      theme_name = "Adwaita-dark";
    };

    appearance = {
      greeting_msg = "Welcome back!";
    };

    commands = {
      reboot = [ "systemctl" "reboot" ];
      poweroff = [ "systemctl" "poweroff" ];
      x11_prefix = [ "startx" "/usr/bin/env" ];
    };

    widget = {
      clock = {
        format = "%a %H:%M";
        resolution = "500ms";
        timezone = "Europe/Moscow";
        label_width = 150;
      };
    };
  };
};

#####################

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    ashell
    blueberry
    git
    hyprlock
    networkmanagerapplet
    pavucontrol
    playerctl
    usbutils
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
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
  services.upower.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  hardware.asahi.peripheralFirmwareDirectory = ./firmware;

  networking.wireless.iwd = {
    enable = true;
    settings.General.EnableNetworkConfiguration = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?


# --- SWAP SETTINGS FOR APPLE SILICON (8GB RAM) --- #

zramSwap = {
  enable = true;
  memoryPercent = 50;
  priority = 100;
};

swapDevices = [
  {
    device = "/swapfile";
    priority = 10;
  }
];

boot.kernel.sysctl = {
  "vm.swappiness" = 10;
  "vm.vfs_cache_pressure" = 50;
  "vm.page-cluster" = 2;
};


}
