{
  pkgs,
  lib,
  taskwarrior ? pkgs.taskwarrior,
  ...
}: let
  inherit (pkgs) writeShellScriptBin;
  inherit (lib) getExe;
  bc = getExe pkgs.bc;
  xsetroot = getExe pkgs.xorg.xsetroot;
in
  writeShellScriptBin "dwm-bar" ''
    interval=0

    # load colors
    DELIMITER=" | "
    cpu() {
      cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)

      printf "  "
      printf "$cpu_val$DELIMITER"
    }

    mem() {
      printf "  "
      printf "$(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)$DELIMITER"
    }

    clock() {
      printf "󱑆  "
      printf "$(date "+%Y-%m-%d %H:%M")"
    }

    battery() {
      file="/sys/class/power_supply/BAT1/capacity"
      if [ -e $file ]; then
       printf "  "
       get_capacity="$(cat $file)"
       printf "$get_capacity%s" " %$DELIMITER"
      fi
    }

    volume() {
      printf "  "
      echo "$(echo "scale=2; $(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2}') * 100" | ${bc}| cut -d '.' -f 1) %$DELIMITER"
    }

    brightness() {
      file="/sys/class/backlight/*/brightness"
      if [ -e $file ]; then
       printf "  "
       echo "$(echo "scale=2; $(cat $file) / 255 * 100" | ${bc}| cut -d '.' -f 1) %$DELIMITER"
      fi
    }

    taskwarrior() {
     printf "  "

     is_ready=$(${taskwarrior}/bin/task task ready)
     if [ -z is_ready ]; then
       printf "No tasks"
     else
       next_desc=$(${taskwarrior}/bin/task rc.verbose: rc.report.next.columns:description rc.report.next.labels:1 limit:1 next)
       next_due=$(${taskwarrior}/bin/task rc.verbose: rc.report.next.columns:due.relative rc.report.next.labels:1 limit:1 next)

       echo "$next_desc due in $next_due"
     fi
     echo "$DELIMITER"
    }

    while true; do
      [ $interval = 0 ] || [ $(($interval % 3600)) = 0 ]
      interval=$((interval + 1))

      sleep 1 && ${xsetroot} -name " $(taskwarrior)$(volume)$(brightness)$(battery)$(cpu)$(mem)$(clock) "
    done
  ''
