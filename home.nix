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

    programs.starship.enable = true;
    programs.zoxide.enable = true;


    services.hyprpaper = {
      enable = true;
      settings = {
        preload = [
          "~/dotfiles/wallpapers/01.png"
        ];
        wallpaper = [
          "eDP-1,~/dotfiles/wallpapers/01.png"
        ];
        splash = false;
        ipc = "off";
      };
    };

#    programs.home-manager.enable = true;
}
