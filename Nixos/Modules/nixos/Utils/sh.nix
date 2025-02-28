{config, lib, pkgs, userSettings, systemSettings, inputs, ...}:

{
  users.defaultUserShell = pkgs.zsh;

  programs.zsh = {
    enable = true;
    shellAliases = {
      os-rebuild = "nh os switch";
      os-rebuild-test = "sudo nixos-rebuild switch --flake ~/NixOS-Dev/Nixos";
      daggerfall = "steam-run ~/Games/Daggerfall-Unity/DaggerfallUnity.x86.64";
      doom = "~/.config/emacs/bin/doom run";


    };

  };

  home-manager.users.${userSettings.username} = {
      home.sessionPath = [
     "$HOME/.config/emacs/bin"
    ];
  };


  

}