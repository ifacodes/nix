{ lib, ... }: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings."*".IdentityAgent = lib.mkDefault "~/.1password/agent.sock";
  };
}
