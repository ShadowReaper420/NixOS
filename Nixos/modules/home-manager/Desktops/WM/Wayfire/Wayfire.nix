{lib, config, pkgs, ...}:

{
 programs.wayfire = {
  enable = true;
  plugins = with pkgs.wayfirePlugins; [
    wcm
    wf-shell
    wayfire-plugins-extra
  ];
  };
}
{
 home.file = {
   ".config" = {
     source = config.lib.file.mkOutOfStoreSymlink ./Dotfiles/wayfire.ini;
    };

  };
