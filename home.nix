{ config, pkgs, ... }:

{
    home.stateVersion = "25.05";

    home.packages = with pkgs; [
     _1password-gui
     bat
     btop
     dig
     dysk
     eza
     fastfetch
     fd
     hyprpaper
     moor
     obsidian
     pcmanfm
     ripgrep
     starship
     telegram-desktop
     tealdeer
     walker
     waybar
     xclip
     zed-editor
    ];

    programs.firefox = {
      enable = true;
      profiles.default = {
        isDefault = true;
	settings = {
	  "browser.startup.homepage" = "https://nixos.org";
	  "privacy.trackingprotection.enabled" = true;
	};
      };
    };

    programs.fish = {
      enable = true;
      shellAliases = {
        la = "exa -a --icons";
        ll = "exa -lh --icons --git";
        lla = "exa -lha --icons --git";
	ls = "exa --icons --git";
	gs = "git status";
	tree = "exa -lT --icons";
	v = "nvim";
      };
      shellInit = ''
        set -gx EDITOR nvim
      '';
    };

    programs.git = {
      enable = true;
      settings.user.name = "Viktor Medvedik";
      settings.user.email = "ashnikel@gmail.com";
      extraConfig.init.defaultBranch = "main";
    };

    programs.kitty = {
      enable = true;
      settings = {
        font_family = "JetBrainsMono Nerd Font";
	confirm_os_window_close = 0;
      };
    };

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    programs.starship.enable = true;
    programs.zoxide.enable = true;

#    programs.home-manager.enable = true;
}
