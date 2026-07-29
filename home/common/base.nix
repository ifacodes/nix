{ config, lib, pkgs, expectedUsername, ... }: {
  home.homeDirectory = lib.mkDefault (
    (if pkgs.stdenv.isDarwin then "/Users/" else "/home/") + config.home.username
  );

  assertions = [
    {
      assertion = config.home.username == expectedUsername;
      message = ''
        home.username = ("${config.home.username}") doesn't match the users/ file
        used to define it (${expectedUsername}.nix -> home-manager.users.${expectedUsername}).
        Either rename the file or change home.username in the file;
      '';
    }
  ];

  programs.home-manager.enable = true;
}
