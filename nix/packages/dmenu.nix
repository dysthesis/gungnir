{
  self,
  config-file ? "${self}/config/default/dmenu-config.h",
  lib,
  stdenv,
  libX11,
  libXinerama,
  libXft,
  zlib,
}: let
  inherit (lib.babel) filesInDir;
in
  stdenv.mkDerivation rec {
    pname = "dmenu";
    version = "5.3";

    src = "${self}/src/dmenu";

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
      zlib
      libXft
    ];

    installFlags = ["PREFIX=$(out)"];

    meta.mainProgram = "dmenu_run";
  }
