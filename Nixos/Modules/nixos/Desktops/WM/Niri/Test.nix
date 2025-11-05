{ config, lib, pkgs, ... }:

{
  options = {
    programs.niri-cfg = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

  };
}
