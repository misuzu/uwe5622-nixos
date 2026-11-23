{
  lib,
  runCommand,
  armbian-firmware,
}:

runCommand "uwe5622-firmware-${armbian-firmware.version}"
  {
    # The driver reads wifi_2355b001_1ant.ini with filp_open(), not through
    # the firmware loader, so it cannot see a compressed copy.
    passthru.compressFirmware = false;
    meta = {
      description = "Firmware and configuration for the Unisoc UWE5622 (from armbian-firmware)";
      inherit (armbian-firmware.meta) license;
      platforms = lib.platforms.linux;
    };
  }
  ''
    src=${armbian-firmware}/lib/firmware
    install -Dm644 -t $out/lib/firmware \
      $src/uwe5622/wcnmodem.bin \
      $src/uwe5622/wifi_2355b001_1ant.ini \
      $src/bt_configure_pskey.ini

    # Bluetooth: the second byte of feature_set must be 0xFE, otherwise the
    # chip advertises park mode, Write_Default_Link_Policy fails with 0x12
    # and hci0 stays in HCI_SETUP (see the README).
    sed -i -E 's/^(feature_set *= *0x[0-9A-Fa-f]+, *)0x[0-9A-Fa-f]+/\10xFE/' \
      $out/lib/firmware/bt_configure_pskey.ini
    grep -Eq '^feature_set *= *0x[0-9A-Fa-f]+, *0xFE' \
      $out/lib/firmware/bt_configure_pskey.ini
  ''
