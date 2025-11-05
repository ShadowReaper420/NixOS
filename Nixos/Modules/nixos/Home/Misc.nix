{config, lib, pkgs, inputs, systemSettings, ...}:


{
environment.systemPackages = with pkgs;[
  ktorrent
  #discord
];

}
