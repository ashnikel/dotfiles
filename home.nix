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
     file
     fd
     hyprpaper
     moor
     obsidian
     pcmanfm
     qview
     ripgrep
     starship
     telegram-desktop
     tealdeer
     walker
     waybar
     wl-clipboard
     zathura
     zed-editor
    ];

    home.sessionVariables = {
      OZONE_PLATFORM = "wayland";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      NIXOS_OZONE_WL = "1";
      XDG_SESSION_TYPE = "wayland";
      GDK_BACKEND = "wayland";
    };

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

    programs.vscode = {
      enable = true;
      package = pkgs.vscode;
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
        p = "wl-paste";
        pb = "wl-paste | head";
      };
      shellInit = ''
        set -gx EDITOR nvim
      '';

    # Пользовательские функции

  # Функция c — копирует файл, если указан
  functions.c = ''
    if test (count $argv) -eq 0
        # Нет аргументов — читаем из stdin
        wl-copy
    else
        set file $argv[1]
        if test -f "$file"
            echo "📋 Копирую файл: $file"
            cat "$file" | wl-copy
        else
            echo "❌ Файл не найден: $file"
            return 1
        end
    end
  '';

 # Функция clast — копирует последний изменённый текстовый файл
    functions.clast = ''
      set last (eza --sort=modified --reverse | head -n 1)

      if test -z "$last"
          echo "❌ Нет файлов в текущей директории"
          return 1
      end

      set mimetype (file --mime-type -b "$last")

      if string match -q "text/*" $mimetype
          echo "📋 Копирую текстовый файл: $last ($mimetype)"
          cat "$last" | wl-copy
      else
          echo "⚠️ Файл $last не текстовый ($mimetype) — пропускаю"
      end
    '';
    };

    programs.git = {
      enable = true;
      settings.user.name = "Viktor Medvedik";
      settings.user.email = "ashnikel@gmail.com";
      settings.init.defaultBranch = "main";
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

programs.waybar = {
  enable = true;

  settings = {
    mainBar = {
      layer = "top";
      position = "top";
      height = 28;
      margin = "6 40 0 40";
      spacing = 8;

      modules-left = [ "hyprland/workspaces" "hyprland/window" ];
      modules-center = [ "clock" ];
      modules-right = [
        "temperature"
        "cpu"
        "memory"
        "network"
        "pulseaudio"
        "keyboard-state"
        "battery"
        "tray"
      ];

      "clock" = {
        format = "{:%H:%M}";
        tooltip-format = "{:%A, %d %B %Y}";
      };

      "cpu" = {
        format = " {usage}%";
      };

      "memory" = {
        format = " {used:0.1f} GB";
      };

      "temperature" = {
        hwmon-path = "/sys/class/thermal/thermal_zone0/temp";
        critical-threshold = 75;
        format = " {temperatureC}°C";
      };

      "network" = {
        format-wifi = " {essid}";
        format-ethernet = "󰈀 {ifname}";
        format-disconnected = "󰖪 offline";
        tooltip-format = "{ifname} via {gwaddr}";
      };

      "pulseaudio" = {
        format = "{icon} {volume}%";
        format-icons = [ "" "" "" ];
        on-click = "pavucontrol";
      };

      "keyboard-state" = {
        numlock = false;
        capslock = true;
        format = "{layout} {icon}";
        format-icons = {
          "us" = "🇺🇸";
          "ru" = "🇷🇺";
        };
        tooltip = false;
      };

      "battery" = {
        format = "{icon} {capacity}%";
        format-icons = [ "" "" "" "" "" ];
      };
    };
  };

  style = ''
    * {
      font-family: JetBrainsMono Nerd Font, sans-serif;
      font-size: 13px;
      color: #D8DEE9;
    }

    window#waybar {
      background: rgba(46, 52, 64, 0.85);
      border: 1px solid rgba(67, 76, 94, 0.8);
      border-radius: 10px;
      padding: 4px 10px;
      margin: 6px 40px 0 40px;
    }

    #workspaces button {
      background: transparent;
      color: #B0BEC5;
      padding: 0 8px;
      border-radius: 6px;
      transition: all 0.2s ease;
    }

    #workspaces button.active {
      background: #81A1C1;
      color: #ECEFF4;
    }

    #workspaces button:hover {
      background: rgba(129,161,193,0.25);
      color: #ECEFF4;
    }

    #clock, #cpu, #memory, #temperature, #pulseaudio, #keyboard-state,
    #network, #battery, #tray {
      margin: 0 8px;
      padding: 0 6px;
    }

    #keyboard-state {
      font-weight: 600;
      color: #EBCB8B;
    }

    tooltip {
      background: #3B4252;
      border: 1px solid #4C566A;
      border-radius: 6px;
      color: #ECEFF4;
    }
  '';
};

    programs.starship.enable = true;
    programs.zoxide.enable = true;


    services.hyprpaper = {
      enable = true;
      settings = {
        preload = [
          "${config.home.homeDirectory}/dotfiles/wallpapers/01.png"
        ];
        wallpaper = [
          "eDP-1,${config.home.homeDirectory}/dotfiles/wallpapers/01.png"
        ];
        splash = false;
        ipc = "off";
      };
    };

#    programs.home-manager.enable = true;
}
