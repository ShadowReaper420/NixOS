{config, lib, pkgs, ...}:


{
  home.packages = with pkgs; [
    zoxide
    fzf
    fastfetch
    ranger
    btop
    lazygit
  ];
}