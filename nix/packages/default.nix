{
  self,
  pkgs,
  ...
}: {
  dwm = pkgs.callPackage ./dwm.nix {inherit self;};
  dmenu = pkgs.callPackage ./dmenu.nix {inherit self;};
  st = pkgs.callPackage ./st.nix {inherit self;};
}
