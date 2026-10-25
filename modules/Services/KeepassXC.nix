{den, ...}: {

  den.aspects.keepassxc = {

    homeManager = {

      programs.keepassxc = {
        autostart = true;
        enable = true;
        FdoSecrets.Enabled = true;
      };
    };
  };
  
}
