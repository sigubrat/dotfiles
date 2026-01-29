{ pkgs, ... }:

pkgs.writeShellScriptBin "setup-monitors" ''
  set -euo pipefail

  JQ=${pkgs.jq}/bin/jq

  MONITOR_LEFT_DESC="Hewlett Packard HP Z27n CNK5440603"
  MONITOR_MIDDLE_DESC="Hewlett Packard HP Z27n CNK6481RQ6"
  LAPTOP="eDP-1"

  MONITORS_JSON=$(hyprctl monitors -j)

  has_desc() {
    echo "$MONITORS_JSON" | $JQ -e --arg d "$1" \
      '.[] | select(.description | contains($d))' >/dev/null
  }

  echo "Detected monitors:"
  echo "$MONITORS_JSON" | $JQ -r '.[].description'

  if has_desc "$MONITOR_LEFT_DESC" && has_desc "$MONITOR_MIDDLE_DESC"; then
    echo "Office setup detected (dual external + laptop)"

    hyprctl keyword monitor "desc:$MONITOR_LEFT_DESC,2560x1440@60,0x0,1"
    hyprctl keyword monitor "desc:$MONITOR_MIDDLE_DESC,2560x1440@60,2560x0,1"
    hyprctl keyword monitor "$LAPTOP,1920x1080@60,5120x0,1"

    # Move existing workspaces first
    hyprctl dispatch moveworkspacetomonitor 1 "desc:$MONITOR_LEFT_DESC"

    hyprctl dispatch moveworkspacetomonitor 2 "desc:$MONITOR_MIDDLE_DESC"
    hyprctl dispatch moveworkspacetomonitor 3 "desc:$MONITOR_MIDDLE_DESC"
    hyprctl dispatch moveworkspacetomonitor 5 "desc:$MONITOR_MIDDLE_DESC"

    hyprctl dispatch moveworkspacetomonitor 4 "$LAPTOP"
    hyprctl dispatch moveworkspacetomonitor 6 "$LAPTOP"

    # Then set defaults for future workspaces
    hyprctl keyword workspace "1,monitor:desc:$MONITOR_LEFT_DESC"
    hyprctl keyword workspace "4,monitor:desc:$MONITOR_LEFT_DESC"

    hyprctl keyword workspace "2,monitor:desc:$MONITOR_MIDDLE_DESC"
    hyprctl keyword workspace "3,monitor:desc:$MONITOR_MIDDLE_DESC"
    hyprctl keyword workspace "5,monitor:desc:$MONITOR_MIDDLE_DESC"

    hyprctl keyword workspace "6,monitor:$LAPTOP"

  else
    echo "Laptop-only setup"

    hyprctl keyword monitor "$LAPTOP,preferred,0x0,1"

    for i in {1..10}; do
      hyprctl keyword workspace "$i,monitor:$LAPTOP"
    done
  fi

  echo "Monitor setup complete"
''
