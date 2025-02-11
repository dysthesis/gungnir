/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx = 1; /* border pixel of windows */
static const unsigned int snap = 32;    /* snap pixel */
static const int swallowfloating =
    0;                         /* 1 means swallow floating windows by default */
static const int showbar = 1;  /* 0 means no bar */
static const int topbar = 0;   /* 0 means bottom bar */
static int floatposgrid_x = 5; /* float grid columns */
static int floatposgrid_y = 5; /* float grid rows */
static const int user_bh = 32; /* 0 means that dwm will calculate bar height, >=
                                 1 means dwm will user_bh as bar height */
static const char *fonts[] = {
    "JBMono Nerd Font:pixelsize=14:antialias=true:autohint=true"};
static const char dmenufont[] =
    "JBMono Nerd Font:pixelsize=14:antialias=true:autohint=true";
static const char col_gray1[] = "#080808";
static const char col_gray2[] = "#191919";
static const char col_gray3[] = "#2A2A2A";
static const char col_gray4[] = "#444444";
static const char col_cyan[] = "#708090";
static const char col_white[] = "#ffffff";
static const char *colors[][3] = {
    /*               fg         bg         border   */
    [SchemeNorm] = {col_white, col_gray1, col_gray2},
    [SchemeSel] = {col_white, col_gray2, col_white},
};

typedef struct {
  const char *name;
  const void *cmd;
} Sp;
const char *spterm[] = {"st", "-n", "term", "-g", "205x55", NULL};
const char *spnotes[] = {
    "st",
    "-n",
    "notes",
    "-g",
    "205x55",
    "-e",
    "sh",
    "-c",
    "tmux new-session -As Notes -c ~/Documents/Notes/ 'direnv exec . nvim'",
    NULL};
const char *spsignal[] = {"signal-desktop", NULL};

static Sp scratchpads[] = {
    /* name          cmd  */
    {"term", spterm},
    {"notes", spnotes},
    {"signal", spsignal},
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
    {"Gimp", NULL, NULL, 0, 1, 0, 0, NULL, -1},
    {"Firefox", NULL, NULL, 1 << 8, 0, 0, -1, NULL, -1},
    {"St", NULL, NULL, 0, 0, 1, 0, NULL, -1},
    {NULL, "term", NULL, SPTAG(0), 1, 0, 0, NULL, -1},
    {NULL, "notes", NULL, SPTAG(1), 1, 0, 0, NULL, -1},
    {NULL, "signal", NULL, SPTAG(2), 1, 0, 0, "50% 50% 1805W 1203H", -1},
};

/* layout(s) */
static const float mfact = 0.55; /* factor of master area size [0.05..0.95] */
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
    "dmenu_run", "-m",  dmenumon,  "-fn", dmenufont, "-nb", col_gray1, "-nf",
    col_white,   "-sb", col_gray2, "-sf", col_white, NULL};
static const char *termcmd[] = {"st", NULL};

#include "movestack.c"
static const Key keys[] = {
    /* modifier                     key        function        argument */
    {MODKEY, XK_r, spawn, {.v = dmenucmd}},
    {MODKEY, XK_Return, spawn, {.v = termcmd}},
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
    {MODKEY, XK_t, togglescratch, {.ui = 0}},
    {MODKEY, XK_n, togglescratch, {.ui = 1}},
    {MODKEY, XK_s, togglescratch, {.ui = 2}},
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
