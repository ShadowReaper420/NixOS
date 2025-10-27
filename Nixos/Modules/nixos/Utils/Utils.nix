{
  config,
  lib,
  pkgs,
  pkgs-stable,
  userSettings,
  inputs,
  systemSettings,
  winapps,
  ...
}: {
  environment.systemPackages = 
  with pkgs; [
    wget
    kitty
    fuse
    kdePackages.ark
    unrar
    #kdePackages.full
    kdePackages.kservice
    cpio
    cmake
    libadwaita
    zenity
    p7zip
    themechanger
    kdePackages.qtstyleplugin-kvantum
    davinci-resolve
    libreoffice
    obs-studio
    blender
    krita
    gimp
    floorp-bin
    brave
    kdePackages.kwalletmanager
    kdePackages.qtbase
    kdePackages.qttools
    kdePackages.qtdeclarative
    kdePackages.qtquick3d
    kdePackages.qtscxml
    kdePackages.qt6gtk2
    desmume
    r2modman
    wireplumber
    kdePackages.partitionmanager
    kdePackages.qt6ct
    planify
    inputs.winapps.packages."${system}".winapps
    inputs.winapps.packages."${system}".winapps-launcher
    inputs.winboat.packages."${system}".winboat
    freerdp
    #jdk25
    #kdePackages.kdenlive

  ]
  ++
  [
    #lsp and other Dev crap
    git
    #nixd
    nil
    rust-analyzer
    python313Packages.python-lsp-server
    emacs
    ripgrep
    cargo
    alejandra
    docker-compose
    godot
    lua-language-server

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

  ]
  ++
  [
    #quickshell shite
    #wallust
    #quickshell
    kdePackages.qt5compat
    kdePackages.qtmultimedia
    kdePackages.qtsvg
    kdePackages.qtimageformats
    #  inputs.nix-qml.packages.${systemSettings.system}.tree-sitter-qmljs
    #  inputs.nix-qml.packages.${systemSettings.system}.qml-ts-mode

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
      vesktop
    ];
  };
}
