{
  osConfig,
  pkgs,
  lib,
  ...
}:
{
  home = lib.mkIf osConfig.environment.desktop.enable {
    # Writer (docx) and Calc (xlsx), plus the rest of the suite
    packages = [
      pkgs.libreoffice
    ];
    persistence."/persist/" = {
      directories = [
        ".config/libreoffice"
      ];
    };
  };
}
