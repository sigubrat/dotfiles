{
  osConfig,
  inputs,
  pkgs,
  lib,
  ...
}:
let
  zenBrowserUnwrapped =
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".zen-browser-unwrapped;
  zenBrowserUnwrappedFixed =
    if
      pkgs.stdenv.hostPlatform.system == "x86_64-linux" && zenBrowserUnwrapped.version == "1.23.3b"
    then
      zenBrowserUnwrapped.overrideAttrs (_: {
        src = pkgs.fetchurl {
          url = "https://github.com/zen-browser/desktop/releases/download/1.23.3b/zen.linux-x86_64.tar.xz";
          hash = "sha256-uyBF0+IWVNQP6EElAJLurf0sH8gx7vtQkiJ3PIvcoUk=";
        };
      })
    else
      zenBrowserUnwrapped;

  zenBrowser =
    pkgs.wrapFirefox
      (
        zenBrowserUnwrappedFixed
        // {
          version = zenBrowserUnwrappedFixed.firefoxVersion;
        }
      )
      {
        pname = "zen-browser";
        inherit (zenBrowserUnwrappedFixed) version;
        extraPolicies.ExtensionSettings = {
          "78272b6fa58f4a1abaac99321d503a20@proton.me" = {
            installation_mode = "force_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/proton-pass/latest.xpi";
          };
        };
      };

  # Create a wrapper script for zen-browser with Wayland enabled
  zenWithWayland = pkgs.symlinkJoin {
    name = "zen-browser-wayland";
    paths = [ zenBrowser ];
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
