{ config, pkgs, ... }:

{
    home.stateVersion = "25.05";

    home.packages = with pkgs; [
     _1password-gui
     bat
     bibata-cursors
     btop
     dig
     dysk
     eza
     fastfetch
     file
     fd
     hyprpaper
     hyprshot
     moor
     nordic
#     nordzy-cursor-theme
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

    programs.yazi = {
      enable = true;
    };

gtk.cursorTheme = {
  name = "Bibata-Modern-Ice";
  package = pkgs.bibata-cursors;
  size = 32;
};

home.sessionVariables = {
  HYPRCURSOR_THEME = "Bibata-Modern-Ice";
  HYPRCURSOR_SIZE = "32";
};

gtk = {
  enable = true;
  theme = {
    name = "Nordic";
    package = pkgs.nordic;
  };
  iconTheme = {
    name = "Nordzy";
    package = pkgs.nordzy-icon-theme;
  };
};

services.mako = {
  enable = true;
  backgroundColor = "#3B4252";
  textColor = "#ECEFF4";
  borderColor = "#5E81AC";
  borderSize = 2;
  defaultTimeout = 5000;
  padding = "10";
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

    functions.y = ''
          set tmp (mktemp -t "yazi-cwd.XXXXX")
          yazi $argv --cwd-file="$tmp"

          if test -f "$tmp"
              set cwd (cat "$tmp")
              if test -n "$cwd"; and test "$cwd" != "$PWD"
                  cd -- "$cwd"
              end
          end

          rm -f "$tmp"
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
      margin = "0 0 0 0";
      spacing = 6;

      modules-left = [ "hyprland/workspaces" "hyprland/window" ];
      modules-center = [ "clock" ];
      modules-right = [
	"hyprland/language"
        "temperature"
        "cpu"
        "memory"
        "network"
        "pulseaudio"
        "battery"
        "tray"
      ];

      "clock" = {
        format = "{:%H:%M}";
        tooltip-format = "{:%A, %d %B %Y}";
      };

      "cpu" = {
        format = "   {usage}%";
      };

      "memory" = {
        format = "   {used:0.1f} GB";
      };

      "temperature" = {
        hwmon-path = "/sys/class/thermal/thermal_zone0/temp";
        critical-threshold = 75;
        format = "  {temperatureC}°C";
      };

      "network" = {
        format-wifi = "   {essid}";
        format-ethernet = "󰈀  {ifname}";
        format-disconnected = "󰖪  offline";
        tooltip-format = "{ifname} via {gwaddr}";
      };

      "pulseaudio" = {
        format = "{icon}  {volume}%";
        format-icons = [ "" "" "" ];
        on-click = "pavucontrol";
      };

      "hyprland/language" = {
        format = "{}";
	format-en = "US";
	format-ru = "RU";
	tooltip = false;
      };

      "battery" = {
        format = "{icon}  {capacity}%";
        format-icons = [ "" "" "" "" "" ];
      };
    };
  };
style = ''
        * {
          border: none;
          color: #ECEFF4;
          font-family: "Inter";
          font-size: 14px;
        }

        window#waybar {
          background: rgba(46, 52, 64, 0.5);
        }

        #workspaces button {
          padding: 2px 6px;
          margin: 4px;
          background: #3B4252;
          color: #D8DEE9;
          border-radius: 6px;
        }

        #workspaces button.active {
          background: #5E81AC;
        }

	#tray {
	  margin-right: 10px;
	}

        #clock, #language, #network, #pulseaudio, #battery {
          padding: 2px 6px;
          margin: 4px 8px 4px 0px;
          background: #3B4252;
          border-radius: 8px;
        }
      '';
};

    programs.starship.enable = true;
    programs.zoxide.enable = true;


    services.hyprpaper = {
      enable = true;
      settings = {
        preload = [
          "${config.home.homeDirectory}/dotfiles/wallpapers/jinx-arcane.jpg"
        ];
        wallpaper = [
          "eDP-1,${config.home.homeDirectory}/dotfiles/wallpapers/jinx-arcane.jpg"
        ];
        splash = false;
        ipc = "off";
      };
    };

#    programs.home-manager.enable = true;
}
