{ osConfig
, lib
, ...
}:
{
  config = lib.mkIf (osConfig.environment.desktop.windowManager == "hyprland") {
    programs.caelestia = {
      enable = true;
      systemd.enable = true;
      cli.enable = true;
    };
  };
}
