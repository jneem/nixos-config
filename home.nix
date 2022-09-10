{ config, pkgs, ... }:

{
  imports = [ ./home-sway.nix ];

  home = {
    username = "jneeman";
    homeDirectory = "/home/jneeman";
    sessionVariables = {
      EDITOR = "hx";
      NIXOS_OZONE_WL = 1;
      SDL_VIDEODRIVER = "wayland";
      MOZ_ENABLE_WAYLAND = 1;
      #XCURSOR_SIZE = 96;
    };
    file = {
      dragonfly = {
        source = ./dragonfly.jpg;
        target = "${config.home.homeDirectory}/.local/share/wallpapers/dragonfly.jpg";
      };
      #cursor = {
        #source = "${config.home.homeDirectory}/.local/share/icons/BigCursor";
        #target = ".icons/default";
      #};
    };
    stateVersion = "22.05";
    packages = with pkgs; [
      #curlossal
      chromium
      darktable
      fractal
      gnome3.adwaita-icon-theme
      grip
      inkscape
      libsecret
      libreoffice
      lutris
      mpv
      networkmanagerapplet
      pari
      ripgrep
      slack
      slurp
      tmux
      xdg-utils
      wl-clipboard
      zathura
    ];

    #pointerCursor = {
      #package = pkgs.curlossal;
        #inputs.curlossal.packages.${pkgs.system}.default;
      #name = "Curlossal";
      #size = 160;
      #gtk.enable = true;
    #};
  };
    
  programs.home-manager.enable = true;
  
  programs.git = {
    enable = true;
    ignores = [ ".envrc" "untracked-shell.nix" ".direnv" ];
    lfs.enable = true;
    userName = "Joe Neeman";
    userEmail = "joeneeman@gmail.com";
    extraConfig = {
      credential.helper = "${
        pkgs.git.override { withLibsecret = true; }
      }/bin/git-credential-libsecret";
    };
  };
  
  programs.alacritty = {
    enable = true;
  };
  
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  
  programs.exa = {
    enable = true;
    enableAliases = true;
  };
  
  programs.feh.enable = true;
  
  programs.fish = {
    enable = true;
    shellInit = ''
      set fish_greeting
    '';
  };
  
  programs.helix = {
    enable = true;
    package = pkgs.helix;
    settings = {
      theme = "onedark";
      editor.auto-pairs = false;
      editor.cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
      };
    };
    languages = [
      {
        name = "rust";
        file-types = ["rs"];
        indent = { tab-width = 4; unit = "    ";};
      }
      {
        name = "nix";
        file-types = ["nix"];
        indent = { tab-width = 2; unit = "  ";};
      }
    ];
  };
  
  programs.starship = {
    enable = true;
  };
  
    
#  services.dropbox.enable = true;
#    
    
  services.gnome-keyring = {
    enable = true;
    components = ["secrets" "ssh"];
  };
    
    
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
    };
  };
    
  xdg.systemDirs.data = let
    schema = pkgs.gsettings-desktop-schemas;
    datadir = "${schema}/share/gsettings-schemas/${schema.name}";
  in
    [ "${schema}/share/gsettings-schemas/${schema.name}" ];
}
