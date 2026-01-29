{ pkgs, ... }:

pkgs.writeShellScriptBin "arrange-laptop-layout" ''
  set -euo pipefail

  JQ=${pkgs.jq}/bin/jq
  LAPTOP="eDP-1"

  # Get laptop monitor info
  LAPTOP_INFO=$(hyprctl monitors -j | $JQ -r ".[] | select(.name == \"$LAPTOP\")")

  if [ -z "$LAPTOP_INFO" ]; then
    echo "Laptop monitor not found"
    exit 0
  fi

  LAPTOP_WIDTH=$(echo "$LAPTOP_INFO" | $JQ -r '.width')
  LAPTOP_HEIGHT=$(echo "$LAPTOP_INFO" | $JQ -r '.height')
  LAPTOP_X=$(echo "$LAPTOP_INFO" | $JQ -r '.x')
  LAPTOP_Y=$(echo "$LAPTOP_INFO" | $JQ -r '.y')

  HALF_WIDTH=$((LAPTOP_WIDTH / 2))
  HALF_HEIGHT=$((LAPTOP_HEIGHT / 2))
  RIGHT_X=$((LAPTOP_X + HALF_WIDTH))
  BOTTOM_Y=$((LAPTOP_Y + HALF_HEIGHT))

  echo "Laptop: ''${LAPTOP_WIDTH}x''${LAPTOP_HEIGHT} at ''${LAPTOP_X},''${LAPTOP_Y}"
  echo "Left half: ''${HALF_WIDTH}x''${LAPTOP_HEIGHT} at ''${LAPTOP_X},''${LAPTOP_Y}"
  echo "Right half: ''${HALF_WIDTH}x''${LAPTOP_HEIGHT} at ''${RIGHT_X},''${LAPTOP_Y}"

  # Function to position window as floating
  position_window() {
    local class="$1"
    local x="$2"
    local y="$3"
    local w="$4"
    local h="$5"

    # Find window address by class
    ADDR=$(hyprctl clients -j | $JQ -r ".[] | select(.class | test(\"$class\"; \"i\")) | .address" | head -1)

    if [ -n "$ADDR" ] && [ "$ADDR" != "null" ]; then
      hyprctl dispatch focuswindow "address:$ADDR"
      hyprctl dispatch setfloating "address:$ADDR"
      hyprctl dispatch movewindowpixel "exact $x $y,address:$ADDR"
      hyprctl dispatch resizewindowpixel "exact $w $h,address:$ADDR"
      echo "Positioned $class at $x,$y with size $w x $h"
    else
      echo "Window $class not found"
    fi
  }

  sleep 0.5

  # Position Entertainment Zen browser on the left half (workspace 4)
  position_window "zen" "$LAPTOP_X" "$LAPTOP_Y" "$HALF_WIDTH" "$LAPTOP_HEIGHT"

  # Position Discord on right half - full height (workspace 5)
  # Discord and Slack overlap - whichever is focused shows on top
  position_window "discord" "$RIGHT_X" "$LAPTOP_Y" "$HALF_WIDTH" "$LAPTOP_HEIGHT"

  # Position Slack on right half - full height (workspace 6)
  # Overlaps with Discord
  position_window "Slack" "$RIGHT_X" "$LAPTOP_Y" "$HALF_WIDTH" "$LAPTOP_HEIGHT"

  echo "Laptop layout arranged"
''
