{
  config,
  lib,
  pkgs,
  pkgs-stable,
  userSettings,
  ...
}: {
  environment.systemPackages = 
  with pkgs; [
    #godot_4_3
    git
    wget
    kitty
    fuse
    kdePackages.ark
    unrar
    kdePackages.full
    kdePackages.kservice
    cpio
    cmake
    libadwaita
    zenity
    p7zip
    themechanger
    kdePackages.qtstyleplugin-kvantum
    nixd
    #davinci-resolve
    libreoffice
    obs-studio
    blender
    krita
    gimp
    emacs
    brave
    kdePackages.kwalletmanager
    desmume
    cargo
    r2modman
    alejandra
    docker-compose
    ryubing
    wireplumber
    sddm-astronaut

  ];

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
    ];
  };

  services.tumbler.enable = true;
  services.gvfs.enable = true;

  home-manager.users.${userSettings.username} = {
    home.packages = with pkgs; [
      mpv
      keepassxc
      kdePackages.gwenview
      kdePackages.kate
      obsidian
      thunderbird
      vscodium
      #swww
      kdePackages.ktorrent
      discord
      #upscayl

      #____________________
      #Web browsers, pick your poision, I recommend either Floorp or Brave.
      floorp
      #brave
      #____________________
    ];
  };
}
