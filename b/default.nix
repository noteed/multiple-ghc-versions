{
  compiler ? "ghc928"
  # 9.2.8 is the one corresponding to haskellPackages when not overlayed.
}:

let
  sources = import ./nix/sources.nix;
  overlays = import ./nix/overlays.nix { inherit compiler; };
  nixpkgs = import sources.nixpkgs { inherit overlays; };
in rec
  {
    # Build with nix-build -A <attr>
    binaries = nixpkgs.haskellPackages.b;
    binaries-981 = nixpkgs.with-horizon-platform.b;
  }
