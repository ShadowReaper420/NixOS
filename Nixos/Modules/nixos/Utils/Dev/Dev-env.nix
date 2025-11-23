{ config, lib, pkgs, ... }:

{
    environment.variables = {
      PKG_CONFIG_PATH = [
       "~/.cargo/"

      ]; 
        
    };
}
