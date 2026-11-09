{
  description = "kitty unifed config!! :3";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/release-26.05";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    base16.url = "github:SenchoPens/base16.nix";
    tt-schemes = {
      url = "github:tinted-theming/schemes";
      flake = false;
    };
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    prismlauncher = {
      url = "github:PrismLauncher/PrismLauncher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    affinity-nix = {
      url = "github:mrshmllow/affinity-nix";
    };
    quickshell = {
      url ="git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:epireyn/niri-flake";
    };
    qml-language-server = {
      url = "github:cushycush/qml-language-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixcord = {
      url = "github:FlameFlag/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, nix-darwin, home-manager, ... }:
  let
    lib = nixpkgs.lib;

    mkHomeUsers = { users, platformModules }:
      lib.genAttrs users (name: {
        imports = [ (./users + "/${name}.nix") ] ++ platformModules;
        _module.args.expectedUsername = name;
      });

    mkDarwin = { system, hostModule, platformModules, users, primaryUser }: nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = inputs // { hostUsers = users; inherit primaryUser; };
      modules = [
        home-manager.darwinModules.home-manager
        hostModule
        {
          home-manager.useGlobalPkgs = true;
          home-manager.extraSpecialArgs = { inherit inputs; scheme = null; };
          home-manager.users = mkHomeUsers { inherit users; inherit platformModules; };
          home-manager.backupFileExtension = ".bak";
        }
      ];
    };

    mkNixos = { system, hostModules, platformModules, users }: lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; hostUsers = users; };
      modules = hostModules ++ [
        inputs.base16.nixosModule
        inputs.agenix.nixosModules.default
        home-manager.nixosModules.home-manager
        {
          nixpkgs.overlays = [
            inputs.fenix.overlays.default
            (import ./overlays/lix.nix)
            (import ./overlays/affinity.nix inputs)
            # upstream niri-stable now builds against niri-flake's own nixpkgs and is in its cache
            (final: prev: { niri-stable = inputs.niri.packages.${prev.stdenv.hostPlatform.system}.niri-stable; })
            # (import ./overlays/niri-libdisplay-info.nix inputs)
            (import ./overlays/bitwig-studio.nix)
            # (import ./overlays/eternal-terminal-cxx20.nix)
          ];
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = ".bak";
        }
        ({ config, ... }: {
          home-manager.extraSpecialArgs = { inherit inputs; scheme = config.scheme; };
          home-manager.users = mkHomeUsers { inherit users; inherit platformModules; };
        })
      ];
    };
  in {
    darwinConfigurations."Aoifes-MacBook-Air" = mkDarwin {
      system = "aarch64-darwin";
      hostModule = ./hosts/macbook/configuration.nix;
      platformModules = [ ./home/common ./home/darwin ];
      users = [ "ifa" ];
      primaryUser = "ifa";
    };

    nixosConfigurations."koitar" = mkNixos {
        system = "x86_64-linux";
        hostModules = [
          ./hosts/koitar/configuration.nix
          ./hosts/koitar/hardware-configuration.nix
        ];
        platformModules = [ ./home/common ./home/nixos inputs.niri.homeModules.niri inputs.nixcord.homeModules.nixcord  ];
        users = [ "ifa" ];
    };
    };
}
