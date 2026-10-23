{
  osConfig,
  pkgs,
  lib,
  ...
}:
{
  home = lib.mkIf osConfig.environment.desktop.enable {
    packages = [
      pkgs.proton-pass # desktop app
      pkgs.proton-pass-cli # pass-cli
    ];
    persistence."/persist/" = {
      directories = [
        ".config/Proton Pass"
      ];
    };
  };
}
