{
  imports = [
    ./gnome-mobile
    ./minimal.nix
    ./quirks.nix
    ./recommended.nix
  ];
  networking.hostName = "nix-enchilada";
  nixpkgs.config.allowUnfree = true;

  # networking services
  services.openssh.enable = true;
  services.tailscale.enable = true;

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
  services.bitcoind = {
    enable = true;
    disablewallet = true;
    txindex = true;
  };
  services.clightning = {
    enable = true;
    address = "0.0.0.0";
  };
}
