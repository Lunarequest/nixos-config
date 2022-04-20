{ config, pkgs, inputs, ... }: {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "nullrequest";
  home.homeDirectory = "/home/nullrequest";

  # allow unfree packages
  nixpkgs.config.allowUnfree = true;

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "qt";
  };
  programs.bat.enable = true;

  programs.gpg = {
    enable = true;
    settings = { use-agent = true; };
  };

  # This defines packages
  home.packages = with pkgs; [
    any-nix-shell
    scrcpy
    nix-index
    updog
    nixfmt
    cachix
    niv
    age
    pinentry-qt
    inputs.deploy-rs.packages."x86_64-linux".deploy-rs
  ];

  programs.git = {
    enable = true;
    userName = "Luna D Dragon";
    userEmail = "advaith.madhukar@gmail.com";
    extraConfig = {
      color.ui = true;
      pull.rebase = true;
      merge.conflictstyle = "diff3";
      diff.algorithm = "patience";
      protocol.version = "2";
      core.commitGraph = true;
      gc.writeCommitGraph = true;
    };
    signing = {
      key = null;
      signByDefault = true;
      gpgPath = "gpg";
    };
  };
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.

  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
