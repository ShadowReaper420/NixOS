{ config, lib, pkgs, ... }:

{
   environment.systemPackages = with pkgs; [
    (lutris.override {
       extraPkgs = pkgs: [
         # List package dependencies here
         proton-ge-bin
         
       ];
    })
  ]; 
}
