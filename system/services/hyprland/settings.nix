{ pkgs, ... }:
{
  programs.hyprland.settings = {
    env = [
      "GRIMBLAST_NO_CURSOR,0"
      "HYPRCURSOR_THEME,${pkgs.capitaine-cursors}"
      "HYPRCURSOR_SIZE,16"
      "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
    ];
    exec-once = [
      "hyprpaper"
      "hyprctl setcursor capitaine-cursors-white 16"
      "wl-clip-persist --clipboard both &"
      "wl-paste --watch cliphist store &"
      "uwsm finalize"
      "setup-monitors"
      "handle-monitor &"
    ];

    general = {
      gaps_in = 5;
      gaps_out = 10;
      border_size = 1;
      allow_tearing = true;
      resize_on_border = true;
      "col.active_border" = "rgba(c2c1ffe6)"; # Caelestia primary
      "col.inactive_border" = "rgba(c8c5d111)"; # Caelestia onSurfaceVariant faint
      # Border hover effects
      hover_icon_on_border = true;
      extend_border_grab_area = 15;
    };

    cursor = {
      inactive_timeout = 3;
      no_hardware_cursors = false;
      enable_hyprcursor = true;
    };

    decoration = {
      rounding = 15;

      blur = {
        enabled = true;
        size = 8;
        passes = 2;
        new_optimizations = true;
        ignore_opacity = true;
        xray = false;
        popups = true;
      };

      shadow = {
        enabled = true;
        range = 20;
        render_power = 3;
        color = "rgba(131317d4)";
      };

      active_opacity = 1.0;
      inactive_opacity = 0.95;
      fullscreen_opacity = 1.0;
    };

    layerrule = [
      "blur on, match:namespace ^(wofi)$"
      "ignore_alpha 0, match:namespace ^(wofi)$"
      "blur on, match:namespace ^(caelestia)$"
      "ignore_alpha 0, match:namespace ^(caelestia)$"
      "blur on, match:namespace ^(notifications)$"
      "ignore_alpha 0, match:namespace ^(notifications)$"
    ];

    animations.enabled = true;

    # Caelestia-style beziers and animations
    bezier = [
      "specialWorkSwitch, 0.05, 0.7, 0.1, 1"
      "emphasizedAccel, 0.3, 0, 0.8, 0.15"
      "emphasizedDecel, 0.05, 0.7, 0.1, 1"
      "standard, 0.2, 0, 0, 1"
    ];

    animation = [
      # Layer animations
      "layersIn, 1, 5, emphasizedDecel, slide"
      "layersOut, 1, 4, emphasizedAccel, slide"
      "fadeLayers, 1, 5, standard"

      # Window animations
      "windowsIn, 1, 5, emphasizedDecel"
      "windowsOut, 1, 3, emphasizedAccel"
      "windowsMove, 1, 6, standard"
      "workspaces, 1, 5, standard"

      # Special workspace
      "specialWorkspace, 1, 4, specialWorkSwitch, slidefadevert 15%"

      # Fade & border
      "fade, 1, 6, standard"
      "fadeDim, 1, 6, standard"
      "border, 1, 6, standard"
    ];

    input = {
      kb_layout = "no,us";
      kb_options = "grp:alt_shift_toggle";

      follow_mouse = 1;
      mouse_refocus = true;
      sensitivity = 0.0;
      accel_profile = "adaptive";

      # Touchpad improvements
      touchpad = {
        natural_scroll = true;
        disable_while_typing = true;
        tap-to-click = true;
        middle_button_emulation = true;
      };
    };

    group = {
      groupbar = {
        font_size = 10;
        gradients = true;
        render_titles = true;
        scrolling = true;
      };

      # Group border colors (Caelestia primary/surface)
      "col.border_active" = "rgba(c2c1ffe6)";
      "col.border_inactive" = "rgba(47464f66)";
    };

    dwindle = {
      pseudotile = true;
      preserve_split = true;
      force_split = 0;
      default_split_ratio = 1.2;
      smart_split = true;
      smart_resizing = true;
    };

    misc = {
      disable_autoreload = true;
      force_default_wallpaper = 0;
      animate_mouse_windowdragging = true;
      animate_manual_resizes = true;
      vrr = 1;

      # Window focus settings
      focus_on_activate = true;
      mouse_move_focuses_monitor = true;

      # Visual effects
      enable_swallow = true;
      swallow_regex = "^(foot|alacritty|kitty)$";

    };

    # Simplified workspace rules
    workspace = [
      "special:magic, gapsin:20, gapsout:40"
      # Workspace 1 (Zen) on left monitor
      "1, monitor:desc:Hewlett Packard HP Z27n CNK5440603, default:true"
      # Workspace 2 (VS Code) and 3 (Alacritty) on middle monitor
      "2, monitor:desc:Hewlett Packard HP Z27n CNK6481RQ6, default:true"
      "3, monitor:desc:Hewlett Packard HP Z27n CNK6481RQ6"
      # Workspace 4 (Discord), 5 (Slack) on laptop - fullscreen each
      "4, monitor:eDP-1, default:true"
      "5, monitor:eDP-1"
    ];

    xwayland.force_zero_scaling = true;
    debug.disable_logs = false;
  };
}
