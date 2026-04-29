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
      };
    };

    # Persist Caelestia state and cache across reboots (impermanence)
    home.persistence."/persist/" = {
      directories = [
        ".local/state/caelestia"
        ".cache/caelestia"
        ".config/hypr/scheme"
      ];
    };

    # Set wallpaper directory for CLI and shell
    home.sessionVariables.CAELESTIA_WALLPAPERS_DIR = "/home/sigurd/Sources/wallpapers";

    # Deploy the default color scheme for Hyprland to source
    xdg.configFile."hypr/scheme/default.conf".source = defaultScheme;

    # Ensure current.conf exists before Hyprland starts (activation runs before services)
    home.activation.caelestiaScheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ ! -f "$HOME/.config/hypr/scheme/current.conf" ]; then
        cp -L --no-preserve=mode "$HOME/.config/hypr/scheme/default.conf" "$HOME/.config/hypr/scheme/current.conf"
      fi
    '';

    # Deploy Spicetify Caelestia theme
    xdg.configFile."spicetify/Themes/caelestia/user.css".source = spicetifyTheme;

    # Zen userChrome.css — deploy to a known location; symlink from your Zen profile's chrome/ dir
    xdg.configFile."caelestia/zen-userChrome.css".source = zenUserChrome;

    # Fish integration: apply terminal color sequences on shell init
    programs.fish.interactiveShellInit = lib.mkAfter ''
      # Apply Caelestia terminal colour sequences if available
      if test -f ~/.local/state/caelestia/sequences.txt
        cat ~/.local/state/caelestia/sequences.txt
      end
    '';
  };
}
