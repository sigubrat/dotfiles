let
  mainMod = "SUPER";
  SECONDARY = "SHIFT";
  TERTIARY = "CTRL";

  toggle =
    program:
    let
      prog = builtins.substring 0 14 program;
    in
    "pkill ${prog} || uwsm app -- ${program}";

  runOnce = program: "pgrep ${program} || uwsm app -- ${program}";
  launch = program: "uwsm app -- ${program}";
in
{
  programs.hyprland.settings = {
    # Move/resize windows with mainMod + LMB/RMB and dragging
    bindm = [
      "${mainMod}, mouse:272, movewindow"
      "${mainMod}, mouse:273, resizewindow"
    ];
  };

  # All keybinds must live inside submap=global so that the catchall
  # intercepts Super+<key> combos and prevents the launcher from
  # opening on anything other than a clean Super tap.
  programs.hyprland.extraConfig = ''
    exec = hyprctl dispatch submap global
    submap = global

    # Caelestia shell – launcher (Super tap)
    bindi = Super, Super_L, global, caelestia:launcher
    bindin = Super, catchall, global, caelestia:launcherInterrupt
    bindin = Super, mouse:272, global, caelestia:launcherInterrupt
    bindin = Super, mouse:273, global, caelestia:launcherInterrupt
    bindin = Super, mouse:274, global, caelestia:launcherInterrupt
    bindin = Super, mouse:275, global, caelestia:launcherInterrupt
    bindin = Super, mouse:276, global, caelestia:launcherInterrupt
    bindin = Super, mouse:277, global, caelestia:launcherInterrupt
    bindin = Super, mouse_up, global, caelestia:launcherInterrupt
    bindin = Super, mouse_down, global, caelestia:launcherInterrupt

    # Caelestia shell panels
    bind = Ctrl+Alt, Delete, global, caelestia:session
    bindl = ${mainMod}, N, global, caelestia:clearNotifs
    bind = ${mainMod}, A, global, caelestia:sidebar
    bind = ${mainMod} ${SECONDARY}, A, global, caelestia:showall
    bind = ${mainMod} ${TERTIARY}, L, global, caelestia:lock

    # Launchers
    bind = ${mainMod}, Return, exec, ${launch "alacritty"}
    bind = ${mainMod}, B, exec, ${toggle "alacritty -t btop -e btm"}
    bind = ${mainMod}, R, exec, ${toggle "alacritty -t ranger -e ranger"}
    bind = ${mainMod}, S, exec, ${launch "spotify"}
    bind = ${mainMod} ${SECONDARY}, D, exec, ${runOnce "pcmanfm"}

    # Lockscreen
    bind = ${mainMod} ${SECONDARY}, L, exec, ${runOnce "hyprlock"}

    # Screenshot
    bind = ${mainMod} ${SECONDARY}, P, exec, ${runOnce "grimblast --notify copy area"}

    # Scratchpads
    bind = ${mainMod} ${SECONDARY}, T, movetoworkspace, special
    bind = ${mainMod}, t, togglespecialworkspace

    # Bindings
    bind = ${mainMod} ${SECONDARY} ${TERTIARY}, Q, exit
    bind = ${mainMod}, Q, killactive
    bind = ${mainMod}, F, togglefloating
    bind = ${mainMod}, G, fullscreen
    bind = ${mainMod}, P, layoutmsg, togglesplit

    # Move focus
    bind = ${mainMod}, k, movefocus, u
    bind = ${mainMod}, j, movefocus, d
    bind = ${mainMod}, l, movefocus, r
    bind = ${mainMod}, h, movefocus, l

    # Switch workspaces
    bind = ${mainMod}, left,  exec, hyprctl dispatch workspace e-1
    bind = ${mainMod}, right, exec, hyprctl dispatch workspace e+1
    bind = ${mainMod}, 1, exec, workspace-switch 1
    bind = ${mainMod}, 2, exec, workspace-switch 2
    bind = ${mainMod}, 3, exec, workspace-switch 3
    bind = ${mainMod}, 4, exec, workspace-switch 4
    bind = ${mainMod}, 5, exec, workspace-switch 5
    bind = ${mainMod}, 6, exec, workspace-switch 6
    bind = ${mainMod}, 7, exec, hyprctl dispatch workspace 7
    bind = ${mainMod}, 8, exec, hyprctl dispatch workspace 8
    bind = ${mainMod}, 9, exec, hyprctl dispatch workspace 9

    # Move active window to workspace
    bind = ${mainMod} ${SECONDARY}, right, exec, hyprctl dispatch movetoworkspace e+1
    bind = ${mainMod} ${SECONDARY}, left, exec, hyprctl dispatch movetoworkspace e-1
    bind = ${mainMod} ${SECONDARY}, 1, exec, hyprctl dispatch movetoworkspace 1
    bind = ${mainMod} ${SECONDARY}, 2, exec, hyprctl dispatch movetoworkspace 2
    bind = ${mainMod} ${SECONDARY}, 3, exec, hyprctl dispatch movetoworkspace 3
    bind = ${mainMod} ${SECONDARY}, 4, exec, hyprctl dispatch movetoworkspace 4
    bind = ${mainMod} ${SECONDARY}, 5, exec, hyprctl dispatch movetoworkspace 5
    bind = ${mainMod} ${SECONDARY}, 6, exec, hyprctl dispatch movetoworkspace 6
    bind = ${mainMod} ${SECONDARY}, 7, exec, hyprctl dispatch movetoworkspace 7
    bind = ${mainMod} ${SECONDARY}, 8, exec, hyprctl dispatch movetoworkspace 8
    bind = ${mainMod} ${SECONDARY}, 9, exec, hyprctl dispatch movetoworkspace 9

    # Volume keys
    bind = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
    bind = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
    bind = , XF86AudioMute,        exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

    # Media keys
    bind = , XF86AudioPlay, exec, playerctl play-pause
    bind = , XF86AudioNext, exec, playerctl next
    bind = , XF86AudioPrev, exec, playerctl previous

    # Brightness keys
    bind = , XF86MonBrightnessUp,   exec, brightnessctl set +10%
    bind = , XF86MonBrightnessDown, exec, brightnessctl set 10%-

    # Window resize
    binde = ${mainMod} ${TERTIARY}, k, resizeactive, 0 -20
    binde = ${mainMod} ${TERTIARY}, j, resizeactive, 0 20
    binde = ${mainMod} ${TERTIARY}, l, resizeactive, 20 0
    binde = ${mainMod} ${TERTIARY}, h, resizeactive, -20 0
    binde = ${mainMod} ALT,  k, moveactive, 0 -20
    binde = ${mainMod} ALT,  j, moveactive, 0 20
    binde = ${mainMod} ALT,  l, moveactive, 20 0
    binde = ${mainMod} ALT,  h, moveactive, -20 0

    submap = reset
  '';
}
