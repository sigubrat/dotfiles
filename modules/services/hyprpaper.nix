{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}:
let
  wallpaper = "${config.home.homeDirectory}/Sources/wallpapers/cyberpunkcity.jpg";
in
{
  services.hyprpaper = lib.mkIf (osConfig.environment.desktop.windowManager == "hyprland") {
    enable = true;
    package = pkgs.hyprpaper;

    settings = {
      preload = [ "${wallpaper}" ];
      wallpaper = [ ", ${wallpaper}" ];
    };
  };
}
