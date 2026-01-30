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
    extraGroups = [ "wheel" "video" "audio" "plugdev" ];
    openssh.authorizedKeys.keys = [ ];
  };

  ########################################
  # Desktop (Hyprland)
  ########################################
  environment.desktop = {
    enable = true;
    windowManager = "hyprland";
  };

  programs.hyprland = {
    enable = true;
    settings = {
      monitor = [
        # Laptop display - safe default, will be reconfigured by scripts
        "eDP-1,preferred,auto,1"

        # External monitors - disabled by default, enabled by scripts if detected
        ",preferred,auto,1"
      ];

      exec-once = [
        "setup-monitors"
        "handle-monitor"
        "zen"
        "discord"
        "code"
        "alacritty"
        "slack"
      ];
    };
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
