{ config, pkgs, ... }:

{
  imports = [
    ./home/walker.nix
  ];

  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    _1password-gui
    bat
    bibata-cursors
    brightnessctl
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
    networkmanager_dmenu
    nixfmt
    nordic
    #     nordzy-cursor-theme
    obsidian
    pcmanfm
    qview
    ripgrep
    starship
    telegram-desktop
    tealdeer
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
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
  };

  home.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";

    HYPRCURSOR_THEME = "Bibata-Modern-Classic";
    HYPRCURSOR_SIZE = "24";
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

    settings = {
      # Общий вид
      font = "Inter 11"; # можешь поменять на JetBrainsMono Nerd Font 10

      anchor = "top-right"; # позиция: правый верхний угол
      margin = "10"; # отступ от края экрана
      padding = "10,16"; # внутренние отступы: вертикальный, горизонтальный
      width = 360; # ширина уведомления
      height = 120; # максимальная высота (можно убрать, если не нужно)
      "border-radius" = 8;

      # Nord-базовые цвета
      "background-color" = "#2E3440"; # Nord0
      "text-color" = "#ECEFF4"; # Nord6
      "border-color" = "#88C0D0"; # Nord8 (акцент)
      "border-size" = 2;

      # Таймауты
      "default-timeout" = 5000; # 5 секунд
      "ignore-timeout" = false;

      # Иконки
      icons = true;
      "icon-location" = "left";
      "max-icon-size" = 32;
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

        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];
        modules-center = [ "clock" ];
        modules-right = [
          "hyprland/language"
          "temperature"
          "cpu"
          "memory"
          "battery"
          "network"
          "pulseaudio"
          "backlight"
          "tray"
        ];

        "clock" = {
          format = "{:%H:%M • %a %d %b}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          locale = "en_DK.UTF-8";

          calendar = {
            mode = "month";
            on-scroll = 1;
            format = {
              # Выделение сегодняшнего дня (Nord-цвет)
              today = "<span color='#88C0D0'><b><u>{}</u></b></span>";
            };
          };

          actions = {
            "on-scroll-up" = "shift_up"; # прокрутка вверх → следующий месяц
            "on-scroll-down" = "shift_down"; # прокрутка вниз → предыдущий месяц
            "on-click-right" = "mode"; # ПКМ по часам → переключение month/year
          };
        };

        "cpu" = {
          format = "  {usage}%";
          states = {
            warning = 70;
            critical = 90;
          };
        };

        "memory" = {
          format = "  {percentage}%";
          tooltip-format = "RAM: {used:.1f} / {total:.1f} GB ({percentage}%)\nSWAP: {swapUsed:.1f} / {swapTotal:.1f} GB ({swapPercentage}%)";
          states = {
            warning = 70;
            critical = 90;
          };
        };

        "temperature" = {
          hwmon-path = "/sys/class/thermal/thermal_zone0/temp";
          critical-threshold = 75;
          format = " {temperatureC}°C";
          states = {
            warning = 55;
            critical = 70;
          };
        };

        "network" = {
          format-wifi = "{icon}  {signalStrength}% {essid}";
          format-ethernet = "󰈀  {ifname}";
          format-disconnected = "󰖪  offline";

          format-icons = {
            wifi = [
              "󰤯" # 0–20%
              "󰤟" # 20–40%
              "󰤢" # 40–60%
              "󰤥" # 60–80%
              "󰤨" # 80–100%
            ];
            ethernet = "󰈀";
          };
          tooltip-format = ''
            {ifname}
            ESSID: {essid}
            Signal: {signalStrength}%
            IP: {ipaddr}
            Gateway: {gwaddr}
            Down: {bandwidthDownBits} bits/s
            Up:   {bandwidthUpBits} bits/s
          '';
          #on-click = "nm-connection-editor";
          on-click = "networkmanager_dmenu";
        };

        "pulseaudio" = {
          format = "{icon}   {volume}%";
          format-muted = "󰝟   {volume}%";

          format-icons = [
            ""
            ""
            ""
          ];
          headphone = [ "" ];
          on-click = "pavucontrol";
          reverse-scrolling = true;
          scroll-step = 0.1;
        };

        "backlight" = {
          format = "{icon}  {percent}%";

          format-icons = [
            "󰃞"
            "󰃟"
            "󰃠"
          ];

          reverse-scrolling = true;
          #scroll-step = 0.1;
          #interval = 1;
        };

        "hyprland/language" = {
          format = "{}";
          format-en = "US";
          format-ru = "RU";
          tooltip = false;

          keyboard-name = "apple-spi-keyboard";
          on-click = "hyprctl switchxkblayout apple-spi-keyboard next";
        };

        "battery" = {
          format = "{icon} {capacity}%";
          format-charging = "󰚥 {capacity}%";
          format-icons = [
            "󰂎" # 0–10%
            "󰁺" # 10–25%
            "󰁼" # 25–40%
            "󰁽" # 40–60%
            "󰁿" # 60–80%
            "󰂁" # 80–95%
            "󰁹" # 95–100%
          ];

          states = {
            warning = 30;
            critical = 15;
          };
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

              #battery, #cpu, #memory, #temperature {
                color: #ECEFF4;
                background: transparent;
                margin: 0 8px;
              }

              #battery.warning, #cpu.warning, #memory.warning, #temperature.warning {
                color: #EBCB8B;
                background: transparent;
              }

              #battery.critical {
                animation: blink-red 1.2s infinite;
                color: #BF616A;
                background: transparent;
              }

              #cpu.critical, #memory.critical, #temperature.critical {
                color: #BF616A;
                background: transparent;
              }

              #battery.charging {
                color: #A3BE8C;
                background: transparent;
              }

              #backlight, #clock, #language, #network, #pulseaudio {
                padding: 2px 6px;
                margin: 4px 8px 4px 0px;
                background: #3B4252;
                border-radius: 8px;
              }

              #network.disconnected {
                background: #3B4252;
                color: #BF616A; /* Nord red */
              }

              @keyframes blink-red {
                0% { color: #BF616A; }
                50% { color: #2E3440; } /* фон панели */
                100% { color: #BF616A; }
              }
    '';
  };

  programs.starship.enable = true;
  programs.zoxide.enable = true;

  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [
        "${config.home.homeDirectory}/dotfiles/wallpapers/misty_mountains.jpg"
      ];
      wallpaper = [
        "eDP-1,${config.home.homeDirectory}/dotfiles/wallpapers/misty_mountains.jpg"
      ];
      splash = false;
      ipc = "off";
    };
  };

  #    programs.home-manager.enable = true;

}
