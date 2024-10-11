{config, lib, pkgs, userSettings, systemSettings, inputs, ...}:

{
  users.defaultUserShell = pkgs.zsh;

  programs.zsh = {
    enable = true;
    shellAliases = {
      os-rebuild = "nh os switch";

    };

  };

  

}