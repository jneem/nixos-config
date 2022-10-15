{ config, pkgs, inputs, ... }:

{
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.supportedFilesystems = [ "zfs" ];
  services.nfs.server.enable = true;
  services.zfs.autoScrub.enable = true;
}
