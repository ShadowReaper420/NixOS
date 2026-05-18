
{ den, ... }:
{
  # user aspect
  den.aspects.flugel = {
    includes = [
      den.batteries.define-user
      den.batteries.primary-user        
      (den.batteries.user-shell "fish")
    ];

    homeManager =
      { pkgs, ... }:
      {
        home.packages = [];
      };

    # user can provide NixOS configurations
    # to any host it is included on
    provides.to-hosts.nixos = { pkgs, ... }: { };
  };
}
