{
  self,
  config-file ? "${self}/config/default/dwm-config.h",
  lib,
  stdenv,
  libX11,
  libXinerama,
  libXft,
  dwm,
}: let
  inherit (lib.babel) filesInDir;
in
  stdenv.mkDerivation rec {
    pname = "dwm";
    version = "6.5";

    src = "${self}/src/dwm";

    patches = filesInDir "${src}/patches";

    postPatch =
      /*
      sh
      */
      ''
        cp ${config-file} config.h
      '';

    strictDeps = true;

    buildInputs = [
      libX11
      libXinerama
      libXft
    ];

    installFlags = ["PREFIX=$(out)"];

    meta.mainProgram = "dwm";
  }
