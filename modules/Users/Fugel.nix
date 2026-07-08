{den, ...}:
{
  den.aspects.flugel = {
    includes = [
      den.batteries.define-user
      den.batteries.primary-user
      (den.batteries.user-shell "fish")
    ];

    nixos = {config, ...}: {
      programs.fish.enable = true;


    };

  };
}
