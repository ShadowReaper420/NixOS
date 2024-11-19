{config, lib, pkgs, userSettings, systemSettings, inputs, ...}:
{
  qt = {
    enable = true;
    platformTheme = "qtct";
    style.name = "kvantum";
  };
}