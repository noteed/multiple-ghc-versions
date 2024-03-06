self: super:
let

  lib = super.lib;
  sources = import ./sources.nix;
  contents = import ./contents.nix { nixpkgs = super; };

  inherit (sources) a;
  getContents = pkg : import (../. + "${pkg}/nix/contents.nix") { nixpkgs = super; };

  # How to create this string from Niv' sources ?
  horizon-platform = (builtins.getFlake "https://gitlab.horizon-haskell.net/package-sets/horizon-platform/-/archive/6af53faa48b5039696008086fb4dfa4ec823d428/horizon-platform-6af53faa48b5039696008086fb4dfa4ec823d428.tar.gz").outputs.legacyPackages.x86_64-linux;

  overrides = [
    (getContents a).ourOverrides
    contents.ourOverrides
  ];

in {
  haskellPackages = super.haskellPackages.override (old: {
    overrides =
      lib.composeExtensions (old.overrides or (_: _: { })) contents.ourOverrides;
  });

  with-horizon-platform = horizon-platform.extend (
    lib.foldl' (lhs: rhs: lib.composeExtensions lhs rhs) (_: _: {}) overrides
  );
}
