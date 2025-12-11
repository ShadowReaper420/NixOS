{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  userSettings,
  inputs,
  systemSettings,
  winapps,
  ...
}: {

  

  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  environment.systemPackages = 
    (with pkgs; [
    wget
    kitty
    fuse
    kdePackages.ark
    unrar
    #kdePackages.full
    kdePackages.kservice
    cpio
    libadwaita
    zenity
    p7zip
    themechanger
    kdePackages.qtstyleplugin-kvantum
    kicad
    davinci-resolve
    libreoffice
    obs-studio
    blender
    krita
    gimp
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
    #inputs.winapps.packages."${system}".winapps
    #inputs.winapps.packages."${system}".winapps-launcher
    #inputs.winboat.packages."${system}".winboat
    #freerdp


    #kdePackages.kdenlive

    ]
  ++
  [
    #lsp and other Dev crap
    git
    nixd
    #nil
    cmake
    clang
    #rust-analyzer
    #rustc 
    python313Packages.python-lsp-server
    emacs
    ripgrep
    #cargo
    alejandra
    docker-compose
    godot
    lua-language-server
    ispell
    fd

  ]
  ++
  [
    #CLI Collection
    zoxide
    fzf
    fastfetch
    ranger
    btop
    #lazygit

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

  ])
      ++
      (with pkgs-unstable; [
        prismlauncher
        floorp-bin
        lazygit
        nexusmods-app-unfree
        vintagestory
      ]);

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
