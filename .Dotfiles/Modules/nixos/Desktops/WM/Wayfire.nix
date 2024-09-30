{config, lib, pkgs, ...}:

{ environment.systemPackages = with pkgs;[
  
  wayfire-with-plugins
  

  ];

}
