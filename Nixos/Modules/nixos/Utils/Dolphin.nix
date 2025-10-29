{ config, userSettings, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs;[
    kdePackages.dolphin
    kdePackages.dolphin-plugins
    kdePackages.qtsvg
    kdePackages.kio-fuse
    kdePackages.kio-extras
    kdePackages.kio-admin
    kdePackages.kservice
  ];

  # Fixes dolphin not having mime types.
  #credit to saygo on vimjoyers discord I stole this fix from their post.
  environment.etc."/xdg/menus/applications.menu".text =
    # This one also works but has to pull in entire plasma workspaces, but might be more future proof
    # builtins.readFile "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
    ''
      <!DOCTYPE Menu PUBLIC "-//freedesktop//DTD Menu 1.0//EN"
      "http://www.freedesktop.org/standards/menu-spec/1.0/menu.dtd">
      <Menu>
      <Name>Applications</Name>
      <DefaultAppDirs/>
      <DefaultDirectoryDirs/>
      <DefaultMergeDirs/>
      </Menu>
    '';

    #Home manager module below change the option to fit your config or move the following into your Home manager config if you use the seperate setup.
    home-manager.users.${userSettings.username} = {
      #READ THROUGH THESE, There are many settings such as default terminal and icon theme that will need to be changed to your system
      xdg.configFile."dolphinrc".text = '' MenuBar=Disabled

      [$Version]
      update_info=dolphin_detailsmodesettings.upd:rename-leading-padding

      [General]
      ShowSelectionToggle=false
      ShowStatusBar=false
      Version=202
      ViewPropsTimestamp=2023,4,26,16,58,48.324

      [IconsMode]
      MaximumTextLines=1
      PreviewSize=112

      [InformationPanel]
      dateFormat=ShortFormat

      [KFileDialog Settings]
      Places Icons Auto-resize=false
      Places Icons Static Size=16

      [KPropertiesDialog]
      2560x1080 screen: Window-Maximized=true

      [MainWindow]
      MenuBar=Disabled
      ToolBarsMovable=Disabled

      [MainWindow][Toolbar mainToolBar]
      IconSize=16
      ToolButtonStyle=IconOnly

      [PlacesPanel]
      IconSize=16

      [PreviewSettings]
      Plugins=appimagethumbnail,audiothumbnail,comicbookthumbnail,cursorthumbnail,djvuthumbnail,ebookthumbnail,exrthumbnail,imagethumbnail,jpegthumbnail,kraorathumbnail,windowsexethumbnail,windowsimagethumbnail,opendocumentthumbnail,svgthumbnail,ffmpegthumbs

      [Toolbar mainToolBar]
      ToolButtonStyle=IconOnly '';

      xdg.configFile."kdeglobals".text = ''
        [General]
        TerminalApplication=${userSettings.terminal}

        [Icons]
        Theme=${userSettings.icons}

        [KDE]
        widgetStyle=kvantum

        [UiSettings]
        ColorScheme=*


        [ColorEffects:Disabled]
        ChangeSelectionColor=
        Color=#211f24
        ColorAmount=0.5
        ColorEffect=3
        ContrastAmount=0
        ContrastEffect=0
        Enable=
        IntensityAmount=0
        IntensityEffect=0

        [ColorEffects:Inactive]
        ChangeSelectionColor=true
        Color=#0c0a10
        ColorAmount=0.025
        ColorEffect=0
        ContrastAmount=0.1
        ContrastEffect=0
        Enable=true
        IntensityAmount=0
        IntensityEffect=0

        [Colors:Button]
        BackgroundAlternate=#47434c
        BackgroundNormal=#2b292f
        DecorationFocus=#cdb9fb
        DecorationHover=#cdb9fb
        ForegroundActive=#e6e0e9
        ForegroundInactive=#948f99
        ForegroundLink=#8fc9fc
        ForegroundNegative=#ffb3b4
        ForegroundNeutral=#fcb38a
        ForegroundNormal=#e6e0e9
        ForegroundPositive=#00e479
        ForegroundVisited=#ebb2ff

        [Colors:Complementary]
        BackgroundAlternate=#121016
        BackgroundNormal=#211f24
        DecorationFocus=#cdb9fb
        DecorationHover=#cdb9fb
        ForegroundActive=#e6e0e9
        ForegroundInactive=#948f99
        ForegroundLink=#8fc9fc
        ForegroundNegative=#ffb3b4
        ForegroundNeutral=#fcb38a
        ForegroundNormal=#cac4cf
        ForegroundPositive=#00e479
        ForegroundVisited=#ebb2ff

        [Colors:Header]
        BackgroundAlternate=#211f24
        BackgroundNormal=#211f24
        DecorationFocus=#cdb9fb
        DecorationHover=#cdb9fb
        ForegroundActive=#e6e0e9
        ForegroundInactive=#948f99
        ForegroundLink=#8fc9fc
        ForegroundNegative=#ffb3b4
        ForegroundNeutral=#fcb38a
        ForegroundNormal=#cac4cf
        ForegroundPositive=#00e479
        ForegroundVisited=#ebb2ff

        [Colors:Header][Inactive]
        BackgroundAlternate=#211f24
        BackgroundNormal=#211f24
        DecorationFocus=#cdb9fb
        DecorationHover=#cdb9fb
        ForegroundActive=#e6e0e9
        ForegroundInactive=#948f99
        ForegroundLink=#8fc9fc
        ForegroundNegative=#ffb3b4
        ForegroundNeutral=#fcb38a
        ForegroundNormal=#cac4cf
        ForegroundPositive=#00e479
        ForegroundVisited=#ebb2ff

        [Colors:Selection]
        BackgroundAlternate=#cdb9fb
        BackgroundNormal=#cdb9fb
        DecorationFocus=#cdb9fb
        DecorationHover=#c9bfd8
        ForegroundActive=#36265d
        ForegroundInactive=#36265d
        ForegroundLink=#004b73
        ForegroundNegative=#920023
        ForegroundNeutral=#753400
        ForegroundNormal=#36265d
        ForegroundPositive=#005228
        ForegroundVisited=#74009f

        [Colors:Tooltip]
        BackgroundAlternate=#47434c
        BackgroundNormal=#211f24
        DecorationFocus=#cdb9fb
        DecorationHover=#cdb9fb
        ForegroundActive=#e6e0e9
        ForegroundInactive=#948f99
        ForegroundLink=#8fc9fc
        ForegroundNegative=#ffb3b4
        ForegroundNeutral=#fcb38a
        ForegroundNormal=#e6e0e9
        ForegroundPositive=#00e479
        ForegroundVisited=#ebb2ff

        [Colors:View]
        BackgroundAlternate=#211f24
        BackgroundNormal=#121016
        DecorationFocus=#cdb9fb
        DecorationHover=#65558f
        ForegroundActive=#e6e0e9
        ForegroundInactive=#948f99
        ForegroundLink=#8fc9fc
        ForegroundNegative=#ffb3b4
        ForegroundNeutral=#fcb38a
        ForegroundNormal=#e6e0e9
        ForegroundPositive=#00e479
        ForegroundVisited=#ebb2ff

        [Colors:Window]
        BackgroundAlternate=#47434c
        BackgroundNormal=#211f24
        DecorationFocus=#cdb9fb
        DecorationHover=#cdb9fb
        ForegroundActive=#8fc9fc
        ForegroundInactive=#948f99
        ForegroundLink=#8fc9fc
        ForegroundNegative=#ffb3b4
        ForegroundNeutral=#fcb38a
        ForegroundNormal=#cac4cf
        ForegroundPositive=#00e479
        ForegroundVisited=#ebb2ff


      '';

    };



}
