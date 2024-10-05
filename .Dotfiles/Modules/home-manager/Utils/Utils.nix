 {config, lib, pkgs, ...}:
 #This is where I dump crap that should be on every install.
  {
 home.packages = with pkgs; [
  mpv
  keepassxc
  kdePackages.dolphin
  kdePackages.gwenview
  kdePackages.kate
  kdePackages.partitionmanager
  obsidian
  thunderbird
  vscodium
  #____________________
  #Web browsers, pick your poision, I recommend either Floorp or Brave.
  floorp
  #brave
  #____________________
 ];
  }
