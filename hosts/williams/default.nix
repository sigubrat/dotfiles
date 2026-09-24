{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./power-tuning.nix
  ];

  networking.hostName = "williams";

  users.users.sigurd = {
    isNormalUser = true;
    initialHashedPassword = "$7$CU..../....xCwA2EkHz5ukX5QDlZHqH1$0mtiQIaAoZhsAzzqoVnGXl96.U9h8G/RQplqbUB.RxD";
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "plugdev"
    ];
    openssh.authorizedKeys.keys = [ ];
  };

  ########################################
  # Desktop (Hyprland)
  ########################################
  environment.desktop = {
    enable = true;
    windowManager = "hyprland";
  };

  system = {
    disks.extraStoreDisk.enable = false;
    bluetooth.enable = true;
  };

  service = {
    blueman.enable = true;
    touchpad.enable = true;
  };

  environment.systemPackages = with pkgs; [
    vulkan-tools
    mesa-demos
  ];
}
