

I want to try to use horizon-haskell to provide different GHC versions and
related packages. It is using flakes, but it is possible to use
`builtins.getFlake` in a project that doens't have a `flake.nix` file.

I have a working use case in Ream.

In this directory, I experiment with two dummy Haskell projects, A and B, with
B depending on A. The way I setup my Haskell projects is derived from how it
was done in Curiosity. It is done in a `nix/` directory providing
`contents.nix`, `overlay.nix`, and `overlays.nix`. The second depends on the
first, and the third depends on the second. Finally, `default.nix` import a
`nixpkgs` using the third as an overlay.

When creating a project that depends on another one (e.g. Curiosity depends on
Commence), the `overlays.nix` from the dependencies are explicitely imported in
a single list in `overlays.nix`.

I think that in the case of horizon-haskell, I should expose the overriding
function (usually called `ourOverrides` in `contents.nix` (instead of in
`overlay.nix`), so that I can use that instead of `overlays.nix`.

To check that this works as intended, I create two projects in this directory,
A and B, using the existing approach, then I'll modify them as described above.

So it works. With the previous overlay approach, all the dependencies overlays
are listed in `overlays.nix`. For horizon-platform, all the overriding
functions are listed in `overlay.nix` instead.
