
# Trying horizon-haskell.

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
function (usually called `overrides` in `contents.nix` (instead of in
`overlay.nix`), so that I can use that instead of `overlays.nix`.

To check that this works as intended, I create two projects in this directory,
A and B, using the existing approach, then I'll modify them as described above.

So it works. With the previous overlay approach, all the dependencies overlays
are listed in `overlays.nix`. For horizon-platform, all the overriding
functions are listed in `overlay.nix` instead.

# Multiple GHC versions

Independently from horizon-haskell, this shows how to build project A and B
with a different GHC version than the default one (the default is ghc928):

```
$ cd a  # or b
$ nix-build -A binaries --no-out-link --argstr compiler ghc942
$ nix-build -A binaries --no-out-link --argstr compiler ghc962
```

Building with ghc962 doesn't work. (I think template-haskell 2.20 is selected,
but language-haskell-extract need `<2.16`.)

Note: with this change (the `compiler` argument), in `overlay.nix`, we no
longer define `haskellPackages` in term of `haskellPackages`, but in term of
`haskell.packages."${compiler}"`, and we have to pass all the "overrides",
instead of being able to build on top of `old.overrides` with only our current
`contents.overrides`.

# Resources

This repository uses Nix and Haskell without flakes, and has multiple GHC
versions: https://github.com/awakesecurity/proto3-suite.

I've seen repository that don't use Nix use this kind of things:
https://github.com/haskell-actions/. Servant is one example.

# TODO

I'm wondering how, if necessary, I should work on
https://github.com/jhickner/smtp-mail or  https://github.com/tibbe/template.
They were repositories that are not present in horizon-platform.
