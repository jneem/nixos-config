{ pkgs, config, ... }:

{
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "/home/jneeman/.nix-profile/bin/Hyprland";
        user = "jneeman";
      };
      default_session = initial_session;
    };
  };

  programs.hyprland.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    SDL_VIDEODRIVER = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
  };

}