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
  xdg.mime.defaultApplications = {
   "inode/directory" = "dolphin.desktop";
   "image/png" = "gwenview";

};

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

        [Colors:View]
        BackgroundNormal=#00000000

        [KDE]
        widgetStyle=kvantum

        [UiSettings]
        ColorScheme=*
      '';

    };



}
