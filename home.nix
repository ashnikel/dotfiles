{ config, pkgs, ... }:

{
  imports = [
    ./home/kitty.nix
    ./home/walker.nix
    ./home/waybar.nix
  ];

  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    _1password-gui
    ansible
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

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
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
