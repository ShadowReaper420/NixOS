{den, ...}:
{
  den.aspects.fonts = {

    nixos = {pkgs, lib, ...}: {
      
      fonts.packages = with pkgs; [
        font-awesome
        material-symbols
        material-icons
      ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
    };
  };
}
