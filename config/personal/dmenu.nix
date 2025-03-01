{
  pkgs,
  config ? {
    font = "JBMono Nerd Font";
    fontSize = 12;
    lineHeight = 32;
  },
  ...
}: let
  inherit (pkgs) writeText;
in
  with config;
    writeText "config.h"
    /*
    C
    */
    ''
      /* See LICENSE file for copyright and license details. */
      /* Default settings; can be overriden by command line. */

      static int instant =
          1;                 /* -n  option; if 1, select single entry automatically */
      static int topbar = 0; /* -b  option; if 0, dmenu appears at bottom     */
      static int fuzzy = 1;  /* -F  option; if 0, dmenu doesn't use fuzzy matching */
      /* -fn option overrides fonts[0]; default X11 font or font set */
      static const char *fonts[] = {
          "${font}:pixelsize=${toString fontSize}:antialias=true:autohint=true"};
      static const char *prompt =
          NULL; /* -p  option; prompt to the left of input field */
      static const char *colors[][2] = {
          /*     fg         bg       */
          [SchemeNorm] = {"#ffffff", "#000000"},
          [SchemeSel] = {"#708090", "#0800808"},
          [SchemeSelHighlight] = {"#7788AA", "#080808"},
          [SchemeNormHighlight] = {"#7788AA", "#000000"},
          [SchemeOut] = {"#000000", "#00ffff"},
      };
      /* -l option; if nonzero, dmenu uses vertical list with given number of lines */
      static unsigned int lines = 0;
      /* -h option; minimum height of a menu line */
      static unsigned int lineheight = ${toString lineHeight};
      static unsigned int min_lineheight = ${toString lineHeight};

      /*
       * Characters not considered part of a word while deleting words
       * for example: " /?\"&[]"
       */
      static const char worddelimiters[] = " ";
    ''
