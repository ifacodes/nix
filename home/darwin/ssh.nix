{ ... }: {
  programs.ssh = {
    includes = [ "~/.orbstack/ssh/config" ];

    settings."*" = {
      IdentityAgent = "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";
      UseKeychain = "yes";
    };
  };
}
