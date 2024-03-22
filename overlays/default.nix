{ ... }: {

  modifications = final: prev: {
    cargo-mommy = prev.cargo-mommy.overrideAttrs (old: rec {
      pname = "cargo-mommy";
      version = "0.3.1";
      src = prev.fetchFromGitHub {
        owner = "Gankra";
        repo = "cargo-mommy";
        rev = "0ec17361d8b0573d0155984403e576b788abeb60";
        hash = "sha256-Mf0VGxQ90PjNhFA2OnDIFkNZjYDCuMqPsexqy5+gRdI=";
      };
      cargoDeps = old.cargoDeps.overrideAttrs (prev.lib.const {
        name = "${pname}-vendor.tar.gz";
        inherit src;
        outputHash = "sha256-K51iqSsGPvnNVEsE2isNRqSPgaetl719+jyknkyhxYo=";
      });
    });
  };
  
}
