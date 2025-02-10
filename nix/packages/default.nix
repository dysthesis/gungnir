{
  self,
  pkgs,
  ...
}: {
  dwm = pkgs.callPackage ./dwm.nix {inherit self;};
}
