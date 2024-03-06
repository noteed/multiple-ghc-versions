# Central overlay that supplies all overlays that:
# 1. Make this package available.
# 2. Provide this particular package with a fixed point of overlayed packages,
#    if they become needed.

let

  sources = import ./sources.nix;
  inherit (sources) a;

  # Normally, we use the second definition of getOverlays, but since we're
  # using a local path to our A project, we have to construct a local path.
  getOverlays = pkg : import (../. + "${pkg}/nix/overlays.nix");
  # getOverlays = pkg : import "${pkg}/nix/overlays.nix";

  # We can overlay Haskell packages here.
  haskellOverlays =
    getOverlays a
    ;

in haskellOverlays ++ [ (import ./overlay.nix) ]
