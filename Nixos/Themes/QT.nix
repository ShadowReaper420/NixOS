{ config, pkgs, inputs, systemSettings, userSettings, ... }:
{
    environment.systemPackages = [
    pkgs.kdePackages.qtstyleplugin-kvantum
  ];
 # qt.style = "kvantum";
}