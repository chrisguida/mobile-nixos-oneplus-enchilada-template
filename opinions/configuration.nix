{ pkgs, ... }:
let
  low-mem-build-bitcoind = pkgs.bitcoind.overrideAttrs (oldAttrs: {
    # Use preConfigure to explicitly set the CXXFLAGS
    preConfigure = ''
      export CXXFLAGS="${oldAttrs.CXXFLAGS or ""} --param ggc-min-expand=1 --param ggc-min-heapsize=32768"
    '';
#    src = pkgs.fetchFromGitHub {
#      owner = "benthecarman";
#      repo = "bitcoin";
#      rev = "5706e1f94c3feca2bdf894fa7b770445addd6e89";
#      sha256 = "";
#    };
  });
in
{
  imports = [
    ./gnome-mobile
    ./minimal.nix
    ./quirks.nix
    ./recommended.nix
  ];

  # nixpkgs config
  nixpkgs.config.allowUnfree = true;

  # networking config
  networking.hostName = "nix-enchilada";
  networking.firewall.allowedTCPPorts = [ 3001 8333 9735 50001 ];

  # networking services
  services.openssh.enable = true;
  services.tailscale.enable = true;
  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };

  # users
  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKAyg23mUQq55zHvcjo+F8bVXDQ33b4uIhiYU99V3lX1 cguida@cg-acer"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEQjOgrgPaeaCAMMgNpjayLgj6EPC4m32MSCklYyYsuU cguida@cg-lenovo"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHe7dngSz9Krt4V0dH3EZkwOiim/vEYCgDNb3ENxplJ6 cguida@nix-beast"
    ];
  };
  users.users = {
    cguida = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKAyg23mUQq55zHvcjo+F8bVXDQ33b4uIhiYU99V3lX1 cguida@cg-acer"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEQjOgrgPaeaCAMMgNpjayLgj6EPC4m32MSCklYyYsuU cguida@cg-lenovo"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHe7dngSz9Krt4V0dH3EZkwOiim/vEYCgDNb3ENxplJ6 cguida@nix-beast"
      ];
      isNormalUser = true;
      extraGroups = [
        "bitcoin"
        "clightning"
        "dialout"
        "feedbackd"
        "networkmanager"
        "video"
        "wheel"
      ];
    };
  };
  users.users = {
    defaultUser = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKAyg23mUQq55zHvcjo+F8bVXDQ33b4uIhiYU99V3lX1 cguida@cg-acer"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEQjOgrgPaeaCAMMgNpjayLgj6EPC4m32MSCklYyYsuU cguida@cg-lenovo"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHe7dngSz9Krt4V0dH3EZkwOiim/vEYCgDNb3ENxplJ6 cguida@nix-beast"
      ];
      isNormalUser = true;
      extraGroups = [
        "dialout"
        "feedbackd"
        "networkmanager"
        "video"
        "wheel"
      ];
    };
  };

  # nix-bitcoin stuff
  nix-bitcoin.generateSecrets = true;
  nix-bitcoin.nodeinfo.enable = true;
  services.bitcoind = {
    package = low-mem-build-bitcoind;
    enable = true;
    disablewallet = true;
    txindex = true;
  };
  services.clightning = {
    enable = true;
    address = "0.0.0.0";
  };
  services.clightning-rest = {
    enable = true;
    lndconnect = {
      enable = true;
      onion = true;
    };
  };
  services.rtl = {
    enable = true;
    nodes.clightning.enable = true;
  };
  services.fulcrum = {
    enable = true;
    address = "0.0.0.0";
  };
  # enable Tor hidden services, and tor client
  services.tor = {
    enable = true;
    client.enable = true;
  };

  # enable mempool service, use Fulcrum as backend for address lookups,
  # and enable Tor hidden service for mempool
  services.mempool = {
    enable = true;
    electrumServer = "fulcrum";
    tor = {
      proxy = true;
      enforce = true;
    };
  };
  nix-bitcoin.onionServices.mempool-frontend.enable = true;
}
