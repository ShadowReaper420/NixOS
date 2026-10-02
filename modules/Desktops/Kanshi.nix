{lib, den, ...}:

{
  den.aspects.kanshi = {
 
    homeManager = {pkgs, ...}: {
      services.kanshi = {
        enable = true;
        settings = [
          {
            profile.name = "home";
            profile.outputs = [
              {
                criteria = "DP-2";
                position = "0,0";
                mode = "2560x1440@144Hz";
                scale = 1.0;
              }
              {
                criteria = "HDMI-A-1";
                position = "2560,0";
                mode = "1920x1080@60Hz";
                scale = 1.0;
              }

            ];
          }
        ];
      };
    };
  };
}








