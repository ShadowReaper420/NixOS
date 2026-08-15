{ inputs, self, pkgs, den, ... }:

{
  den.aspects.stylix = {

    flake-file = {
      inputs = {
        stylix = {
          url = "github:nix-community/stylix";
          inputs.nixpkgs.follows = "nixpkgs";
        }; 

      };      
    };

    nixos = {pkgs, inputs, ...}: {
      stylix = {
        enable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
        autoEnable = false;
      };

    };
    home-manager = {pkgs, inputs, ...}: {

      #gtk.gtk4.theme = config.gtk.theme;
      qt = {
        enable = true;
        platformTheme.name = "qtct";
        style = {
          name = "kvantum";
          package = pkgs.catppuccin-kvantum.override {
            variant = "mocha";
            accent = "blue";
          };
        };
      };
      home.packages = with pkgs; [
        libsForQt5.qtstyleplugin-kvantum
        libsForQt5.qt5ct
      ];

      stylix = {
        enable = true;
        #image = ../.dotfiles/Wallpapers/Kath.png; # ignore this it wont actually be used for anything but the option is require for the time being
        base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
        autoEnable = true;
        targets = {
          kitty.enable = true;
          lazygit.enable = true;
          qt.enable = false;
          gtk.enable = true;
          btop.enable = true;
          kde.enable = false;
          emacs.enable = true;


        };
      };
      home.pointerCursor = {
        gtk.enable = true;
        # x11.enable = true;
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 16;
      };




      gtk =
        let
          BeautyLine-custom = {
            lib,
            stdenvNoCC,
            fetchFromGitHub,
            breeze-icons,
            gtk3,
            hicolor-icon-theme,
            mint-x-icons,
            candy-icons,
            pantheon,
            jdupes,
            pkgs,
          }:

          stdenvNoCC.mkDerivation rec {
            pname = "BeautyLine";
            version = "0.0.5";

            src = fetchFromGitHub {
              owner = "ShadowReaper420";
              repo = pname;
              rev = version;
              sparseCheckout = [
                "BeautyLine-V3"
              ];
              hash = "sha256-PKO6Mob23NlVgCOJ5guBd/KEZ8KrYPuJyUyomOSOIuU";
            };

            sourceRoot = "${src.name}/BeautyLine-V3";

            nativeBuildInputs = [
              jdupes
              gtk3
            ];

            # ubuntu-mono is also required but missing in ubuntu-themes (please add it if it is packaged at some point)
            propagatedBuildInputs = [
              candy-icons
              breeze-icons
              hicolor-icon-theme
              mint-x-icons
              pantheon.elementary-icon-theme
            ];

            dontDropIconThemeCache = true;

            dontPatchELF = true;
            dontRewriteSymlinks = true;

            installPhase = ''
              runHook preInstall

              mkdir -p $out/share/icons/${pname}
              cp -r * $out/share/icons/${pname}/
              gtk-update-icon-cache $out/share/icons/${pname}

              jdupes --link-soft --recurse $out/share

              runHook postInstall
            '';

            meta = with lib; {
              description = "BeautyLine icon theme";
              homepage = "https://www.gnome-look.org/p/1425426/";
              platforms = platforms.linux;
              license = [ licenses.publicDomain ];
              maintainers = with maintainers; [ gvolpe ];
            };
          };


        in{
          enable = true;
          iconTheme =  {
            package = BeautyLine-custom;
            name = "BeautyLine";
          };
        };

    };

  };

}
