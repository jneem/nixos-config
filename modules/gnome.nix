{ pkgs, config, ... }:

{
  services.xserver.enable = true;
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };
  services.xserver.displayManager.defaultSession = "gnome";
  services.xserver.desktopManager.gnome.enable = true;
}