_: {
  projectRootFile = "flake.nix";
  programs = {
    alejandra.enable = true;
    deadnix.enable = true;
    shfmt = {
      enable = true;
      indent_size = 4;
    };
  };
}
