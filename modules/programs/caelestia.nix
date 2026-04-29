{ osConfig
, lib
, ...
}:
let
  # Default scheme shipped within the dotfiles repo
  defaultScheme = ./caelestia/default-scheme.conf;
in
{
  config = lib.mkIf (osConfig.environment.desktop.windowManager == "hyprland") {
    programs.caelestia = {
      enable = true;
      systemd.enable = true;
      cli.enable = true;
    };

    # Deploy the default color scheme for Hyprland to source
    xdg.configFile."hypr/scheme/default.conf".source = defaultScheme;

    # Fish integration: apply terminal color sequences on shell init
    programs.fish.interactiveShellInit = lib.mkAfter ''
      # Apply Caelestia terminal colour sequences if available
      if test -f ~/.local/state/caelestia/sequences.txt
        cat ~/.local/state/caelestia/sequences.txt
      end
    '';
  };
}
