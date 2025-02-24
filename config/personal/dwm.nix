{
  lib,
  pkgs,
  config ? {
    borderpx = 1;
    topbar = 0;
    font = "JBMono Nerd Font";
    fontSize = 12;
    colours = {
      gray1 = "#080808";
      gray2 = "#191919";
      gray3 = "#2A2A2A";
      gray4 = "#444444";
      cyan = "#708090";
      white = "#ffffff";
    };
    scratchpads = [
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
    ];
  },
  ...
}: let
  inherit (pkgs) writeText;
  inherit (lib) fold;
  inherit (builtins) concatStringsSep;
  mkScratchpadCmd = scratchpad:
  /*
  C
  */
  ''
    const char *${scratchpad.name}[] = {${fold (curr: acc: "\"${curr}\", ${acc}") "" scratchpad.cmd}NULL};
  '';

  mkScratchpadEntry = scratchpad:
  /*
  C
  */
  ''
    {"${scratchpad.class}", ${scratchpad.name}},
  '';

  mkScratchpadRule = scratchpad:
  /*
  C
  */
  ''
    {NULL, "${scratchpad.class}", NULL, SPTAG(${toString scratchpad.tag}), 1, ${toString scratchpad.isTerm}, 0, ${
      if (scratchpad.floatpos == null)
      then "NULL"
      else ''
        "${scratchpad.floatpos}"
      ''
    }, -1},
  '';

  mkScratchpadKey = scratchpad:
  /*
  C
  */
  ''
    {MODKEY, XK_${scratchpad.key}, togglescratch, {.ui = ${toString scratchpad.tag}}},

  '';
in
  with config;
    writeText "config.h"
    /*
    C
    */
    ''
      /* See LICENSE file for copyright and license details. */
      #include <X11/XF86keysym.h>
      /* appearance */
      static const unsigned int borderpx = ${toString borderpx}; /* border pixel of windows */
      static const unsigned int snap = 32;    /* snap pixel */
      static const int swallowfloating =
          0;                         /* 1 means swallow floating windows by default */
      static const int showbar = 1;  /* 0 means no bar */
      static const int topbar = ${toString topbar};   /* 0 means bottom bar */
      static int floatposgrid_x = 5; /* float grid columns */
      static int floatposgrid_y = 5; /* float grid rows */
      static const int user_bh = 32; /* 0 means that dwm will calculate bar height, >=
                                       1 means dwm will user_bh as bar height */
      static const char *fonts[] = {
          "${toString font}:pixelsize=${toString fontSize}:antialias=true:autohint=true"};
      static const char dmenufont[] =
          "${toString font}:pixelsize=${toString fontSize}:antialias=true:autohint=true";
      static const char col_gray1[] = "${toString colours.gray1}";
      static const char col_gray2[] = "${toString colours.gray2}";
      static const char col_gray3[] = "${toString colours.gray3}";
      static const char col_gray4[] = "${toString colours.gray4}";
      static const char col_cyan[] = "${toString colours.cyan}";
      static const char col_white[] = "${toString colours.white}";
      static const char *colors[][3] = {
          /*               fg         bg         border   */
          [SchemeNorm] = {col_white, col_gray1, col_gray2},
          [SchemeSel] = {col_white, col_gray2, col_white},
      };

      typedef struct {
        const char *name;
        const void *cmd;
      } Sp;

      ${concatStringsSep "\n" (map mkScratchpadCmd scratchpads)}

      static Sp scratchpads[] = {
         /* name          cmd  */
         ${concatStringsSep "\n" (map mkScratchpadEntry scratchpads)}
      };

      /* tagging */
      static const char *tags[] = {"1", "2", "3", "4", "5", "6", "7", "8", "9"};
      static const unsigned int ulinepad =
          5; /* horizontal padding between the underline and tag */
      static const unsigned int ulinestroke =
          2; /* thickness / height of the underline */
      static const unsigned int ulinevoffset =
          0; /* how far above the bottom of the bar the line should appear */
      static const int ulineall =
          0; /* 1 to show underline on all tags, 0 for just the active ones */

      static const Rule rules[] = {
          /* xprop(1):
           *	WM_CLASS(STRING) = instance, class
           *	WM_NAME(STRING) = title
           */
          /* class     instance      title    tags mask  isfloating  isterminal
             noswallow  floatpos  monitor */
          {"zen", NULL, NULL, 1 << 0, 0, 0, -1, NULL, -1},
          {"vesktop", NULL, NULL, 1 << 2, 0, 0, -1, NULL, -1},
          {".virt-manager-wrapped", NULL, NULL, 1 << 4, 0, 0, -1, NULL, -1},
          {"st-256color", NULL, NULL, 0, 0, 1, 0, NULL, -1},
          ${concatStringsSep "\n" (map mkScratchpadRule scratchpads)}
      };

      /* layout(s) */
      static const float mfact = 0.50; /* factor of master area size [0.05..0.95] */
      static const int nmaster = 1;    /* number of clients in master area */
      static const int resizehints =
          1; /* 1 means respect size hints in tiled resizals */
      static const int lockfullscreen =
          1; /* 1 will force focus on the fullscreen window */

      static const Layout layouts[] = {
          /* symbol     arrange function */
          {"  ", tile}, /* first entry is default */
          {"  ", NULL}, /* no layout function means floating behavior */
          {"   ", monocle},
      };

      /* key definitions */
      #define MODKEY Mod4Mask // Use cmd instead of alt as mod key
      #define TAGKEYS(KEY, TAG)                                                      \
        {MODKEY, KEY, view, {.ui = 1 << TAG}},                                       \
            {MODKEY | ControlMask, KEY, toggleview, {.ui = 1 << TAG}},               \
            {MODKEY | ShiftMask, KEY, tag, {.ui = 1 << TAG}},                        \
            {MODKEY | ControlMask | ShiftMask, KEY, toggletag, {.ui = 1 << TAG}},

      /* helper for spawning shell commands in the pre dwm-5.0 fashion */
      #define SHCMD(cmd)                                                             \
        {                                                                            \
          .v = (const char *[]) { "/bin/sh", "-c", cmd, NULL }                       \
        }

      /* commands */
      static char dmenumon[2] =
          "0"; /* component of dmenucmd, manipulated in spawn() */
      static const char *dmenucmd[] = {
          "dmenu_run", "-m",  dmenumon,  "-fn",  dmenufont, "-nb", col_gray1, "-nf",
          col_white,   "-sb", col_gray2, "-shb", col_gray2, "-sf", col_white, NULL};
      static const char *termcmd[] = {"st", NULL};

      static const char *upbright[] = {"brightnessctl", "set", "5%+", NULL};
      static const char *downbright[] = {"brightnessctl", "set", "5%-", NULL};
      static const char *upvol[] = {"wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@",
                                    "5%+", NULL};
      static const char *downvol[] = {"wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@",
                                      "5%-", NULL};

      #include "movestack.c"
      static const Key keys[] = {
          /* modifier                     key        function        argument */
          {0, XF86XK_AudioRaiseVolume, spawn, {.v = upvol}},
          {0, XF86XK_AudioLowerVolume, spawn, {.v = downvol}},
          {0, XF86XK_MonBrightnessUp, spawn, {.v = upbright}},
          {0, XF86XK_MonBrightnessDown, spawn, {.v = downbright}},
          {MODKEY, XK_r, spawn, {.v = dmenucmd}},
          {MODKEY, XK_Return, spawn, {.v = termcmd}},
          {MODKEY | ShiftMask, XK_Escape, spawn, SHCMD("xsecurelock")},
          /*{MODKEY, XK_b, togglebar, {0}},*/
          {MODKEY, XK_j, focusstack, {.i = +1}},
          {MODKEY, XK_k, focusstack, {.i = -1}},
          {MODKEY, XK_i, incnmaster, {.i = +1}},
          {MODKEY, XK_d, incnmaster, {.i = -1}},
          {MODKEY, XK_h, setmfact, {.f = -0.05}},
          {MODKEY, XK_l, setmfact, {.f = +0.05}},
          {MODKEY | ShiftMask, XK_j, movestack, {.i = +1}},
          {MODKEY | ShiftMask, XK_k, movestack, {.i = -1}},
          {MODKEY | ShiftMask, XK_Return, zoom, {0}},
          {MODKEY, XK_Tab, view, {0}},
          {MODKEY, XK_q, killclient, {0}},
          {MODKEY, XK_t, setlayout, {.v = &layouts[0]}},
          {MODKEY, XK_f, setlayout, {.v = &layouts[1]}},
          {MODKEY, XK_m, setlayout, {.v = &layouts[2]}},
          {MODKEY, XK_space, setlayout, {0}},
          {MODKEY | ShiftMask, XK_space, togglefloating, {0}},
          {MODKEY | ShiftMask, XK_f, togglefullscr, {0}},
          {MODKEY, XK_0, view, {.ui = ~0}},
          {MODKEY | ShiftMask, XK_0, tag, {.ui = ~0}},
          {MODKEY, XK_comma, focusmon, {.i = -1}},
          {MODKEY, XK_period, focusmon, {.i = +1}},
          {MODKEY | ShiftMask, XK_comma, tagmon, {.i = -1}},
          {MODKEY | ShiftMask, XK_period, tagmon, {.i = +1}},
          ${concatStringsSep "\n" (map mkScratchpadKey scratchpads)}
          /* Client position is limited to monitor window area */
          {Mod4Mask, XK_u, floatpos, {.v = "-26x -26y"}},      // ↖
          {Mod4Mask, XK_i, floatpos, {.v = "  0x -26y"}},      // ↑
          {Mod4Mask, XK_o, floatpos, {.v = " 26x -26y"}},      // ↗
          {Mod4Mask, XK_j, floatpos, {.v = "-26x   0y"}},      // ←
          {Mod4Mask, XK_l, floatpos, {.v = " 26x   0y"}},      // →
          {Mod4Mask, XK_m, floatpos, {.v = "-26x  26y"}},      // ↙
          {Mod4Mask, XK_comma, floatpos, {.v = "  0x  26y"}},  // ↓
          {Mod4Mask, XK_period, floatpos, {.v = " 26x  26y"}}, // ↘
          /* Absolute positioning (allows moving windows between monitors) */
          {Mod4Mask | ControlMask, XK_u, floatpos, {.v = "-26a -26a"}},      // ↖
          {Mod4Mask | ControlMask, XK_i, floatpos, {.v = "  0a -26a"}},      // ↑
          {Mod4Mask | ControlMask, XK_o, floatpos, {.v = " 26a -26a"}},      // ↗
          {Mod4Mask | ControlMask, XK_j, floatpos, {.v = "-26a   0a"}},      // ←
          {Mod4Mask | ControlMask, XK_l, floatpos, {.v = " 26a   0a"}},      // →
          {Mod4Mask | ControlMask, XK_m, floatpos, {.v = "-26a  26a"}},      // ↙
          {Mod4Mask | ControlMask, XK_comma, floatpos, {.v = "  0a  26a"}},  // ↓
          {Mod4Mask | ControlMask, XK_period, floatpos, {.v = " 26a  26a"}}, // ↘
          /* Resize client, client center position is fixed which means that client
             expands in all directions */
          {Mod4Mask | ShiftMask, XK_u, floatpos, {.v = "-26w -26h"}},      // ↖
          {Mod4Mask | ShiftMask, XK_i, floatpos, {.v = "  0w -26h"}},      // ↑
          {Mod4Mask | ShiftMask, XK_o, floatpos, {.v = " 26w -26h"}},      // ↗
          {Mod4Mask | ShiftMask, XK_j, floatpos, {.v = "-26w   0h"}},      // ←
          {Mod4Mask | ShiftMask, XK_k, floatpos, {.v = "800W 800H"}},      // ·
          {Mod4Mask | ShiftMask, XK_l, floatpos, {.v = " 26w   0h"}},      // →
          {Mod4Mask | ShiftMask, XK_m, floatpos, {.v = "-26w  26h"}},      // ↙
          {Mod4Mask | ShiftMask, XK_comma, floatpos, {.v = "  0w  26h"}},  // ↓
          {Mod4Mask | ShiftMask, XK_period, floatpos, {.v = " 26w  26h"}}, // ↘
          /* Client is positioned in a floating grid, movement is relative to client's
             current position */
          {Mod4Mask | Mod1Mask, XK_u, floatpos, {.v = "-1p -1p"}},      // ↖
          {Mod4Mask | Mod1Mask, XK_i, floatpos, {.v = " 0p -1p"}},      // ↑
          {Mod4Mask | Mod1Mask, XK_o, floatpos, {.v = " 1p -1p"}},      // ↗
          {Mod4Mask | Mod1Mask, XK_j, floatpos, {.v = "-1p  0p"}},      // ←
          {Mod4Mask | Mod1Mask, XK_k, floatpos, {.v = " 0p  0p"}},      // ·
          {Mod4Mask | Mod1Mask, XK_l, floatpos, {.v = " 1p  0p"}},      // →
          {Mod4Mask | Mod1Mask, XK_m, floatpos, {.v = "-1p  1p"}},      // ↙
          {Mod4Mask | Mod1Mask, XK_comma, floatpos, {.v = " 0p  1p"}},  // ↓
          {Mod4Mask | Mod1Mask, XK_period, floatpos, {.v = " 1p  1p"}}, // ↘
          TAGKEYS(XK_1, 0) TAGKEYS(XK_2, 1) TAGKEYS(XK_3, 2) TAGKEYS(XK_4, 3)
              TAGKEYS(XK_5, 4) TAGKEYS(XK_6, 5) TAGKEYS(XK_7, 6) TAGKEYS(XK_8, 7)
                  TAGKEYS(XK_9, 8){MODKEY | ShiftMask, XK_q, quit, {0}},
      };

      /* button definitions */
      /* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle,
       * ClkClientWin, or ClkRootWin */
      static const Button buttons[] = {
          /* click                event mask      button          function argument */
          {ClkLtSymbol, 0, Button1, setlayout, {0}},
          {ClkLtSymbol, 0, Button3, setlayout, {.v = &layouts[2]}},
          {ClkWinTitle, 0, Button2, zoom, {0}},
          {ClkStatusText, 0, Button2, spawn, {.v = termcmd}},
          {ClkClientWin, MODKEY, Button1, movemouse, {0}},
          {ClkClientWin, MODKEY, Button2, togglefloating, {0}},
          {ClkClientWin, MODKEY, Button1, resizemouse, {0}},
          {ClkTagBar, 0, Button1, view, {0}},
          {ClkTagBar, 0, Button3, toggleview, {0}},
          {ClkTagBar, MODKEY, Button1, tag, {0}},
          {ClkTagBar, MODKEY, Button3, toggletag, {0}},
      };
    ''
