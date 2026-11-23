{
  outputs = inputs: {
    nixosModules = {
      uwe5622 = ./default.nix;
      orangepi-zero3-dts-overlay = ./orangepi-zero3.nix;
    };
  };
}
