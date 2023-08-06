{ pkgs, config, ... }:

{
  programs.hyprland.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    SDL_VIDEODRIVER = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
  };

}