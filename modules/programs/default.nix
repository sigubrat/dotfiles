let
  more =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        acpi # battery info
        asciiquarium-transparent # asciiquarium
        brightnessctl # control screen brightness
        cacert # ca certificates
        dconf2nix # dconf (gnome) files to nix converter
        ffmpegthumbnailer # thumbnailer for video files
        gum # glamorous shell scripts
        headsetcontrol # control logitech headsets
        imagemagick # image manipulation
        imv # image viewer
        killall # kill processes by name
        libsecret # secret management
        mediainfo # media information
        nix-index # locate packages containing certain nixpkgs
        nix-output-monitor # nom: monitor nix commands
        nix-prefetch-git # prefetch git sources
        ouch # painless compression and decompression for your terminal
        paprefs # pulseaudio preferences
        pavucontrol # pulseaudio volume control
        pgadmin4 # Postgres administration tool
        pipewire # control volume
        playerctl # media player control
        poppler # pdf tools
        powertop # power stuff
        prettyping # a nicer ping
        pulseaudio # pulseaudio
        rage # encryption tool for secrets management
        ripgrep # fast grep
        spicetify-cli # Customize Spotify client
        statix #linting
        tldr # summary of a man page
        tree # display files in a tree view
        unzip # unzip files
        xarchiver # archive manager
        zip # zip files
      ];
    };
in
[
  # ./emacs
  ./neofetch
  ./wofi
  ./alacritty.nix
  ./bat.nix
  ./broot.nix
  ./direnv.nix
  ./discord.nix
  ./fish.nix
  ./foot.nix
  ./fzf.nix
  ./gimp.nix
  ./git.nix
  ./hyprland.nix
  ./hyprlock.nix
  ./icue.nix
  ./jq.nix
  ./neovim.nix
  ./pcmanfm.nix
  ./qt.nix
  ./repl.nix
  ./slack.nix
  ./spotify.nix
  ./ssh.nix
  ./starship.nix
  ./vscode.nix
  ./waybar.nix
  ./wine.nix
  ./wowup.nix
  ./zen.nix
  more
]
