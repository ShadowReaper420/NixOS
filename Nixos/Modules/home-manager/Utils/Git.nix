{config, lib, pkgs, userSettings, systemSettings, inputs, ...}:
{
  programs.git = {
    enable = true;
    userName = userSettings.name;
    userEmail = userSettings.email;
  };
}