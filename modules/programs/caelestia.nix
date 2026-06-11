{ osConfig
, lib
, ...
}:
let
  # Default scheme shipped within the dotfiles repo
  defaultScheme = ./caelestia/default-scheme.conf;
  zenUserChrome = ./caelestia/zen-userChrome.css;
  spicetifyTheme = ./caelestia/spicetify-user.css;
in
{
  config = lib.mkIf (osConfig.environment.desktop.windowManager == "hyprland") {
    programs.caelestia = {
      enable = true;
      systemd.enable = true;
      systemd.environment = [
        "CAELESTIA_WALLPAPERS_DIR=/home/sigurd/Sources/wallpapers"
      ];
      cli.enable = true;
      settings = {
        wallpapers = {
          path = "/home/sigurd/Sources/wallpapers";
        };
        bar.workspaces.windowIcons = [
          { name = "zen"; icon = "web"; }
          { name = "code"; icon = "code"; }
          { name = "discord"; icon = "chat_bubble"; }
          { name = "Slack"; icon = "forum"; }
          { name = "Alacritty"; icon = "terminal"; }
        ];
        general.idle = {
          lockBeforeSleep = true;
          inhibitWhenAudio = true;
          timeouts = [
            { timeout = 540; idleAction = "lock"; }
            { timeout = 600; idleAction = "dpms off"; returnAction = "dpms on"; }
            { timeout = 900; idleAction = [ "systemctl" "suspend-then-hibernate" ]; }
          ];
        };
        services = {
          useTwelveHourClock = false;
          useFahrenheit = false;
        };
        lock = {
          hideNotifs = true;
        };
      };
    };

    home = {
      # Persist Caelestia state and cache across reboots (impermanence)
      persistence."/persist/" = {
        directories = [
          ".local/state/caelestia"
          ".cache/caelestia"
          ".config/hypr/scheme"
        ];
      };

      # Set wallpaper directory for CLI and shell
      sessionVariables.CAELESTIA_WALLPAPERS_DIR = "/home/sigurd/Sources/wallpapers";

      # Ensure current.conf exists before Hyprland starts (activation runs before services)
      activation.caelestiaScheme = lib.hm.dag.entryAfter
        [ "writeBoundary" ]
        ''
          if [ ! -f "$HOME/.config/hypr/scheme/current.conf" ]; then
            cp -L --no-preserve=mode "$HOME/.config/hypr/scheme/default.conf" "$HOME/.config/hypr/scheme/current.conf"
          fi
        '';
    };

    xdg.configFile = {
      # Deploy the default color scheme for Hyprland to source
      "hypr/scheme/default.conf".source = defaultScheme;

      # Deploy Spicetify Caelestia theme
      "spicetify/Themes/caelestia/user.css".source = spicetifyTheme;

      # Zen userChrome.css — deploy to a known location; symlink from your Zen profile's chrome/ dir
      "caelestia/zen-userChrome.css".source = zenUserChrome;
    };

    # Fish integration: apply terminal color sequences on shell init
    programs.fish.interactiveShellInit = lib.mkAfter
      ''
        # Apply Caelestia terminal colour sequences if available
        if test -f ~/.local/state/caelestia/sequences.txt
          cat ~/.local/state/caelestia/sequences.txt
        end
      '';
  };
}
