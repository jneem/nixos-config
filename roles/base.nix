{ config, pkgs, inputs, ... }:

{
  systemd.coredump = {
    enable = true;
    # Big core dumps (especially from chromium) make things unresponsive.
    extraConfig =  ''
        ProcessSizeMax=100M
    '';
  };

  networking.networkmanager.enable = true;

  # Enable flakes
  nix = {
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ]; # needed for nix-shell -p <sth> to work
    package = pkgs.nixFlakes;
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes ca-derivations
    '';

    settings = {
      auto-optimise-store = true;
      substituters = [
        "https://cache.nixos.org/" "https://devenv.cachix.org" "https://helix.cachix.org" "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  time.timeZone = pkgs.lib.mkDefault "America/Chicago";
  i18n.defaultLocale = "en_US.utf8";

  environment.systemPackages = with pkgs; [
    bat
    entr
    fd
    file
    fzf
    git
    gitui
    helix
    htop
    libfaketime
    nil
    p7zip
    xh
    vim
    wget
  ];

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-unikey fcitx5-gtk ];
  };
    
  programs.dconf.enable = true;
  programs.fish.enable = true;


  security.sudo = {
    enable = true;
    execWheelOnly = true;
  };
}
