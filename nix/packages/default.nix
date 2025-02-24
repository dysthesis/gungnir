{
  self,
  lib,
  pkgs,
  ...
}: let
in {
  # Default configurations
  dwm-default = pkgs.callPackage ./dwm.nix {inherit self lib;};
  dmenu-default = pkgs.callPackage ./dmenu.nix {inherit self lib;};
  st-default = pkgs.callPackage ./st.nix {inherit self lib;};

  # Personal configurations
  dwm = {
    borderpx ? 1,
    topbar ? 0,
    font ? "JBMono Nerd Font",
    fontSize ? 12,
    colours ? {
      gray1 = "#080808";
      gray2 = "#191919";
      gray3 = "#2A2A2A";
      gray4 = "#444444";
      cyan = "#708090";
      white = "#ffffff";
    },
    scratchpads ? [
      rec {
        name = "term";
        class = name;
        isTerm = 1;
        cmd = [
          "st"
          "-n"
          "${class}"
          "-g"
          "190x40"
        ];
        tag = 0;
        floatpos = null;
        key = "t";
      }
      rec {
        name = "btop";
        class = name;
        isTerm = 1;
        cmd = [
          "st"
          "-n"
          "${class}"
          "-g"
          "190x40"
          "-e"
          "btop"
        ];
        tag = 1;
        floatpos = null;
        key = "b";
      }
      rec {
        name = "task";
        class = name;
        isTerm = 1;
        cmd = [
          "st"
          "-n"
          "${class}"
          "-g"
          "190x40"
          "-e"
          "taskwarrior-tui"
        ];
        tag = 2;
        floatpos = null;
        key = "d";
      }
      rec {
        name = "spotify";
        class = name;
        isTerm = 1;
        cmd = [
          "st"
          "-n"
          "${class}"
          "-g"
          "190x40"
          "-e"
          "spotify_player"
        ];
        tag = 3;
        floatpos = null;
        key = "m";
      }
      rec {
        name = "notes";
        class = name;
        isTerm = 1;
        cmd = [
          "st"
          "-n"
          "${class}"
          "-g"
          "190x40"
          "-e"
          "sh"
          "-c"
          "tmux new-session -As Notes -c ~/Documents/Notes/Contents 'direnv exec . nvim'"
        ];
        tag = 4;
        floatpos = null;
        key = "n";
      }
      {
        name = "signal_desktop";
        class = "signal";
        isTerm = 0;
        cmd = [
          "signal-desktop"
        ];
        tag = 5;
        floatpos = "50% 50% 1805W 1203H";
        key = "s";
      }
    ],
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
