# Pin Bitwig Studio to 6.0 (nixpkgs tracks 6.0.11) and swap in a local
# bitwig.jar.
#
# The 6.0 installer is fetched from upstream like any other source, so this
# part of the config is self-contained. The jar is ~35 MB and unfree, so it is
# deliberately NOT tracked in this repo — only its hash is. `requireFile` turns
# it into a fixed-output derivation resolved against the local store, so
# evaluation stays pure and the jar never reaches the remote. Seed it once per
# machine with the command in the `message` below.
final: prev:
let
  bitwigJar = prev.requireFile {
    name = "bitwig.jar";
    sha256 = "1d2qr8dwrz0qbfwm9pk35p0zcp1ys0gkscf4adpfkz3mg19xks1a";
    message = ''
      This overlay needs a local bitwig.jar that is not tracked in git.
      Add it to the store with:

        nix-store --add-fixed sha256 /path/to/bitwig.jar
    '';
  };
in
{
  bitwig-studio = prev.bitwig-studio.overrideAttrs (old: {
    version = "6.0";

    # Same URL scheme upstream uses; bitwig.com still serves old releases.
    # To avoid re-downloading 380 MB when the .deb is already on disk:
    #   nix-store --add-fixed sha256 /path/to/bitwig-studio-6.0.deb
    # That yields the exact output path this fetchurl resolves to, so the
    # fetch is skipped.
    src = prev.fetchurl {
      name = "bitwig-studio-6.0.deb";
      url = "https://www.bitwig.com/dl/Bitwig%20Studio/6.0/installer_linux";
      hash = "sha256-jrCTgaxfeWhfKwLeKLmqTQWS7RVbVnHqJ0InCipmm8k=";
    };

    # postInstall, not postFixup: autoPatchelfHook/wrapGAppsHook3 run in the
    # fixup phase and the jar should be in place before they walk libexec.
    postInstall = (old.postInstall or "") + ''
      chmod u+w "$out"/libexec/bin
      install -m 0444 ${bitwigJar} "$out"/libexec/bin/bitwig.jar
      chmod u-w "$out"/libexec/bin
    '';
  });
}
