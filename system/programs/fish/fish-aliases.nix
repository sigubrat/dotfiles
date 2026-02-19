{ pkgs, lib, ... }:
let
  dc = "${pkgs.docker-compose}/bin/docker-compose";
  nmkp-path = "~/Projects/workspace/kvalreg-nmkp";
in
{
  fishAliases = {
    inherit dc;

    # Tool replacements
    cat = "bat";
    du = "${pkgs.ncdu}/bin/ncdu --color dark -rr -x";
    ls = "${pkgs.eza}/bin/eza";
    la = "${lib.getExe pkgs.eza} --long --all --group --header --group-directories-first --sort=type --icons";
    lg = "${lib.getExe pkgs.eza} --long --all --group --header --git";
    lt = "${lib.getExe pkgs.eza} --long --all --group --header --tree --level ";
    ping = "${pkgs.prettyping}/bin/prettyping";
    tree = "${pkgs.eza}/bin/eza -T";
    xdg-open = "${pkgs.mimeo}/bin/mimeo";

    # Navigation
    ".." = "cd ..";

    # Git alias
    gcm = "git checkout master";
    gs = "git status";
    ga = "git add";
    gaa = "git add -A";
    gm = "git commit -m";
    gp = "git push";
    gpfl = "git push --force-with-lease";
    gc = "git checkout";

    # Maven alias
    mvncp = "mvn clean package";
    mvnci = "mvn clean install";

    # Docker
    dps = "${dc} ps";
    dcd = "${dc} down --remove-orphans";
    drm = "docker images -a -q | xargs docker rmi -f";

    # Nix
    nixgc = "nix-collect-garbage";
    nixgcd = "sudo nix-collect-garbage -d";
    update = "nix flake update";
    supdate = "sudo nix flake update";
    upgrade = "sudo nixos-rebuild switch --flake";

    # Locations
    dot = "cd ~/Sources/dotfiles";
    doc = "cd ~/Documents";
    work = "cd ~/Projects/workspace";
    tod = "cd ~/Projects/workspace/worksetup";
    frontend = "cd ${nmkp-path}/modules/nmkp-app-core";
    backend = "cd ${nmkp-path}";

    # Danger zone
    nuke = "rm -rf ${nmkp-path}/project target/ ${nmkp-path}/.bloop ${nmkp-path}/.bsp ${nmkp-path}/.metals ";
    start_background = "nmkp service start -a";
    restart_db = "echo \"Dropping database and restarting postgres\"; nmkp service drop -p; sleep 2; nmkp service start -p; echo \"Postgres restarted.\"";
  };
}
