{ rust-overlay, ... }: {

  modifications = final: prev: {
    overlays = [
      rust-overlay.overlays.default
    ];
    cargo-mommy = prev.cargo-mommy.overrideAttrs (old: rec {
      pname = "cargo-mommy";
      version = "0.3.1";
      src = builtins.fetchFromGitHub {
        owner = "Gankra";
        repo = "cargo-mommy";
        rev = "0ec17361d8b0573d0155984403e576b788abeb60";
        hash = "sha256-Mf0VGxQ90PjNhFA2OnDIFkNZjYDCuMqPsexqy5+gRdI=";
      };
      cargoDeps = old.cargoDeps.overrideAttrs (_: {
        name = "${pname}-vendor.tar.gz";
        inherit src;
        outputHash = "";
      });
    });
  };
  
}
