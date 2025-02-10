{
	self,
  stdenv,
  libX11,
  libXinerama,
  libXft,
  zlib,
}:
stdenv.mkDerivation {
  pname = "dmenu";
  version = "5.3";

  src = "${self}/src/dmenu";

  strictDeps = true;

  buildInputs = [
    libX11
    libXinerama
    zlib
    libXft
  ];

  installFlags = [ "PREFIX=$(out)" ];

  meta.mainProgram = "dmenu_run";
}
