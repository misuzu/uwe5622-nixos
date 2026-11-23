{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  kernel,
  kernelModuleMakeFlags,
  firmwarePath ? "/run/current-system/firmware",
}:

let
  kdir = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
in
stdenv.mkDerivation {
  pname = "uwe5622-ng";
  version = "0-unstable-2026-10-29-${kernel.modDirVersion}";

  src = fetchFromGitHub {
    owner = "LinuxMint-User";
    repo = "uwe5622-ng";
    rev = "aa6879b7a5db65b34aa49de630f2725a6a7b5d57";
    hash = "sha256-c0+wURYzqxj9ABSnDDIdWzJi8ozcUwqk3CichDtEi7A=";
  };

  patches = [
    # https://github.com/orangepi-xunlong/linux-orangepi/issues/98
    (fetchpatch {
      name = "disable-powersave-module-option.patch";
      url = "https://github.com/armbian/uwe5622/commit/84a30174375bdc7ed9bf84179cbbd155b3f7db48.patch";
      hash = "sha256-gSEr7QbxjSZMkM4JiWMAW+x6bsIM+OiDOeBrVsdMUzM=";
    })
  ];

  nativeBuildInputs = kernel.moduleBuildDependencies;
  hardeningDisable = [
    "pic"
    "format"
  ];

  postPatch = ''
    substituteInPlace unisocwifi/rf_marlin3.c \
      --replace-fail '"/lib/firmware"' '"${firmwarePath}"'
    substituteInPlace unisocwcn/platform/rf/rf.c \
      --replace-fail '"/lib/firmware/' '"${firmwarePath}/'
    substituteInPlace unisocwcn/platform/wcn_boot.c \
      --replace-fail '"/lib/firmware/"' '"${firmwarePath}/"'
  '';

  makeFlags = kernelModuleMakeFlags ++ [
    "KDIR=${kdir}"
    "UNISOC_FW_PATH_CONFIG=\"${firmwarePath}/\""
  ];

  enableParallelBuilding = false;
  preBuild = ''
    makeFlagsArray+=(SRC="$PWD" BUILDSRC="$PWD" JOBS="$NIX_BUILD_CORES")
  '';

  installPhase = ''
    runHook preInstall
    for d in unisocwcn unisocwifi tty-sdio addr_mgt; do
      make -C ${kdir} $makeFlags M="$PWD/$d" \
        INSTALL_MOD_PATH=$out INSTALL_MOD_DIR=extra/uwe5622 \
        modules_install
    done
    rm -f $out/lib/modules/*/modules.*
    runHook postInstall
  '';

  meta = {
    description = "Unisoc UWE5622 WiFi and Bluetooth driver (out-of-tree, mainline kernels)";
    homepage = "https://github.com/LinuxMint-User/uwe5622-ng";
    license = lib.licenses.gpl2Only;
    platforms = [ "aarch64-linux" ];
  };
}
