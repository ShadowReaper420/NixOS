{config, lib, ...}:
{
  wayland.windowManager.hyprland.settings = {

    animations = {
     enabled = "yes";
     bezier = [
      "wind, 0.05, 0.9, 0.1, 1.05"
      "winIn, 0.1, 1.1, 0.1, 1.1"
      "winOut, 0.3, -0.3, 0, 1"
      "liner, 1, 1, 1, 1"
];
    animation = [
      "workspaces, 1, 5, wind"
      "windowsIn, 1, 6, winIn, slide"
      "windowsOut, 1, 5, winOut, slide"
      "windowsMove, 1, 5, wind, slide"
      "border, 1, 1, liner"
      "borderangle, 1, 30, liner, loop"
      "fade, 1, 10, default"
      "workspaces, 1, 5, wind"


    ];
    };
    cursor = [
      "no_hardware_cursors = true"

    ];

    dwindle = [
      "pseudotile = yes"


    ];
  };

}
