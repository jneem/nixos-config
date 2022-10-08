{ pkgs, config, ... }:

{
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "/home/jneeman/.nix-profile/bin/sway";
        user = "jneeman";
      };
      default_session = initial_session;
    };
  };

  # We run the actual sway with home-manager, but for some reason adding this gets
  # swaylock to work: https://github.com/NixOS/nixpkgs/issues/158025
  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [ swaylock ];
  };
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    gtkUsePortal = true;
  };
}