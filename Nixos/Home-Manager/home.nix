{ config, pkgs, systemSettings, userSettings, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = userSettings.username;


  home.stateVersion = "24.05"; # Please read the comment before changing.


  home.file."${config.xdg.configHome}" = {
  source = ../.dotfiles/.config;
  recursive = true;
};

  # The home.packages option allows you to install Nix packages into your
  # environment.

  imports = [
#    ../Modules/home-manager/default.nix

  ];

 # nixpkgs.config.allowUnfree = true;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  
  home.sessionVariables = {
     EDITOR = userSettings.editor;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
