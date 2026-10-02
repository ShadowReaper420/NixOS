{ inputs, self, den, ... }:

{
  den.aspects.pihole = {
    nixos = {

      services.pihole-ftl = {
        enable = true;
        settings = {
          dns.upstreams = [ "9.9.9.9" "1.1.1.1" ];
          dns.hosts = [ "192.168.1.188"];
        };

        lists = [
        {
          url = "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/pro.txt";
          type = "block";
          enabled = true;
          description = "hagezi blocklist";
        }
        ];
      };
    };

  }; 
}
