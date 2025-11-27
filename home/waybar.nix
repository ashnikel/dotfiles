{ config, pkgs, ... }:

{
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
}
