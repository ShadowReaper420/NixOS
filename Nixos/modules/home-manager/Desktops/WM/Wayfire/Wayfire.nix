{lib, config, pkgs, ...}:

{
  programs.wayfire = {
  enable = true;
  
  
  xdg.configFile. "./wayfire/wayfire.ini".source = ./Dotfiles/wayfire.ini;
  plugins = with pkgs.wayfirePlugins; [
    wcm
    wf-shell
    wayfire-plugins-extra
  ];
  services.xserver = {
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      #theme = ""
       package = pkgs.sddm;
      

      };
   



    };
};
