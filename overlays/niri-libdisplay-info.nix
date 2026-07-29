# niri v26.04 vendors the `libdisplay-info-sys 0.3.0` crate, whose build
# script requires the system library `libdisplay-info >= 0.1.0, < 0.4.0`.
# nixpkgs bumped libdisplay-info to 0.4.0, which fails that cap and breaks the
# niri build. Pin a 0.3.x build of the library for niri *only* (via its build
# inputs) so the rest of the system keeps using 0.4.0 — no mesa/etc. rebuild.
inputs: final: prev:
let
  libdisplayInfo03 = prev.libdisplay-info.overrideAttrs (old: rec {
    version = "0.3.0";
    src = prev.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "emersion";
      repo = "libdisplay-info";
      rev = version;
      hash = "sha256-nXf2KGovNKvcchlHlzKBkAOeySMJXgxMpbi5z9gLrdc=";
    };
  });

  withPinnedLibdisplayInfo =
    pkg:
    pkg.overrideAttrs (old: {
      buildInputs = map (
        dep: if (dep.pname or null) == "libdisplay-info" then libdisplayInfo03 else dep
      ) old.buildInputs;
    });

  niriPkgs = inputs.niri.packages.${prev.stdenv.hostPlatform.system};
in
{
  niri-stable = withPinnedLibdisplayInfo niriPkgs.niri-stable;
}
