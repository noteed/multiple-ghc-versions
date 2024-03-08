{
  compiler ? "ghc928",
  # 9.2.8 is the one corresponding to haskellPackages when not overlayed.
  pkgssrc ? "nixpkgs"
}:

let
  sources = import ./nix/sources.nix;
  overlays = import ./nix/overlays.nix { inherit compiler; };
  nixpkgs = import sources."${pkgssrc}" { inherit overlays; };
in rec
  {
    inherit nixpkgs;
    # Build with nix-build -A <attr>
    binaries = nixpkgs.haskellPackages.a;
    binaries-981 = nixpkgs.with-horizon-platform.a;
  }
