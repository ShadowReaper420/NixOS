{config, lib, pgks,}:
{
  home.packages = with pkgs; [
    libreoffice
    obs-studio

  ];
}