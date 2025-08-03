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
    #nil
    #davinci-resolve
    libreoffice
    obs-studio
    blender
    krita
    gimp
    floorp
    brave
    kdePackages.kwalletmanager
    desmume
    r2modman
    wireplumber
    kdePackages.partitionmanager
  ]
  ++
  [
    #lsp and other Dev crap
    git
    nixd
    rust-analyzer
    python313Packages.python-lsp-server
    emacs
    ripgrep
    cargo
    alejandra
    docker-compose
    godot
  ]
  ++
  [
    #CLI Collection
    zoxide
    fzf
    fastfetch
    ranger
    btop
    lazygit

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
      kdePackages.ktorrent
      discord
    ];
  };
}
