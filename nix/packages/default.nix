{
  self,
  lib,
  pkgs,
  ...
}: let
  sources = import ./npins;
in {
  # Default configurations
  dwm-default = pkgs.callPackage ./dwm.nix {inherit self lib;};
  dmenu-default = pkgs.callPackage ./dmenu.nix {inherit self lib;};
  st-default = pkgs.callPackage ./st.nix {inherit self lib;};

  dwl-default = pkgs.callPackage ./dwl.nix {
    inherit self lib;
    inherit (sources) dwl;
  };

  # Personal configurations
  dwm = {
    borderpx ? 1,
    topbar ? 0,
    font ? "CartographCF Nerd Font",
    fontSize ? 12,
    colours ? {
      gray1 = "#080808";
      gray2 = "#191919";
      gray3 = "#2A2A2A";
      gray4 = "#444444";
      cyan = "#708090";
      white = "#ffffff";
    },
    scratchpads ? [],
  }:
    pkgs.callPackage ./dwm.nix {
      inherit self lib;
      config-file = import ../../config/personal/dwm.nix {
        inherit lib pkgs;
        config = {inherit borderpx topbar font fontSize colours scratchpads;};
      };
    };
  dmenu = {
    fontSize ? 12,
    font ? "JBMono Nerd Font",
    lineHeight ? 32,
  }:
    pkgs.callPackage ./dmenu.nix {
      inherit self lib;
      config-file = import ../../config/personal/dmenu.nix {
        inherit lib pkgs;
        config = {inherit fontSize font lineHeight;};
      };
    };

  st = {
    fontSize ? 12,
    font ? "JBMono Nerd Font",
    borderpx ? 30,
    fontScale ? {
      width = 1.0;
      height = 1.2;
    },
    colours ? {
      normal = {
        black = "#080808";
        red = "#D70000";
        green = "#789978";
        orange = "#FFAA88";
        blue = "#7788AA";
        magenta = "#D7007D";
        cyan = "#708090";
        white = "#DEEEED";
      };
      bright = {
        black = "#444444";
        red = "#D70000";
        green = "#789978";
        orange = "#FFAA88";
        blue = "#7788AA";
        magenta = "#D7007D";
        cyan = "#708090";
        white = "#DEEEED";
      };
      foreground = "#FFFFFF";
      background = "#000000";
      highlight = "#F5E0DC";
    },
  }:
    pkgs.callPackage ./st.nix {
      inherit self lib;
      config-file = import ../../config/personal/st.nix {
        inherit lib pkgs;
        config = {inherit fontSize fontScale font borderpx colours;};
      };
    };

  dwm-bar = pkgs.callPackage ./dwm-bar.nix {inherit pkgs lib;};
}
