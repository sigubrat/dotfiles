{
  inputs,
  config,
  lib,
  ...
}:
{
  users.groups.nix-access-tokens = { };
  nix = {
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "impure-derivations"
        "ca-derivations"
      ];
      auto-optimise-store = true;
      fallback = true;
      trusted-users = [
        "root"
        "sigurd"
        "@wheel"
      ];
      download-buffer-size = 524288000;
      nix-path = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
    };
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };
}
