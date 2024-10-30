{config, lib, pkgs, userSettings, systemSettings, inputs, ...}:

{
  users.defaultUserShell = pkgs.fish;

  programs.fish = {
    enable = true;
    shellAliases = {
      os-rebuild = "nh os switch";
      os-rebuild-test = "nixos-rebuild switch --flake ~/NixOS-Dev/Nixos";
      daggerfall = "steam-run ~/Games/Daggerfall-Unity/DaggerfallUnity.x86.64";

    };

  };

  

}