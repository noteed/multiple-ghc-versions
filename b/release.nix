let
  sources = import ./nix/sources.nix;
  mk-binaries = compiler: pkgssrc:
    let
      overlays = import ./nix/overlays.nix { inherit compiler; };
      nixpkgs = import sources."${pkgssrc}" { inherit overlays; };
    in
      nixpkgs.haskellPackages.b;
in
  {
    # Build with nix-build -A <attr>
    binaries-928-nixpkgs = mk-binaries "ghc928" "nixpkgs";
    binaries-928-nixos-23-11 = mk-binaries "ghc928" "nixos-23.11";
    binaries-942-nixpkgs = mk-binaries "ghc942" "nixpkgs";
    binaries-942-nixos-23-11 = mk-binaries "ghc942" "nixos-23.11";
  }
