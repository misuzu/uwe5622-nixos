final: prev:
let
  kernelPatches-6-12 = [
    {
      patch = ./0001-introduce-uwe5622-driver-for-kernel-6.3.patch;
    }
    {
      patch = ./0002-apply-bugfixes-for-uwe5622-driver.patch;
    }
    {
      patch = ./0003-drivers-uwe5622-fix-compilation-on-6.3-kernels.patch;
    }
    {
      patch = ./0004-fix-driver-for-kernel-6.4.patch;
    }
    {
      patch = ./0005-uwe5622-various-warning-and-firmware-path-fixes.patch;
    }
    {
      patch = ./0006-Add-to-section-Makefile-CONFIG_SPARD_WLAN_SUPPORT-uw.patch;
    }
    {
      patch = ./0007-fix-spreadtrum-sprd-bluetooth-broken-park-link-statu.patch;
    }
    {
      patch = ./0008-port-uwe5622-driver-to-kernel-6.1.patch;
    }
    {
      patch = ./0009-wifi-uwe-fix-uwe5622-tty-sdio.patch;
    }
    {
      patch = ./0010-wireless-fix-setting-mac-address-for-netdev-in-uwe56.patch;
    }
    {
      patch = ./0011-wireless-uwe5622-Fix-compilation-with-6.7-kernel.patch;
    }
    {
      patch = ./0012-Patching-kernel-rockchip64-files-drivers-net-wireles.patch;
    }
    {
      patch = ./0013-wireless-uwe5622-Fix-compilation-with-6.11-kernel.patch;
    }
    {
      patch = ./0014-use-DECLARE_FLEX_ARRAY-macro-to-avoid-spanning-write.patch;
    }
    {
      patch = ./0015-arm64-dts-h616-add-wifi-support-for-orange-pi-zero-2.patch;
    }
    {
      patch = ./0016-wireless-uwe5622-https-6xyun.cn-article-orangepi-3b-.patch;
    }
    {
      patch = ./0017-wireless-uwe5622-Fix-Makefiles.patch;
    }
    {
      patch = ./0018-wireless-uwe5622-NixOS-support.patch;
    }
    {
      patch = null;
      structuredExtraConfig = with prev.lib.kernel; {
        AW_BIND_VERIFY = yes;
        AW_WIFI_DEVICE_UWE5622 = yes;
        SPARD_WLAN_SUPPORT = yes;
        SPRDWL_NG = module;
        TTY_OVERY_SDIO = module;
        UNISOC_WIFI_PS = yes;
        WLAN_UWE5621 = module;
        WLAN_UWE5622 = module;
      };
    }
  ];
  kernelPatches-6-18 = [
    { patch = ./0019-Add-sunxi-addr-driver-Used-to-fix-uwe5622-bluetooth-MAC-address.patch; }
    { patch = ./0020-uwe5622-fix-spanning-writes.patch; }
    { patch = ./0021-uwe5622-v6.15-timer-api-changes.patch; }
    { patch = ./0022-uwe5622-v6.16.patch; }
    { patch = ./0023-uwe5622-v6.17.patch; }
    { patch = ./0024-uwe5622-v6.18.patch; }
    { patch = ./0025-arm64-dts-allwinner-h616-Enable-HDMI-on-several-boar.patch; }
    { patch = ./0026-arm64-dts-sun50i-h618-orangepi-zero3-enable-gpu-mali.patch; }
  ];
  applyKernelPatches =
    patches: linuxPackages:
    linuxPackages.extend (
      self: super: {
        kernel = super.kernel.override (originalArgs: {
          kernelPatches = (originalArgs.kernelPatches or [ ]) ++ patches;
        });
      }
    );
in
{
  linuxPackages_6_12_uwe5622_sunxi = applyKernelPatches kernelPatches-6-12 prev.linuxPackages_6_12;
  linuxPackages_6_18_uwe5622_sunxi = applyKernelPatches (
    kernelPatches-6-12 ++ kernelPatches-6-18
  ) prev.linuxPackages_6_18;
  uwe5622-firmware = prev.callPackage ./firmware.nix { };
}
