{ config, pkgs, lib, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages_6_18;

  boot.extraModulePackages = [ (config.boot.kernelPackages.callPackage ./package.nix { }) ];

  # https://github.com/orangepi-xunlong/linux-orangepi/issues/98
  boot.extraModprobeConfig = "options sprdwl_ng disable_powersave=1";

  boot.kernelModules = [
    "sunxi_addr"
    "sprdwl_ng"
    "sprdbt_tty"
  ];

  hardware.firmware = [ (pkgs.callPackage ./firmware.nix { }) ];

  networking.wireless = {
    # Ignore 802.11v BSS transition requests from the AP: roaming on such a
    # request can leave the driver stuck in CONNECTING until the module is
    # reloaded.  The driver fix (armbian/uwe5622 d07ad7b..9f150cd) is not in
    # this tree.  https://github.com/orangepi-xunlong/linux-orangepi/issues/98
    extraConfig = "disable_btm=1";
  };

  networking.networkmanager.wifi = {
    backend = "wpa_supplicant";
    macAddress = "stable";
    scanRandMacAddress = false;
  };
}
