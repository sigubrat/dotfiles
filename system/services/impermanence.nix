{
  config,
  lib,
  ...
}:
let
  developSpecificDirs = [
    ".cache/bleep"
    ".cache/bloop"
    ".cache/coursier"
    ".cargo"
    ".m2"
    ".npm"
    ".pulumi"
  ];
in
{

  environment.persistence."/persist" = {
    hideMounts = true;
    files = [
      # Keeps journald boot history and D-Bus/systemd identity stable across
      # reboots; without this, /var/log/journal accumulates one orphaned
      # directory per boot since each gets a fresh machine-id.
      "/etc/machine-id"
    ];
    directories = [
      "/etc/NetworkManager/system-connections"
      "/etc/ssh"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/var/log"

      # Systemd requires /usr dir to be populated
      # See: https://github.com/nix-community/impermanence/issues/253
      "/usr/systemd-placeholder"
    ];
    users.sigurd = {
      directories = [
        "Documents"
        "Downloads"
        "Music"
        "Pictures"
        "Projects"
        "Sources"
        {
          directory = ".gnupg";
          mode = "0700";
        }
        {
          directory = ".ssh";
          mode = "0700";
        }
        {
          directory = ".local/share/direnv";
          mode = "0700";
        }
        {
          directory = ".local/share/keyrings";
          mode = "0700";
        }
      ]
      ++ (lib.optionals config.environment.desktop.develop developSpecificDirs);
    };
  };
}
