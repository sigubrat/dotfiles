{
  programs.ssh = {
    enable = true;

    enableDefaultConfig = false;
    settings = {
      "*" = {
        before = [ ];
        after = [ ];
        data = {
          ForwardAgent = false;
          AddKeysToAgent = "yes";
          Compression = true;
          ServerAliveInterval = 0;
          ServerAliveCountMax = 3;
          HashKnownHosts = false;
          UserKnownHostsFile = "~/.ssh/known_hosts";
        };
      };

      "github.com" = {
        before = [ ];
        after = [ ];
        data = {
          HostName = "ssh.github.com";
          Port = 443;
          User = "git";
          IdentitiesOnly = true;
          IdentityFile = [ "~/.ssh/id_rsa" ];
          ControlMaster = "auto";
          ControlPath = "~/.ssh/master-%r@%n:%p";
          ControlPersist = "10m";
        };
      };

      "10.0.0.*" = {
        before = [ ];
        after = [ ];
        data.ForwardAgent = true;
      };
    };
  };
}
