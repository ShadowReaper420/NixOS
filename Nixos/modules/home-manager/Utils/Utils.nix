 {config, lib, pkgs, ...}:
 #This is where I dump crap that should be on every install.
  {
 home.packages = with pkgs; [
  mpv
  keepassxc
  kePackages.dolphin
  kdePackages.gwenview
  kdePackages.kate
  kdePackages.partitionmanager
  obsidian
  thunderbird
  #____________________
  #Web browsers, pick your poision, I recommend either Floorp or Brave.
  floorp
  #brave
  #firefox
  #chromium
  #____________________
 ];
  }