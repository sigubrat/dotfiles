{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf (config.environment.desktop.windowManager == "hyprland") {
    security = {
      pam = {
        loginLimits = [
          {
            domain = "*";
            type = "soft";
            item = "nofile";
            value = "65536";
          }
          {
            domain = "*";
            type = "hard";
            item = "nofile";
            value = "1048576";
          }
        ];
        services.greetd.enableGnomeKeyring = true;
        services.swaylock = { };
      };
      polkit.enable = true;
      rtkit.enable = true;
    };
    services = {
      gvfs.enable = true;
      devmon.enable = true;
      udisks2.enable = true;
      upower.enable = true;
      accounts-daemon.enable = true;

      greetd =
        let
          sessionLauncher = pkgs.writeShellApplication {
            name = "hyprland-session";
            runtimeInputs = [
              config.programs.uwsm.package
              pkgs.coreutils
              pkgs.systemd
            ];
            text = ''
              export SYSTEMD_PAGER=cat
              export SYSTEMD_COLORS=0
              umask 077

              startup_log=$(mktemp)
              trap 'rm -f "$startup_log"' EXIT

              set +e
              uwsm start -e -D Hyprland hyprland-uwsm.desktop 2>&1 | tee "$startup_log"
              session_status=''${PIPESTATUS[0]}

              if [ "$session_status" -eq 0 ]; then
                exit 0
              fi

              report_dir="$HOME/.local/state/uwsm"
              if ! mkdir -p "$report_dir"; then
                printf '\nCannot create diagnostics directory: %s\n' "$report_dir" >&2
                exit "$session_status"
              fi
              boot_id=$(cat /proc/sys/kernel/random/boot_id)
              report="$report_dir/failure-$boot_id.log"

              if [ ! -e "$report" ]; then
                run_check() {
                  printf '\n###'
                  printf ' %q' "$@"
                  printf '\n'
                  timeout 10s "$@"
                  check_status=$?
                  if [ "$check_status" -ne 0 ]; then
                    printf 'Command exited with status %s\n' "$check_status"
                  fi
                }

                {
                  printf 'Hyprland session failure: %s\n' "$(date --iso-8601=seconds)"
                  printf 'Boot ID: %s\nUWSM exit status: %s\n' "$boot_id" "$session_status"
                  printf '\n### UWSM startup output\n'
                  cat "$startup_log"
                  run_check readlink -f /run/current-system
                  run_check systemctl --user list-dependencies --reverse graphical-session-pre.target --all --no-pager
                  run_check systemctl --user list-units --all 'wayland-*' 'graphical-session*' tray.target --no-pager
                  run_check systemctl --user show graphical-session-pre.target graphical-session.target tray.target -p Id -p ActiveState -p ActiveEnterTimestamp -p Requires -p Wants -p RequiredBy -p WantedBy
                  run_check systemctl --user cat graphical-session-pre.target tray.target network-manager-applet.service caelestia.service polkit-gnome-authentication-agent-1.service --no-pager
                  run_check journalctl --user -b --no-pager -o short-monotonic -n 300
                  run_check journalctl -b -u greetd --no-pager -o short-monotonic -n 100
                } > "$report" 2>&1
                cat "$report"
              fi

              printf '\nSession failed. Diagnostics: %s\n' "$report" >&2
              exit "$session_status"
            '';
          };
          session = {
            command = lib.getExe sessionLauncher;
            user = "sigurd";
          };
        in
        {
          enable = true;
          restart = true;
          settings = {
            terminal.vt = 1;
            default_session = session;
          };
        };
    };
    # greetd restarts (near-)instantly on exit. If the compositor crashes,
    # the systemd --user manager may not have finished tearing down
    # graphical-session(-pre).target before the restarted `uwsm start` runs
    # its "is a session already active?" check, so it fails immediately and
    # greetd restarts again -- an unrecoverable loop. A short delay gives
    # the user manager time to catch up before the next attempt.
    systemd.services.greetd.serviceConfig.RestartSec = "2s";

    environment.persistence."/persist".users.sigurd.directories = [
      {
        directory = ".local/state/uwsm";
        mode = "0700";
      }
    ];
  };
}
