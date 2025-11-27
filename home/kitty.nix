{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;

    settings = {
      # как было
      font_family = "JetBrainsMono Nerd Font";
      confirm_os_window_close = 0;

      ######## NORD BASE ########
      background = "#2E3440"; # Nord0
      foreground = "#D8DEE9"; # Nord4

      cursor = "#D8DEE9";
      selection_background = "#4C566A";
      selection_foreground = "#ECEFF4";

      url_color = "#88C0D0"; # Nord8

      # Можно немного подправить рамки и табы под Nord
      active_border_color = "#88C0D0";
      inactive_border_color = "#4C566A";
      bell_border_color = "#D08770";

      tab_bar_style = "powerline";
      tab_bar_background = "#2E3440";
      active_tab_background = "#3B4252";
      active_tab_foreground = "#ECEFF4";
      inactive_tab_background = "#2E3440";
      inactive_tab_foreground = "#7E818A";

      # Если захочешь лёгкую прозрачность — раскомментируй:
      # background_opacity = "0.95";

      ######## NORD PALETTE (16 COLORS) ########
      color0 = "#3B4252"; # dark grey
      color1 = "#BF616A"; # red
      color2 = "#A3BE8C"; # green
      color3 = "#EBCB8B"; # yellow
      color4 = "#81A1C1"; # blue
      color5 = "#B48EAD"; # magenta
      color6 = "#88C0D0"; # cyan
      color7 = "#E5E9F0"; # light grey

      color8 = "#4C566A"; # dark grey (bright)
      color9 = "#BF616A"; # red (bright)
      color10 = "#A3BE8C"; # green (bright)
      color11 = "#EBCB8B"; # yellow (bright)
      color12 = "#81A1C1"; # blue (bright)
      color13 = "#B48EAD"; # magenta (bright)
      color14 = "#8FBCBB"; # cyan (bright)
      color15 = "#ECEFF4"; # white (bright)
    };
  };
}
