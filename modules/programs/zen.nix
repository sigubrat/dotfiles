{
  osConfig,
  inputs,
  pkgs,
  lib,
  ...
}:
let
  # Create a wrapper script for zen-browser with Wayland enabled
  zenWithWayland = pkgs.symlinkJoin {
    name = "zen-browser-wayland";
    paths = [ inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/zen \
        --set MOZ_ENABLE_WAYLAND 1
    '';
  };
in
{
  home = lib.mkIf osConfig.environment.desktop.enable {
    packages = [ zenWithWayland ];
    persistence."/persist/" = {
      directories = [
        ".zen"
      ];
    };
    sessionVariables.BROWSER = "zen";
  };

  xdg.mimeApps = lib.mkIf osConfig.environment.desktop.enable {
    enable = true;
    defaultApplications =
      lib.genAttrs [
        "text/html"
        "application/xhtml+xml"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "x-scheme-handler/about"
        "x-scheme-handler/unknown"
      ] (_: "zen.desktop")
      // {
        # Previously written by the apps themselves; keep them now that the file is managed
        "x-scheme-handler/slack" = "slack.desktop";
        "x-scheme-handler/claude-cli" = "claude-code-url-handler.desktop";
      };
  };
}
