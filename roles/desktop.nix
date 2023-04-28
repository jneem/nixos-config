{ config, pkgs, pkgs-unstable, inputs, ... }:

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
    pkgs.unstable.zoom-us
  ];

  programs.dconf.enable = true;

  fonts.fonts = with pkgs; [
    dejavu_fonts
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
  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "embedded-udev-rules";
      text = ''
        ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3748", TAG+="uaccess"
        ATTRS{idVendor}=="303a", ATTRS{idProduct}=="1001", TAG+="uaccess"
      '';
      destination = "/etc/udev/rules.d/69-probe.rules";
    })
  ];

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
