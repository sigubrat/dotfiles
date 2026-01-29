{ pkgs, ... }:

pkgs.writeShellScriptBin "workspace-switch" ''
  WORKSPACE=$1

  # Switch to the workspace first
  hyprctl dispatch workspace "$WORKSPACE"

  # Define workspace-to-app mappings
  case "$WORKSPACE" in
    1)
      APP_CLASS="zen"
      APP_CMD="zen"
      ;;
    2)
      APP_CLASS="code"
      APP_CMD="code"
      ;;
    3)
      APP_CLASS="Alacritty"
      APP_CMD="alacritty"
      ;;
    4)
      APP_CLASS="discord"
      APP_CMD="discord"
      ;;
    5)
      APP_CLASS="Slack"
      APP_CMD="slack"
      ;;
    6)
      APP_CLASS="spotify"
      APP_CMD="spotify"
      ;;
    *)
      exit 0
      ;;
  esac

  # Check if the app is running (case-insensitive grep is simpler)
  if ! hyprctl clients -j | ${pkgs.jq}/bin/jq -r '.[].class' | grep -qi "^$APP_CLASS$"; then
    echo "Launching $APP_CMD..."
    nohup uwsm app -- "$APP_CMD" > /dev/null 2>&1 &
    disown
  else
    echo "App already running"
  fi
''
