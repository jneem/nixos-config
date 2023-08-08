{ inputs, config, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.self.nixosModules.boot.systemd
    inputs.self.nixosModules.greeter
    inputs.self.nixosRoles.base
    inputs.self.nixosRoles.desktop
    inputs.self.nixosUsers.jneeman.hyprland
    (inputs.nixos-hardware + "/dell/xps/13-9310")
  ];


  config = {
    boot.loader.efi.efiSysMountPoint = "/boot/efi";

    greeter.hyprland = {
      enable = true;
      user = config.home-manager.users.jneeman;
    };
  };
  
}
