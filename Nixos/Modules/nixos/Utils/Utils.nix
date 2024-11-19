{config, lib, pkgs, ...}:

{ environment.systemPackages = with pkgs;[

  git
  wget
  kitty
  fuse
  kdePackages.dolphin
  kdePackages.ark
  cpio
  cmake
  libadwaita
  xfce.thunar
  zenity
  p7zip
  themechanger
  kdePackages.qtstyleplugin-kvantum
  libsForQt5.qt5ct
  kdePackages.qt6ct
  nixd


]; 

  }
