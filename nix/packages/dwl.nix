{
  self,
  lib,
  installShellFiles,
  libX11,
  libdrm,
  dbus,
  fcft,
  tllist,
  libinput,
  libxcb,
  libxkbcommon,
  pixman,
  pkg-config,
  stdenv,
  testers,
  wayland,
  wayland-protocols,
  wayland-scanner,
  wlroots,
  writeText,
  xcbutilwm,
  xwayland,
  extraPackages ? [],
  # Boolean flags
  enableXWayland ? true,
  withCustomConfigH ? (configH != null),
  # Configurable options
  configH ?
    if conf != null
    then
      lib.warn ''
        conf parameter is deprecated;
        use configH instead
      ''
      conf
    else null,
  # Deprecated options
  # Remove them before next version of either Nixpkgs or dwl itself
  conf ? null,
  dwl,
  ...
}:
# If we set withCustomConfigH, let's not forget configH
assert withCustomConfigH -> (configH != null);
  stdenv.mkDerivation (finalAttrs: {
    pname = "dwl";
    version = "0.7";

    src = dwl;
    patches = lib.babel.filesInDir "${self}/patches/dwl";

    nativeBuildInputs = [
      installShellFiles
      pkg-config
      wayland-scanner
    ];

    buildInputs =
      [
        libinput
        libxcb
        libxkbcommon
        pixman
        wayland
        wayland-protocols
        wlroots
        # bar patch
        fcft
        tllist
        libdrm
        # bar-systray patch
        dbus
      ]
      ++ lib.optionals enableXWayland [
        libX11
        xcbutilwm
        xwayland
      ]
      ++ extraPackages;

    outputs = ["out"];

    postPatch = let
      configFile =
        if lib.isDerivation configH || builtins.isPath configH
        then configH
        else writeText "config.h" configH;
    in
      lib.optionalString withCustomConfigH "cp ${configFile} config.h";

    makeFlags =
      [
        "PKG_CONFIG=${stdenv.cc.targetPrefix}pkg-config"
        "WAYLAND_SCANNER=wayland-scanner"
        "PREFIX=$(out)"
      ]
      ++ lib.optionals enableXWayland [
        ''XWAYLAND="-DXWAYLAND"''
        ''XLIBS="xcb xcb-icccm"''
      ];

    # NOTE: Uncomment this to get source code for inspection
    # installPhase = ''
    #   runHook preInstall
    #   mkdir -p $out/src
    #   cp -R . $out/src
    #   runHook postInstall
    # '';

    strictDeps = true;

    # required for whitespaces in makeFlags
    __structuredAttrs = true;

    passthru = {
      tests.version = testers.testVersion {
        package = finalAttrs.finalPackage;
        # `dwl -v` emits its version string to stderr and returns 1
        command = "dwl -v 2>&1; return 0";
      };
    };

    meta = {
      homepage = "https://codeberg.org/dwl/dwl";
      changelog = "https://codeberg.org/dwl/dwl/src/branch/${finalAttrs.version}/CHANGELOG.md";
      description = "Dynamic window manager for Wayland";
      longDescription = ''
        dwl is a compact, hackable compositor for Wayland based on wlroots. It is
        intended to fill the same space in the Wayland world that dwm does in X11,
        primarily in terms of philosophy, and secondarily in terms of
        functionality. Like dwm, dwl is:

        - Easy to understand, hack on, and extend with patches
        - One C source file (or a very small number) configurable via config.h
        - Tied to as few external dependencies as possible
      '';
      license = lib.licenses.gpl3Only;
      inherit (wayland.meta) platforms;
      mainProgram = "dwl";
    };
  })
# TODO: custom patches from upstream website

