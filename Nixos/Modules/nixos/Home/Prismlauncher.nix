{ config, lib, pkgs, pkgs-unstable, ... }:

{
  environment.systemPackages = with pkgs-unstable; [
  (prismlauncher.override {
    # Add binary required by some mod
    additionalPrograms = [ ffmpeg ];

    # Change Java runtimes available to Prism Launcher
    jdks = [
      jdk8
      jdk21
      jdk17
#      jdk25
      jdk
      zulu8
      zulu17
      zulu
    ];
  })
];
}
