{config, lib, pkgs, userSettings, systemSettings, inputs, ...}:
{
  home-manager.users.${userSettings.username} = {
   programs.git = {
    enable = true;
    userName = userSettings.name;
    userEmail = userSettings.email;
  };
  };


}