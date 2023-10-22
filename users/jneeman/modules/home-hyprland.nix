{ config, pkgs, inputs, ... }:

{
  _module.args.inputs = inputs;
  imports = [ ./home.nix ];
  home = {
    file = {
      dragonfly = {
        source = ./dragonfly.jpg;
        target = "/home/jneeman/.local/share/wallpapers/dragonfly.jpg";
      };
    };

    packages = with pkgs; [
      brightnessctl
      chromium
      darktable
      firefox-wayland
      gnome.eog
      gimp
      gnome3.adwaita-icon-theme
      grim
      inkscape
      libreoffice
      lutris
      mpv
      networkmanagerapplet
      pulseaudio
      slack
      slurp
      xdg-utils
      vlc
      wl-clipboard
      zathura
    ];

    pointerCursor = {
      package = pkgs.curlossal;
      name = "Curlossal";
      size = 128;
      gtk.enable = true;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      cursor-size = 128;
      cursor-theme = "Curlossal";
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal = {
          family = "Input Mono";
          style = "Regular";
        };

        bold = {
          family = "Input Mono";
          style = "Bold";
        };

        italic = {
          family = "Input Mono";
          style = "Italic";
        };

        bold_italic = {
          family = "Input Mono";
          style = "Bold Italic";
        };

        size = 14;
      };
    };
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
  };

  programs.git = {
    extraConfig = {
      credential.helper = "${
          pkgs.git.override { withLibsecret = true; }
        }/bin/git-credential-libsecret";
    };
  };

  services.mako.enable = true;

  programs.waybar = {
    enable = true;
    style = ./waybar-style.css;
    package = pkgs.waybar.overrideAttrs (oa: {
      mesonFlags = (oa.mesonFlags or  []) ++ [ "-Dexperimental=true" ];
      patches = (oa.patches or []) ++ [
        (pkgs.fetchpatch {
          name = "fix waybar hyprctl";
          url = "https://aur.archlinux.org/cgit/aur.git/plain/hyprctl.patch?h=waybar-hyprland-git";
          sha256 = "sha256-pY3+9Dhi61Jo2cPnBdmn3NUTSA8bAbtgsk2ooj4y7aQ=";
        })
      ];
    });
    settings = {
      mainBar = {
        layer = "top";
        position = "bottom";
        height = 32;
        modules-left = [ "hyprland/workspaces" ];
        modules-right = [ "disk" "memory" "cpu" "network" "pulseaudio" "battery" "backlight" "clock" "tray" "idle_inhibitor" ];
        battery = {
          format = "{icon} {capacity}%";
          format-good = "{icon} {capacity}%";
          format-full = " {capacity}%";
          format-icons = [ "" "" "" "" "" ];
          interval = 30;
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            "activated" = "";
            "deactivated" = "";
          };
        };
        backlight = {
          device = "intel_backlight";
          format = " {percent}%";
          interval = 60;
        };
        network = {
          format = "{bandwidthUpBytes:>}  {bandwidthDownBytes:>} ";
          interval = 1;
        };
        pulseaudio = {
          format = "{icon} {volume}%";
          format-bluetooth = "{icon} {volume}%";
          format-muted = "()";
          interval = 60;

          format-icons = {
            default = [ "" ];
          };
        };

        clock = {
          interval = 10;
          format = "{:%H:%M %Y-%m-%d (%a)}";
        };

        cpu = {
          interval = 1;
          format = "{icon0}{icon1}{icon2}{icon3}{icon4}{icon5}{icon6}{icon7}";
          format-icons = [ "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
        };

        disk = {
          interval = 60;
          format = " {free}";
        };

        memory = {
          format = " {percentage}%";
        };
      };
    };
  };

  services.swayidle =
    let
      swaylock = "${pkgs.swaylock-effects.outPath}/bin/swaylock";
      # hyprctl = "${pkgs.hyprland.outPath}/bin/hyprctl";
    in
    {
      enable = true;
      events = [
        {
          event = "before-sleep";
          command = "${swaylock} -f -c 000000";
        }
      ];
      timeouts = [
        {
          timeout = 300;
          command = "${swaylock} -f -c 000000 --grace 10";
        }
        # FIXME: track down the hyprctl bug
        # {
        #   timeout = 300;
        #   command = "${hyprctl} dispatch dpms off";
        #   resumeCommand = "${hyprctl} dispatch dpms on";
        # }
      ];
    };

  wayland.windowManager.hyprland = {
    enable = true;
    systemdIntegration = true;
    extraConfig = builtins.readFile ./hyprland.conf;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "org.pwmt.zathura.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
    };
  };

  xdg.systemDirs.data =
    let
      schema = pkgs.gsettings-desktop-schemas;
    in
    [ "${schema}/share/gsettings-schemas/${schema.name}" ];

  services.gnome-keyring = {
    enable = true;
    components = [ "secrets" "ssh" ];
  };

}
