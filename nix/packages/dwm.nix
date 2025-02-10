{
  self,
  lib,
  stdenv,
  libX11,
  libXinerama,
  libXft,
}: let
	inherit
		(builtins)
		readDir
		attrNames
		map
		;
	inherit
    (lib)
    filterAttrs
    ;
in stdenv.mkDerivation rec {
  pname = "dwm";
  version = "6.5";

  src = "${self}/src/dwm";

	patches = let
		patchesDir = "${src}/patches";
	in patchesDir
			|> readDir
			|> filterAttrs (_name: value: value == "regular")
			|> attrNames
			|> (xs: map (x: "${patchesDir}/${x}") xs);

  strictDeps = true;

  buildInputs = [
    libX11
    libXinerama
    libXft
  ];

  installFlags = ["PREFIX=$(out)"];

  meta.mainProgram = "dwm";
}
