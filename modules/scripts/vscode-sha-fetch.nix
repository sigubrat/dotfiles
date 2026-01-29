{ pkgs, ... }:

pkgs.writeShellScriptBin "vscode-ext-sha" ''
  if [ $# -lt 2 ]; then
    echo "Usage: vscode-ext-sha <publisher> <extension> [version]"
    echo "Example: vscode-ext-sha Catppuccin catppuccin-vsc 3.18.0"
    exit 1
  fi

  PUBLISHER="$1"
  EXTENSION="$2"
  VERSION="$3"

  # If no version provided, fetch the latest
  if [ -z "$VERSION" ]; then
    VERSION=$(${pkgs.curl}/bin/curl -s "https://marketplace.visualstudio.com/items?itemName=$PUBLISHER.$EXTENSION" | \
      ${pkgs.gnugrep}/bin/grep -oP '"version"\s*:\s*"\K[^"]+' | head -1)
    echo "Latest version: $VERSION"
  fi

  URL="https://$PUBLISHER.gallery.vsassets.io/_apis/public/gallery/publisher/$PUBLISHER/extension/$EXTENSION/$VERSION/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"

  echo "Fetching SHA for $PUBLISHER.$EXTENSION@$VERSION..."
  SHA=$(${pkgs.nix}/bin/nix-prefetch-url "$URL" 2>/dev/null)
  SHA256=$(${pkgs.nix}/bin/nix hash to-sri --type sha256 "$SHA")

  echo ""
  echo "Publisher: $PUBLISHER"
  echo "Extension: $EXTENSION"
  echo "Version:   $VERSION"
  echo ""
  echo "sha256 = \"$SHA256\";"
''
