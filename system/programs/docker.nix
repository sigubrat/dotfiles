{ pkgs
, ...
}:
{
  virtualisation = {
    podman.enable = true;
    docker = {
      enable = true;
      daemon.settings = {
        data-root = "/opt/docker";
      };
    };
  };
  environment.systemPackages = with pkgs; [
    docker-compose
  ];

  users.users.sigurd.extraGroups = [ "docker" ];
}
