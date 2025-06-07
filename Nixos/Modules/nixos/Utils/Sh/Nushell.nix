{ config, lib, pkgs, userSettings, ... }:

{
  users.defaultUserShell = pkgs.nushell;
  programs.zsh.enable = true;
  home-manager.users.${userSettings.username}= {
    programs.nushell = {
     enable = true;
     extraConfig = ''
     fastfetch


'';
     shellAliases = {
      os-rebuild = "nh os switch";
      os-rebuild-test = "sudo nixos-rebuild switch --flake ~/NixOS-Dev/Nixos";
      daggerfall = "steam-run ~/Games/Daggerfall-Unity/DaggerfallUnity.x86.64";
      emacs = "emacsclient -c -a 'emacs'";

};

};

#    starship = {
#     enable = true;
#};
#carapace.enable = true;
#carapace.enableNushellIntegration = true;

};
}
