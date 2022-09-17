# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
    
  systemd.coredump = {
    enable = true;
    # Big core dumps (especially from chromium) make things unresponsive.
    extraConfig =  ''
        ProcessSizeMax=100M
    '';
  };
    
  hardware.bluetooth.enable = true;
  hardware.sane = {
    brscan4.enable = true;
    enable = true;
  };

  networking.hostName = "zeus"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
    
  # Enable flakes
  nix = {
    package = pkgs.nixFlakes;
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes ca-derivations
    '';
  };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  # Configure keymap in X11
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
  services.dbus.packages = [ pkgs.gcr ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jneeman = {
    isNormalUser = true;
    description = "Joe Neeman";
    shell = pkgs.fish;
    extraGroups = [ "docker" "networkmanager" "wheel" "video" "scanner" "lp" "libvirtd" ];
  };
  home-manager.users.jneeman = { pkgs, ... }:
  {
    imports = [ ./home.nix ];
  };
  home-manager.useGlobalPkgs = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bat
    brightnessctl
    clang
    entr
    fd
    ffmpeg-full
    file
    firefox
    git
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    gst_all_1.gstreamer
    gst_all_1.gstreamer.dev
    graphviz
    helix
    htop
    httpie
    libfaketime
    pavucontrol
    # Is there a way to specify this "near" podman?
    podman-compose
    povray
    # For pactl, because pw-cli etc don't have convenient volume-setting stuff yet
    pulseaudio
    rnix-lsp
    texlive.combined.scheme-full
    tmate
    vim
    virt-manager
    winePackages.staging
    wget
    xorg.xauth
    xterm
    zoom-us
  ];
    

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.dconf.enable = true;
  programs.fish.enable = true;
    
  fonts.fonts = with pkgs; [
    dejavu_fonts
    fira-code
    fira-code-symbols
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
    
  powerManagement.powertop.enable = true;

  # List services that you want to enable:

  services.rpcbind.enable = true; # needed for NFS

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leavecatenate(variables, "bootdev", bootdev)
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

  nix.settings.auto-optimise-store = true;
  # Binary Cache for Haskell.nix
  nix.settings.trusted-public-keys = [
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
    ];
  nix.settings.substituters = [
      "https://cache.iog.io"
    ];
    
  security.sudo = {
    enable = true;
    execWheelOnly = true;
    extraRules = [
      {
        users = [ "jneeman" ];
        commands = [ { command = "ALL"; options = [ "NOPASSWD" ]; } ];
      }
    ];
  };
    
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
