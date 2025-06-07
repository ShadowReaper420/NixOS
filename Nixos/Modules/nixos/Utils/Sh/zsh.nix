{
  config,
  lib,
  pkgs,
  userSettings,
  systemSettings,
  inputs,
  ...
}: {
  users.defaultUserShell = pkgs.zsh;

  environment.systemPackages = with pkgs; [
    starship
  ];

  programs.zsh = {
    enable = true;
    shellInit = "fastfetch";
#    shellInit = "starship";
    shellAliases = {
      os-rebuild = "nh os switch";
      os-rebuild-test = "sudo nixos-rebuild switch --flake ~/NixOS-Dev/Nixos";
      daggerfall = "steam-run ~/Games/Daggerfall-Unity/DaggerfallUnity.x86.64";
      emacs = "emacsclient -c -a 'emacs'";
    };
  };

  home-manager.users.${userSettings.username} = {
    home.sessionPath = [
      "$HOME/.config/emacs/bin"
      "$HOME/.bin"
    ];

    programs.zsh = {
      enable = true;
    };
  };
}
