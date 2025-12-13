{
  config,
  lib,
  pkgs,
  userSettings,
  systemSettings,
  inputs,
  ...
}: {
  home-manager.users.${userSettings.username} = {
    programs.git = {
      enable = true;
      settings = {
      user.name = "ShadowReaper420";
      user.email = userSettings.email;
      };
    };
  };
}
