{ osConfig
, pkgs
, lib
, ...
}:
{
  home = lib.mkIf osConfig.environment.desktop.enable {
    packages = [
      pkgs.google-chrome
    ];
    persistence."/persist/" = {
      directories = [
        ".config/google-chrome"
      ];
    };
  };
}
