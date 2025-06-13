# Add your reusable NixOS modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  imports = [
    ./Utils/Utils.nix
    #./Desktops/WM/Wayfire.nix
    ./Desktops/WM/Hyprland/Hyprland.nix
    #./Utils/Sh/zsh.nix
    ./Utils/Sh/Nushell.nix
    ./Utils/Git.nix
    ./Home/Gaming.nix
    ./Home/Spotify.nix
    ./VM-stuff/QEMU.nix
    ./VM-stuff/Distro-box.nix
    ./Utils/Fonts.nix
#    ./Utils/Neovim/Neovim.nix
    ./Desktops/WM/Niri/Niri.nix
    ./Utils/Emacs.nix
    ./Utils/Dolphin.nix
    ./Utils/Flatpak.nix
  ];
}
