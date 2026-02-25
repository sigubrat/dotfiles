{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.batsignal
    pkgs.libnotify
  ];

  systemd.user.services.batsignal = {
    description = "Battery monitor daemon";
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.batsignal}/bin/batsignal -w 20 -c 10 -d 5";
      Restart = "on-failure";
    };
  };
}
