{ config, pkgs, lib, ... }:
{
  hardware.deviceTree = {
    enable = true;
    filter = "sun50i-h618-orangepi-zero3.dtb";
    overlays = [
      {
        name = "orangepi-zero3-uwe5622";
        dtsFile = ./orangepi-zero3-uwe5622.dts;
      }
    ];
  };
}
