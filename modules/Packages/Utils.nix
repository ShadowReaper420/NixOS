{  den, inputs, ... }:

{
  den.aspects.utils = {

    includes = [
      (den.batteries.unfree [ "7zz" "p7zip" "obsidian" "discord" "discord-unwrapped" ])
    ];

    nixos = {pkgs, lib, ...}: {


      # fonts.packages = with pkgs; [
      #   font-awesome
      #   material-symbols
      #   material-icons
      # ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);



      programs.nix-ld.enable = true;
      nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

      environment.systemPackages = 
      (with pkgs; [
        wget
        dotnet-runtime
        #nexusmods-app-unfree
        kitty
        fuse
        kdePackages.ark
        unrar 
        kdePackages.kservice
        kdePackages.ktorrent
        cpio
        libadwaita
        zenity
        p7zip-rar
        vesktop
        brave
        themechanger
        kdePackages.qtstyleplugin-kvantum
        kicad
        #davinci-resolve
        obs-studio
        blender
        #krita
        gimp
        #brave  
        kdePackages.kwalletmanager
        kdePackages.qtbase
        kdePackages.qttools
        kdePackages.qtdeclarative
        kdePackages.qtquick3d  
        kdePackages.qtscxml
        #kdePackages.qt6gtk2
        desmume
        r2modman
        wireplumber
        kdePackages.partitionmanager
        kdePackages.qt6ct
        planify
        winboat
        ollama

      ]
      ++
      [
        #lsp and other Dev crap 
        git
        nixd
        nodejs
        #python315
        #nil
        cmake
        clang
        #rust-analyzer
        #rustc 
        #python313Packages.python-lsp-server
        emacs
        ripgrep
        #cargo
        alejandra
        docker-compose
        godot
        lua-language-server
        ispell
        fd
        gvfs
        gradle_9 
        jdk25
        maven
        (gradle.override {javaToolchains = [jdk25];})

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
        television
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
      ])
      ++
      (with pkgs; [
        prismlauncher
        floorp-bin
        lazygit
        libreoffice
        mpv
        keepassxc
        kdePackages.gwenview
        kdePackages.kate
        obsidian
        thunderbird
        kdePackages.ktorrent
        discord
        #quantframe
      ]);

      programs.thunar = {
        enable = false;
        plugins = with pkgs; [
          thunar-archive-plugin
        ];
      };


      services.tumbler.enable = true;
      services.gvfs.enable = true;
    };

  };
}
