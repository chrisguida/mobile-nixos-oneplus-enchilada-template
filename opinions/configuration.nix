{
  imports = [
    ./gnome-mobile
    ./minimal.nix
    ./quirks.nix
    ./recommended.nix
  ];
  nixpkgs.config.allowUnfree = true;
  services.openssh.enable = true;
  users.users.root = {
    openssh.authorizedKeys.keys = [
      # FIXME: Replace this with your SSH pubkey
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKAyg23mUQq55zHvcjo+F8bVXDQ33b4uIhiYU99V3lX1 cguida@cg-acer"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEQjOgrgPaeaCAMMgNpjayLgj6EPC4m32MSCklYyYsuU cguida@cg-lenovo"
    ];
  };
  users.users = {
    cguida = {
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
  services.bitcoind = {
    enable = true;
    disablewallet = true;
    txindex = true;
#    rpc = {
#      address = "0.0.0.0";
#      allowip = [ "192.168.100.0/24" "100.75.154.0/24" ];
#    };
  };
  nix-bitcoin.generateSecrets = true;
}
