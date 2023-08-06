{ ... }:

{
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "/home/jneeman/.nix-profile/bin/Hyprland";
        user = "jneeman";
      };
      default_session = initial_session;
    };
  };
}

