{ config, pkgs, inputs, ... }:

{
  hardware.bluetooth.enable = true;
  
  imports = [
    "${inputs.nixpkgs}/nixos/modules/services/hardware/sane_extra_backends/brscan4.nix"
    inputs.self.nixosModules.sway
  ];
  hardware.sane = {
    brscan4.enable = true;
    enable = true;
  };

  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };
  services.xserver.windowManager.i3.enable = true;
  services.xserver.displayManager.startx.enable = true;

  # Sound settings
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  hardware.pulseaudio.enable = false;

  services.blueman.enable = true;
  
  # Allows for storing secrets in gnome-keyring.
  services.dbus.packages = [ pkgs.gcr ];

  environment.systemPackages = with pkgs; [
    brightnessctl
    clang
    ffmpeg-full
    firefox
    graphviz
    pavucontrol
    # Is there a way to specify this "near" podman?
    podman-compose
    # For pactl, because pw-cli etc don't have convenient volume-setting stuff yet
    pulseaudio
    texlive.combined.scheme-full
    tmate
    virt-manager
    xorg.xauth
    xterm
    zoom-us
  ];
    
  programs.dconf.enable = true;
  fonts.fontconfig = {
    defaultFonts = {
      monospace = [ "Fira Code" ];
      emoji = [ "Noto Color Emoji" ];
      sansSerif = [ "DejaVu Sans" ];
      serif = [ "DejaVu Serif" ];
    };
  };
    
  # TODO: split virtualisation into a separate module
  virtualisation.podman = {
    enable = true;
    #dockerCompat = true;
  };
  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;
  
  hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
  };
}