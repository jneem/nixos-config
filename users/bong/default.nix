{ inputs, pkgs, ... }:

{
  imports = [ inputs.home-manager.nixosModule ];

  users.users.bong = {
    isNormalUser = true;
    description = "Mai Tran-Neeman";
    shell = pkgs.bash;
    extraGroups = [ "video" "scanner" "lp" ];

  };

  home-manager.users.bong = {
    home = {
      username = "bong";
      homeDirectory = "/home/bong";
      stateVersion = "23.05";

      packages = with pkgs; [
        gimp
        inkscape
        libreoffice
        tuxtype
        vlc
      ];
    };

    programs.firefox = {
      enable = true;
      package = pkgs.firefox.override {
        cfg = {
          enableGnomeExtensions = true;
        };
      };
    };
  };

  home-manager.useGlobalPkgs = true;
}
