{
  config,
  lib,
  pkgs,
  pkgs-stable,
  inputs,
  den,
  ...
}:



{
  den.aspects.Utils = {
    nixos = {

      #remove once https://github.com/NixOS/nixpkgs/issues/514113#issuecomment-4338976393 is resolved
      nixpkgs.overlays = [
        (_: prev: {
          openldap = prev.openldap.overrideAttrs {
            doCheck = !prev.stdenv.hostPlatform.isi686;
          };
        })
      ];



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
        cpio
        libadwaita
        zenity
        p7zip-rar
        vesktop
        brave
        themechanger
        kdePackages.qtstyleplugin-kvantum
        kicad
        davinci-resolve
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
        kdePackages.qt6gtk2
        desmume
        r2modman
        wireplumber
        kdePackages.partitionmanager
        kdePackages.qt6ct
        planify
        winboat
        ollama
        openclaw

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
        jetbrains.idea
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
      (with pkgs-stable; [
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
        enable = true;
        plugins = with pkgs; [
          thunar-archive-plugin
        ];
      };


      services.tumbler.enable = true;
      services.gvfs.enable = true;
    };

  };
}
