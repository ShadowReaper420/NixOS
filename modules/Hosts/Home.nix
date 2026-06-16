{ inputs, self, den, ... }:
{
  den.aspects.Home-PC = {
    includes = [
     den.hyprland
     den.flugel
     den.gaming
     den.utils
     den.emacs
    ];

  };
}
