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
    package = pkgs.nixFlakes;
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes ca-derivations
    '';
  };

  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.utf8";

  environment.systemPackages = with pkgs; [
    bat
    entr
    fd
    file
    git
    helix
    htop
    httpie
    libfaketime
    p7zip
    rnix-lsp
    vim
    wget
  ];
    
  programs.dconf.enable = true;
  programs.fish.enable = true;

  system.stateVersion = "22.05"; # Did you read the comment?

  nix.settings.auto-optimise-store = true;

  security.sudo = {
    enable = true;
    execWheelOnly = true;
  };
}