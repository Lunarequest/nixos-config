# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, options, ... }: {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../common/security.nix
  ];
  nixpkgs.overlays = [ (import ./packages) ];
  nixpkgs.config.allowUnfree = true;
  nix = {
    package = pkgs.nixUnstable;
    settings = { 
    	auto-optimise-store = true;
    };	
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 10d";
    };

  };
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 2;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.compressor = "zstd";
  boot.kernelPackages = pkgs.linuxPackages_latest; 
  #boot.extraModulePackages = with config.boot.kernelPackages; [pkgs.keymash];

  zramSwap = {
    enable = true;
    memoryPercent = 50;
    algorithm = "zstd";
  };

  networking = {
    hostName = "gipsy-avenger"; # Define your hostname.
    timeServers = [ "time.cloudflare.com" ];
    #nameservers = [ "127.0.0.1" "::1" ];
    dhcpcd.extraConfig = "nohook resolv.conf";
    #resolvconf.enable = false;
    # If using NetworkManager:
    networkmanager = {
      enable = true; # Enables wireless support via wpa_supplicant.
      #dns = "none";
    }; 
  };

  services.dnscrypt-proxy2 = {
     enable = false;
     settings = {
     ipv6_servers = true;
     require_dnssec = true;

      sources.public-resolvers = {
      	 urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
       ];
        cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
        minisign_key =
          "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      };

      # You can choose a specific set of servers from https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
       server_names = [ "cloudflare" ];
    };
  };

  # Set your time zone.
  time.timeZone = "Asia/Kolkata"; 
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };
  programs.zsh.enable = true;
  programs.dconf.enable = true;
  programs.adb.enable = true;
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    displayManager.sddm = {
      enable = true;
      theme = "Nord";
    };
    desktopManager.plasma5.enable = true;
  };
  services.pcscd.enable = true;
  services.gnome = {
    gnome-keyring.enable = true;
    at-spi2-core.enable = true;
  };
  security.pam.services.sddm.enableGnomeKeyring = true;
  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  services.printing = {
  	enable = true;
  	drivers = [pkgs.epson-201401w];

  };

  services.avahi = {
    enable = true;
    nssmdns = true;
  };

  security.apparmor.enable = true;
  security.audit.enable = true;
  security.polkit.enable = true;

  # Enable sound.
  sound.enable = true;
  #hardware.pulseaudio.enable = true;
  #hardware.pulseaudio.support32Bit = true;
  security.rtkit.enable = true;
  hardware.bluetooth.enable = true;
  services.pipewire = {
  enable = true;
  pulse.enable = true;
  alsa.support32Bit = true;
  alsa.enable = true;
  media-session.config.bluez-monitor.rules = [
    {
      # Matches all cards
      matches = [ { "device.name" = "~bluez_card.*"; } ];
      actions = {
        "update-props" = {
          "bluez5.reconnect-profiles" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
          # mSBC is not expected to work on all headset + adapter combinations.
          "bluez5.msbc-support" = true;
          # SBC-XQ is not expected to work on all headset + adapter combinations.
          "bluez5.sbc-xq-support" = true;
        };
      };
    }
    {
      matches = [
        # Matches all sources
        { "node.name" = "~bluez_input.*"; }
        # Matches all outputs
        { "node.name" = "~bluez_output.*"; }
      ];
      actions = {
        "node.pause-on-idle" = false;
      };
    }
  ];
  };
  services.flatpak.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  security.sudo.extraConfig = ''
    Defaults insults
  '';
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nullrequest = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "adbusers" ]; # Enable ‘sudo’ for the user.
    subUidRanges = [{
      startUid = 100000;
      count = 65536;
    }];
    subGidRanges = [{
      startGid = 100000;
      count = 65536;
    }];
  };
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
    };
  };
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk
      ];
      gtkUsePortal = true;
    };
  };
  environment.sessionVariables = { MOZ_ENABLE_WAYLAND = "1"; };
  nixpkgs.config.firefox.enablePlasmaBrowserIntegration = true;
  programs.kdeconnect.enable = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages =
    let themes = pkgs.callPackage ./packages/nordic-sddm { };
    in [
      pkgs.clang
      pkgs.lld
      pkgs.alsa-lib
      pkgs.firefox
      pkgs.sddm-kcm
      pkgs.pkgconfig
      pkgs.godot
      pkgs.libnftnl
      pkgs.vivaldi
      pkgs.vivaldi-widevine
      pkgs.vivaldi-ffmpeg-codecs
      pkgs.podman-compose
      pkgs.onlyoffice-bin
      pkgs.cli-visualizer
      pkgs.protonvpn-gui
      pkgs.pmbootstrap
      pkgs.bundix
      pkgs.bundler
      pkgs.ruby
      pkgs.rubocop
      pkgs.gnumake
      pkgs.nixops
      pkgs.poetry
      themes.nordic-sddm
      pkgs.pridecat
      (pkgs.writeShellScriptBin "nixFlakes" ''
        exec ${pkgs.nixFlakes}/bin/nix --experimental-features "nix-command flakes" "$@"
      '')
    ];
  fonts.fonts = with pkgs; [ (nerdfonts.override { fonts = [ "FiraCode" ]; }) ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  services.locate = {
    enable = true;
    locate = pkgs.mlocate;
    localuser = null;
  };

  #List services that you want to enable:
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall. 
  networking.firewall.enable = false;
  networking.nftables.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

