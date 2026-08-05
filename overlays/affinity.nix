# Build affinity against affinity-nix's own pinned nixpkgs (not ours) so wine
# and the other heavy deps match what's in cache.forall.systems. The affinity
# packages themselves are unfree and never cached, but they're cheap.
inputs: final: prev:
let
  affinityPkgs = import inputs.affinity-nix.inputs.nixpkgs {
    system = prev.stdenv.hostPlatform.system;
    config.allowUnfree = true;
    overlays = [ inputs.affinity-nix.overlays.default ];
  };
in
{
  inherit (affinityPkgs)
    affinity-v3
    affinity-photo
    affinity-designer
    affinity-publisher
    ;
}
