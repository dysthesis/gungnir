{
  self,
  lib,
  pkgs,
  ...
}: {
  dwm = pkgs.callPackage ./dwm.nix {inherit self lib;};
  dmenu = pkgs.callPackage ./dmenu.nix {inherit self lib;};
  st = pkgs.callPackage ./st.nix {inherit self lib;};
}
