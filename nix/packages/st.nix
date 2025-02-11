{
  self,
  lib,
  stdenv,
  fontconfig,
  harfbuzz,
  freetype,
  libX11,
  libXcursor,
  libXft,
  ncurses,
  pkg-config,
}: let
  inherit (lib.babel) filesInDir;
in
  stdenv.mkDerivation rec {
    pname = "st";
    version = "0.9.2";

    src = "${self}/src/st";

    patches = filesInDir "${src}/patches";

    strictDeps = true;

    nativeBuildInputs = [
      freetype
      ncurses
      pkg-config
    ];

    buildInputs = [
      harfbuzz
      fontconfig
      libX11
      libXcursor
      libXft
    ];

    installFlags = ["PREFIX=$(out)"];

    env.TERMINFO = "${placeholder "out"}/share/terminfo";

    meta.mainProgram = "st";
  }
