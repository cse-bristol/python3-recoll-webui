{config, pkgs, ...}:
{
  fileSystems."/s" = {
    device = "//cse-bs3-data.cse.org.uk/data";
    fsType = "cifs";
    options = [
      "x-systemd.automount"
      "noauto"
      "ro"
      "x-systemd.idle-timeout=60"
      "x-systemd.device-timeout=5s"
      "x-systemd.mount-timeout=5s"
      "credentials=/etc/cse-robots-cifs-credentials"
    ];
  };

  environment.etc.cse-robots-cifs-credentials.text =
    builtins.readFile /var/keys/cse-robots-cifs-credentials;
  
  systemd.services.recoll-indexer = {
    wantedBy = ["multi-user.target"];
    script = ''
      ${pkgs.recoll}/bin/recollindex  -r /s/
    '';
    startAt = "daily";
    after = ["s.mount"];
    requires = ["s.mount"];
  };

  networking.firewall.allowedTCPPorts = [80];
  
  systemd.services.recoll-webui =
    let
      # webui = builtins.fetchGit {
      #   "url" = "https://github.com/cse-bristol/python3-recoll-webui.git";
      #   "rev" = "7abeda4a07366634d4c0d08b1bbb70eb47f5af3c";
      # };
      python = pkgs.python3.withPackages (p : [
        p.recoll p.paste
      ]);
    in {
      path = [python];
      script = ''
        python /webui/webui-standalone.py -a 0.0.0.0 -p 80
      '';
      wantedBy = ["multi-user.target"];
    };
}
