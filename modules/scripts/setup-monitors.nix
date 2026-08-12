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

    hyprctl eval "hl.monitor({ output = \"desc:$MONITOR_LEFT_DESC\", mode = \"2560x1440@60\", position = \"0x0\", scale = 1 })"
    hyprctl eval "hl.monitor({ output = \"desc:$MONITOR_MIDDLE_DESC\", mode = \"2560x1440@60\", position = \"2560x0\", scale = 1 })"
    hyprctl eval "hl.monitor({ output = \"$LAPTOP\", mode = \"1920x1080@60\", position = \"5120x0\", scale = 1 })"

    hyprctl eval "hl.dispatch(hl.dsp.workspace.move({ workspace = \"1\", monitor = \"desc:$MONITOR_LEFT_DESC\" }))"
    hyprctl eval "hl.dispatch(hl.dsp.workspace.move({ workspace = \"2\", monitor = \"desc:$MONITOR_MIDDLE_DESC\" }))"
    hyprctl eval "hl.dispatch(hl.dsp.workspace.move({ workspace = \"3\", monitor = \"desc:$MONITOR_MIDDLE_DESC\" }))"
    hyprctl eval "hl.dispatch(hl.dsp.workspace.move({ workspace = \"4\", monitor = \"$LAPTOP\" }))"
    hyprctl eval "hl.dispatch(hl.dsp.workspace.move({ workspace = \"5\", monitor = \"$LAPTOP\" }))"

    hyprctl eval "hl.workspace_rule({ workspace = \"1\", monitor = \"desc:$MONITOR_LEFT_DESC\", default = true })"
    hyprctl eval "hl.workspace_rule({ workspace = \"2\", monitor = \"desc:$MONITOR_MIDDLE_DESC\", default = true })"
    hyprctl eval "hl.workspace_rule({ workspace = \"3\", monitor = \"desc:$MONITOR_MIDDLE_DESC\" })"
    hyprctl eval "hl.workspace_rule({ workspace = \"4\", monitor = \"$LAPTOP\", default = true })"
    hyprctl eval "hl.workspace_rule({ workspace = \"5\", monitor = \"$LAPTOP\" })"

  else
    echo "Laptop-only setup"

    hyprctl eval "hl.monitor({ output = \"$LAPTOP\", mode = \"preferred\", position = \"0x0\", scale = 1 })"

    for i in {1..10}; do
      hyprctl eval "hl.workspace_rule({ workspace = \"$i\", monitor = \"$LAPTOP\" })"
    done
  fi

  echo "Monitor setup complete"
''
