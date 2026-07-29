{ lib, ... }: {
  imports = map (n: ./. + "/${n}")
    (builtins.attrNames (lib.filterAttrs
      (n: v: (v == "regular" && lib.hasSuffix ".nix" n && n != "default.nix") || v == "directory")
      (builtins.readDir ./.)));
}

