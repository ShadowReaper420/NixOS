{config, lib, userSettings.systemSettings. ...}:

{

  #Hyprland config
  wayland.windowMnager.hyprland = {
    enable = true;
    "$mod" = "SUPER";
    "$browser" = browser;
    "$term" = terminal;
    "$filemanager" = fileManager;
    bind =
    [
      #________Aplication Keybinds________#

      "$mod, F, exec, $browser"
      "$mod, E, exec, $filemanager"
      "$mod, T, exec, $term"

      #________Workspace Keybinds________#
      "$mod, 1, split:workspace, 1"
      "$mod, 2, split:workspace, 2"
      "$mod, 3, split:workspace, 3"
      "$mod, 4, split:workspace, 4"
      "$mod, 5, split:workspace, 5"
      "$mod, 6, split:workspace, 6"
      "$mod, 7, split:workspace, 7"
      "$mod, 8, split:workspace, 8"
      "$mod, 9, split:workspace, 9"

      #________Window Managment Keybinds________#
      
    

    ] 
     
    settings = {

    }
  }



  
}