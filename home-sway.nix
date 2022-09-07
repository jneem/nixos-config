{ config, pkgs, ... }:

{
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
        modules-right = [ "disk" "memory" "cpu" "pulseaudio" "battery" "backlight" "clock" "tray" "idle_inhibitor" ];
        battery = {
          format =  "{icon} {capacity}%";
          format-good =  "{icon} {capacity}%";
          format-full =  " {capacity}%";
          format-icons = ["" "" "" "" ""];
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
          #format = "{bandwidthUpBytes} {bandwidthDownBytes}";
          interval = 1;
        };
        pulseaudio = {
          format = "{icon} {volume}%";
          format-bluetooth = "{icon} {volume}%";
          format-muted = "()";
          interval = 60;

          format-icons = {
            default = [""];
          };
        };
      
        clock = {
          interval = 10;
          format = "{:%H:%M %Y-%m-%d (%a)}";
        };
    
        cpu = {
          interval = 1;
          format = "{icon0}{icon1}{icon2}{icon3}{icon4}{icon5}{icon6}{icon7}";
          format-icons = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
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
  services.swayidle = let
      swaylock = "${pkgs.swaylock.outPath}/bin/swaylock";
      swaymsg = "${pkgs.sway.outPath}/bin/swaymsg";
    in {
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
        in pkgs.lib.mkOptionDefault {
          "${modifier}+0" = "workspace number 10";
          "${modifier}+Shift+0" = "move container to workspace number 10";
          "${modifier}+x" = "exec ${pkgs.firefox-wayland}/bin/firefox";
          "XF86MonBrightnessUp" = ''exec "${pkgs.brightnessctl}/bin/brightnessctl set +5%"'';
          "XF86MonBrightnessDown" = ''exec "${pkgs.brightnessctl}/bin/brightnessctl set 5%-"'';
          "XF86AudioRaiseVolume" = ''exec "${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%"'';
          "XF86AudioLowerVolume" = ''exec "${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%"'';
          "XF86AudioMute" = ''exec "${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle"'';
        };
      menu = "${pkgs.bemenu}/bin/bemenu-run | ${pkgs.findutils}/bin/xargs swaymsg exec --";
      terminal = "${pkgs.alacritty}/bin/alacritty";
      seat = {
        seat0 = {
          hide_cursor = "when-typing enable";
          xcursor_theme = "Curlossal 160";
        };
      };
      startup = let
        gsettings = "${pkgs.glib}/bin/gsettings";
      in
        [
          { command = "${gsettings} set org.gnome.desktop.interface cursor-theme BigCursor"; }
          { command = "${gsettings} set org.gnome.desktop.interface cursor-size 96"; }
          { command = "systemctl --user restart gnome-keyring.service"; always = true; }
          { command = "systemctl --user restart swayidle.service"; always = true; }
          { command = "${pkgs.blueman}/bin/blueman-applet"; }
          { command = "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"; }
        ];
      output = {
        "*" = { bg = "~/.local/share/wallpapers/dragonfly.jpg fill"; };
      };
    };
    enable = true;
    wrapperFeatures.gtk = true;
  };

}