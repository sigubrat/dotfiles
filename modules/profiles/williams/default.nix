{ lib
, ...
}:
{
  imports = [ ../../default.nix ];

  # Home modules to load
  program.hyprlock.defaultMonitor = "desc:Hewlett Packard HP Z27n CNK6481RQ6";

  service = lib.mkMerge [
    {
      hypridle = {
        dpms = false;
        suspend = false;
      };
    }
  ];
}
