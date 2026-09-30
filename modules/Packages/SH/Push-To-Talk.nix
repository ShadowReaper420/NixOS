{ den, ... }:
{
  # Global push-to-talk: the default microphone is muted except while the
  # configured key is held. Reads evdev directly, so it works on any Wayland
  # compositor (Hyprland, Niri, ...) and affects every app (Discord, Vesktop, ...).
  #
  # Requires your user to be in the `input` group (see Users/Fugel.nix).
  den.aspects.push-to-talk = {
    nixos = { pkgs, lib, config, ... }:
      let
        cfg = config.programs.push-to-talk;

        python = pkgs.python3.withPackages (ps: [ ps.evdev ]);

        pttPy = pkgs.writeText "push-to-talk.py" ''
          import asyncio
          import signal
          import subprocess
          import sys

          import evdev
          from evdev import ecodes

          if len(sys.argv) != 3:
              sys.exit("usage: push-to-talk KEY_NAME WPCTL_SOURCE")

          KEY = sys.argv[1]
          SOURCE = sys.argv[2]
          CODE = ecodes.ecodes.get(KEY)
          if CODE is None:
              sys.exit(f"Unknown key name: {KEY}")

          held = set()    # device paths currently holding the key down
          tracked = {}    # device path -> watcher task


          def set_mute(muted):
              subprocess.run(
                  ["wpctl", "set-mute", SOURCE, "1" if muted else "0"],
                  check=False,
              )


          async def watch(path):
              dev = None
              try:
                  dev = evdev.InputDevice(path)
                  async for ev in dev.async_read_loop():
                      if ev.type != ecodes.EV_KEY or ev.code != CODE:
                          continue
                      if ev.value == 1:
                          held.add(path)
                          set_mute(False)
                      elif ev.value == 0:
                          held.discard(path)
                          if not held:
                              set_mute(True)
              except OSError:
                  pass  # device unplugged
              finally:
                  held.discard(path)
                  tracked.pop(path, None)
                  if dev is not None:
                      dev.close()
                  if not held:
                      set_mute(True)


          async def scan():
              # Rescan periodically so hot-plugged keyboards/mice are picked up.
              while True:
                  for path in evdev.list_devices():
                      if path in tracked:
                          continue
                      try:
                          dev = evdev.InputDevice(path)
                          keys = dev.capabilities().get(ecodes.EV_KEY, [])
                          dev.close()
                      except OSError:
                          continue
                      if CODE in keys:
                          tracked[path] = asyncio.create_task(watch(path))
                  await asyncio.sleep(5)


          def main():
              loop = asyncio.new_event_loop()
              set_mute(True)
              task = loop.create_task(scan())
              for sig in (signal.SIGINT, signal.SIGTERM):
                  loop.add_signal_handler(sig, task.cancel)
              try:
                  loop.run_until_complete(task)
              except asyncio.CancelledError:
                  pass
              finally:
                  set_mute(False)  # never leave the mic muted after exit


          main()
        '';

        push-to-talk = pkgs.writeShellApplication {
          name = "push-to-talk";
          runtimeInputs = [ pkgs.wireplumber ];
          text = ''
            exec ${python}/bin/python ${pttPy} "$@"
          '';
        };
      in
      {
        options.programs.push-to-talk = {
          key = lib.mkOption {
            type = lib.types.str;
            default = "KEY_SCROLLLOCK";
            example = "BTN_EXTRA";
            description = ''
              evdev name of the key or mouse button to hold while talking.
              The key is only observed, not grabbed, so it still reaches
              applications. Pick something that does nothing on its own.
              Find names with `sudo evtest`.
            '';
          };

          source = lib.mkOption {
            type = lib.types.str;
            default = "@DEFAULT_AUDIO_SOURCE@";
            description = "wpctl target to mute/unmute (node ID or @DEFAULT_AUDIO_SOURCE@).";
          };
        };

        config = {
          environment.systemPackages = [ push-to-talk ];

          systemd.user.services.push-to-talk = {
            description = "Global push-to-talk";
            wantedBy = [ "graphical-session.target" ];
            partOf = [ "graphical-session.target" ];
            after = [ "pipewire.service" "wireplumber.service" ];
            serviceConfig = {
              ExecStart = lib.escapeSystemdExecArgs [
                "${push-to-talk}/bin/push-to-talk"
                cfg.key
                cfg.source
              ];
              Restart = "on-failure";
              RestartSec = 2;
            };
          };
        };
      };
  };
}
