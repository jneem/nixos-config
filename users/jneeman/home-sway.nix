{ config, pkgs, ... }:

{
  home = {
    file = {
      dragonfly = {
        source = ./dragonfly.jpg;
        target = "/home/jneeman/.local/share/wallpapers/dragonfly.jpg";
      };
    };

    packages = with pkgs; [
      chromium
      darktable
      gnome.eog
      gimp
      gnome3.adwaita-icon-theme
      grim
      inkscape
      libreoffice
      lutris
      mpv
      networkmanagerapplet
      slack
      slurp
      xdg-utils
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
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
  };

  programs.waybar = {
    enable = true;
    style = ./waybar-style.css;
    settings = [{
      layer = "top";
      position = "bottom";
      height = 32;
      modules-left = [ "sway/workspaces" "sway/mode" ];
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
    }];
  };
  services.swayidle =
    let
      swaylock = "${pkgs.swaylock.outPath}/bin/swaylock";
      swaymsg = "${pkgs.sway.outPath}/bin/swaymsg";
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
          timeout = 310;
          command = "${swaylock} -f -c 000000";
        }
        {
          timeout = 300;
          command = "${swaymsg} 'output * dpms off'";
          resumeCommand = "${swaymsg} 'output * dpms on'";
        }
      ];
    };
  programs.mako.enable = true;
  wayland.windowManager.sway = {
    config = {
      modifier = "Mod4";
      bars = [{
        command = "${pkgs.waybar}/bin/waybar";
      }];
      input = {
        "type:touchpad" = {
          click_method = "clickfinger";
        };
      };
      gaps = {
        smartBorders = "on";
      };
      keybindings =
        let modifier = config.wayland.windowManager.sway.config.modifier;
        in
        pkgs.lib.mkOptionDefault {
          "${modifier}+0" = "workspace number 10";
          "${modifier}+Ctrl+1" = "workspace number 11";
          "${modifier}+Ctrl+2" = "workspace number 12";
          "${modifier}+Ctrl+3" = "workspace number 13";
          "${modifier}+Ctrl+4" = "workspace number 14";
          "${modifier}+Ctrl+5" = "workspace number 15";
          "${modifier}+Ctrl+6" = "workspace number 16";
          "${modifier}+Ctrl+7" = "workspace number 17";
          "${modifier}+Ctrl+8" = "workspace number 18";
          "${modifier}+Ctrl+9" = "workspace number 19";
          "${modifier}+Ctrl+0" = "workspace number 20";
          "${modifier}+Shift+0" = "move container to workspace number 10";
          "${modifier}+Ctrl+Shift+1" = "move container to workspace number 11";
          "${modifier}+Ctrl+Shift+2" = "move container to workspace number 12";
          "${modifier}+Ctrl+Shift+3" = "move container to workspace number 13";
          "${modifier}+Ctrl+Shift+4" = "move container to workspace number 14";
          "${modifier}+Ctrl+Shift+5" = "move container to workspace number 15";
          "${modifier}+Ctrl+Shift+6" = "move container to workspace number 16";
          "${modifier}+Ctrl+Shift+7" = "move container to workspace number 17";
          "${modifier}+Ctrl+Shift+8" = "move container to workspace number 18";
          "${modifier}+Ctrl+Shift+9" = "move container to workspace number 19";
          "${modifier}+Ctrl+Shift+0" = "move container to workspace number 20";
          "${modifier}+x" = "exec ${pkgs.firefox-wayland}/bin/firefox";
          "XF86MonBrightnessUp" = ''exec "${pkgs.brightnessctl}/bin/brightnessctl set +5%"'';
          "XF86MonBrightnessDown" = ''exec "${pkgs.brightnessctl}/bin/brightnessctl set 5%-"'';
          "XF86AudioRaiseVolume" = ''exec "${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%"'';
          "XF86AudioLowerVolume" = ''exec "${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%"'';
          "XF86AudioMute" = ''exec "${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle"'';
        };
      workspaceOutputAssign = [
        { workspace = "1"; output = "DP-1"; }
        { workspace = "2"; output = "DP-1"; }
        { workspace = "3"; output = "DP-1"; }
        { workspace = "4"; output = "DP-1"; }
        { workspace = "5"; output = "DP-1"; }
        { workspace = "6"; output = "DP-1"; }
        { workspace = "7"; output = "DP-1"; }
        { workspace = "8"; output = "DP-1"; }
        { workspace = "9"; output = "DP-1"; }
        { workspace = "10"; output = "DP-1"; }
        { workspace = "11"; output = "HDMI-A-1"; }
        { workspace = "12"; output = "HDMI-A-1"; }
        { workspace = "13"; output = "HDMI-A-1"; }
        { workspace = "14"; output = "HDMI-A-1"; }
        { workspace = "15"; output = "HDMI-A-1"; }
        { workspace = "16"; output = "HDMI-A-1"; }
        { workspace = "17"; output = "HDMI-A-1"; }
        { workspace = "18"; output = "HDMI-A-1"; }
        { workspace = "19"; output = "HDMI-A-1"; }
        { workspace = "20"; output = "HDMI-A-1"; }
      ];
      window.commands = [
        { criteria = { class = "Slack"; }; command = "move container to workspace 11"; }
      ];
      menu = "${pkgs.bemenu}/bin/bemenu-run | ${pkgs.findutils}/bin/xargs swaymsg exec --";
      terminal = "${pkgs.alacritty}/bin/alacritty";
      seat = {
        seat0 = {
          hide_cursor = "when-typing enable";
          xcursor_theme = "Curlossal 128";
        };
      };
      startup =
        [
          { command = "systemctl --user restart gnome-keyring.service"; always = true; }
          { command = "systemctl --user restart swayidle.service"; always = true; }
          { command = "${pkgs.blueman}/bin/blueman-applet"; }
          { command = "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"; }
        ];
      output = {
        "*" = { bg = "~/.local/share/wallpapers/dragonfly.jpg fill"; };
        "DP-1" = {
          position = "2560,0";
        };
        "HDMI-A-1" = {
          position = "0,800";
        };
      };
    };
    enable = true;
    wrapperFeatures.gtk = true;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
    };
  };

  xdg.systemDirs.data =
    let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in
    [ "${schema}/share/gsettings-schemas/${schema.name}" ];

}
