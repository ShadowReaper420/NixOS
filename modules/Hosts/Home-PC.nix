{
  den.aspects.Home-PC = {den, hosts, ...}: {
    includes = with den.aspects; [
     hyprland
     flugel
     gaming
     utils
     emacs
     igloo
    ];

  };
}
    
