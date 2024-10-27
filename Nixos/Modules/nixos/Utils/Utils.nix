{config, lib, pkgs, ...}:

{ environment.systemPackages = with pkgs;[

  git
  wget
  kitty
  nil
  fuse
 # kdePackages.partitionmanager
  kdePackages.dolphin
  libsForQt5.ark
  cpio
  cmake
  nwg-displays
  xfce.thunar
  #zenity
  p7zip
  themechanger
  kdePackages.qtstyleplugin-kvantum
  libsForQt5.qt5ct
  kdePackages.qt6ct
  wallust
  nixd


]; 

  }
