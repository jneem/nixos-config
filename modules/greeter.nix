{ lib, pkgs, config, ... }:

let
  cfg = config.greeter;
in
{
  options.greeter.hyprland = {
    enable = lib.mkEnableOption "Hyprland autologin";
    user = lib.mkOption {
      type = lib.types.attrs;
      description = "HomeManager configuration of the user to auto-login";
      example = "config.home-manager.users.jneeman";
    };
  };

  options.greeter.gdm = {
    enable = lib.mkEnableOption "GDB greeter";
  };
  
  config = {
    services.greetd = lib.mkIf cfg.hyprland.enable {
      enable = true;
      settings = rec {
        initial_session = {
          command = "${cfg.hyprland.user.wayland.windowManager.hyprland.package}/bin/Hyprland";
          user = cfg.hyprland.user.home.username;
        };
        # FIXME: figure out how to just not have a default session
        default_session = initial_session;
      };
    };

    # TODO: error if both are specified
    services.xserver = lib.mkIf cfg.gdm.enable {
      enable = true;
      displayManager.gdm = {
        enable = true;
        wayland = true;
        autoSuspend = false;
      };
      displayManager.defaultSession = "gnome";
      desktopManager.gnome.enable = true;
    };
  };
}

