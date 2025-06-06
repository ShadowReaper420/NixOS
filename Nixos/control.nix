{ config, lib, pkgs, userSettings, systemSettings, ... }:

{
  home-modules = home-manager.users.${userSettings.username};

}
