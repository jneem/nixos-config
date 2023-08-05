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
  };

  time.timeZone = pkgs.lib.mkDefault "America/Chicago";
  i18n.defaultLocale = "en_US.utf8";

  environment.systemPackages = with pkgs; [
    bat
    entr
    fd
    file
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

  nix.settings.auto-optimise-store = true;

  security.sudo = {
    enable = true;
    execWheelOnly = true;
  };
}