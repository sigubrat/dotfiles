{ pkgs, ... }:

pkgs.writeShellScriptBin "set-monitor" ''
  case "$1" in
    on)
      hyprctl keyword monitor "eDP-1,1920x1080@60,0x0,1"
      ;;
    off)
      hyprctl keyword monitor "eDP-1,disable"
      ;;
    *)
      echo "Usage: set-monitor [on|off]"
      ;;
  esac
''
