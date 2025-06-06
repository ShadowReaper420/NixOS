{config, self, lib, pkgs, userSettings, systemSettings, niri, inputs, ...}:
{
  nixpkgs.overlays = [niri.overlays.niri];
  programs.niri.enable = true;

   home-manager.users.${userSettings.username} = {
      "Mod" = "Super";
      "$browser" = userSettings.browser;
      "$term" = userSettings.terminal;
      "$filemanager" = userSettings.fileManager;


    programs.niri.settings = {
      (binds = {

        #_________Aplication Keybinds_________#
        "${Mod}+T".action.spawn = "$term";
        "${Mod}+E".action.spawn = "$filemanager";
        "${Mod}+F".action.spawn = "$browser";
        "${Mod}+A".action.spawn = "~/.config/rofi/launchers/type-6/launcher.sh";
        #___________Window Keybinds___________#
        "${Mod}+Q".action = quit { skipconfirmation=true; };
        "${Mod}+ENTER".action = fullscreen-window;
        "${Mod}+W".action = toggle-window-floating;
        "${Mod}+Plus".action = setcolumn-width "+10";
        "${Mod}+Minus".action = setcolumn-width "-10";
        "${Mod}+M".action = maximize-column;
        "${Mod}+C".action = center-column; 
        

        

      })
      (binds {
                suffixes."Left" = "column-left";
                suffixes."Down" = "window-down";
                suffixes."Up" = "window-up";
                suffixes."Right" = "column-right";
                prefixes."${Mod}" = "focus";
                prefixes."${Mod}+Ctrl" = "move";
                prefixes."${Mod}+Shift" = "focus-monitor";
                prefixes."${Mod}+Shift+Ctrl" = "move-window-to-monitor";
                substitutions."monitor-column" = "monitor";
                substitutions."monitor-window" = "monitor";


      })
s
      (binds {

      });

      layout = {
        gaps = 8;
        struts.left = 16;
        struts.right = 16;
        border.width = 4;
        

        border.active.gradient = {
          from = "red";
          to = "blue";
          in' = "oklch shorter hue";  
       
      };
      border.inactive.gradient = {
        from = "gray";
        to = "blue";
        in' = "oklch shorter hue";
      };
      animations = {
        enable = true;

      };
      
    };
    };
   };
    
  

}