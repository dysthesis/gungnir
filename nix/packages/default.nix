{
  self,
  lib,
  pkgs,
  ...
}: {
  # Default configurations
  dwm-default = pkgs.callPackage ./dwm.nix {inherit self lib;};
  dmenu-default = pkgs.callPackage ./dmenu.nix {inherit self lib;};
  st-default = pkgs.callPackage ./st.nix {inherit self lib;};

  # Personal configurations
  dwm = pkgs.callPackage ./dwm.nix {
    inherit self lib;
    config-file = "${self}/config/personal/dwm-config.h";
  };
  dmenu = pkgs.callPackage ./dmenu.nix {
    inherit self lib;
    config-file = "${self}/config/personal/dmenu-config.h";
  };
  st = pkgs.callPackage ./st.nix {
    inherit self lib;
    config-file = "${self}/config/personal/st-config.h";
  };
  dwm-bar = pkgs.callPackage ./dwm-bar.nix {inherit pkgs lib;};
}
