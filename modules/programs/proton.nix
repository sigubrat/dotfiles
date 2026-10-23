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
    # pass-cli only picks the Secret Service on GNOME/KDE; otherwise it falls back to kernel keyutils
    sessionVariables.PROTON_PASS_LINUX_KEYRING = "dbus";
    persistence."/persist/" = {
      directories = [
        ".config/Proton Pass"
        ".local/share/proton-pass-cli"
      ];
    };
  };
}
