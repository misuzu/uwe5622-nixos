# uwe5622-ng kernel module for NixOS

## Usage

```nix
# in your flake
inputs.uwe5622-nixos.url = "github:misuzu/uwe5622-nixos";

# in your NixOS configuration
imports = [
  inputs.uwe5622-nixos.nixosModules.uwe5622
  inputs.uwe5622-nixos.nixosModules.orangepi-zero3-dts-overlay
];
```

## Does this actually work?

Yes! Only on OrangePi Zero3 for now though and only on kernel 6.18 (LTS). Tested on nixos-unstable.

## Related projects

- [`uwe5622`](https://github.com/armbian/uwe5622): AW859A / UWE5622 Linux driver.
- [`uwe5622-ng`](https://github.com/LinuxMint-User/uwe5622-ng): AW859A / UWE5622 Linux driver (used here).
- [`orangepi-zero-3-dtb-neo`](https://github.com/LinuxMint-User/orangepi-zero-3-dtb-neo): Board device tree for Orange Pi Zero 3 (Allwinner H618): additive patch on top of the mainline DTS, plus a frozen self-contained DTS.
