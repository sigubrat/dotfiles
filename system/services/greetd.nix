{
  config,
  lib,
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
          session = {
            command = "${lib.getExe config.programs.uwsm.package} start -e -D Hyprland hyprland.desktop";
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
  };
}
