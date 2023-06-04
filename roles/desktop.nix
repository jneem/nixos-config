{ config, pkgs, inputs, ... }:

{
  hardware.bluetooth.enable = true;

  imports = [
    "${inputs.nixpkgs}/nixos/modules/services/hardware/sane_extra_backends/brscan4.nix"
    inputs.self.nixosModules.hyprland
    inputs.probe-rs-rules.nixosModules.default
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
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.brlaser pkgs.epson-escpr2 ];
  hardware.pulseaudio.enable = false;
  
  services.hardware.bolt.enable = true;
  hardware.keyboard.zsa.enable = true;

  services.avahi.enable = true;
  services.blueman.enable = true;

  # Allows for storing secrets in gnome-keyring.
  services.dbus.packages = [ pkgs.gcr ];

  environment.systemPackages = with pkgs; [
    bemenu
    swaybg
    blender
    brightnessctl
    clang
    comma
    ffmpeg-full
    firefox
    gdb
    graphviz
    jq
    neovim
    pavucontrol
    # Is there a way to specify this "near" podman?
    podman-compose
    prusa-slicer
    # For pactl, because pw-cli etc don't have convenient volume-setting stuff yet
    pulseaudio
    texlive.combined.scheme-full
    tmate
    unzip
    virt-manager
    wally-cli
    xorg.xauth
    xournalpp
    xterm
    zoom-us
  ];

  programs.dconf.enable = true;

  fonts.fonts = with pkgs; [
    dejavu_fonts
    input-fonts
    fira-code
    fira-code-symbols
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    noto-fonts-extra
    font-awesome
  ];

  fonts.fontconfig = {
    defaultFonts = {
      monospace = [ "Fira Code" ];
      emoji = [ "Noto Color Emoji" ];
      sansSerif = [ "DejaVu Sans" ];
      serif = [ "DejaVu Serif" ];
    };
  };

  # User access for STLink and ESP32C3 probes
  hardware.probe-rs.enable = true;
  services.udisks2.enable = true;

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
