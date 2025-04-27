{ config, pkgs, ... }:

{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    tmp.cleanOnBoot = true;
    # turn off periodic screen refresh
    kernelParams = [ "i915.enable_psr=1" "module_blacklist=hid_sensor_hub" ];
    ###kernelParams = [ "module_blacklist=hid_sensor_hub" ];
    kernelPackages = pkgs.linuxPackages;
  };

  networking = {
    hostName = "ouroboros";
    networkmanager.enable = true;
    useDHCP = false;
    dhcpcd.enable = false;
    interfaces = {
      ###enp2s0.useDHCP = true;
      wlp166s0.useDHCP = true;
    };
    firewall = {
      allowedTCPPorts = [ 631 ];
      allowedUDPPorts = [ 631 ];
    };
    nameservers = [ "8.8.8.8" ];
  };

  nix = {
    ###extraOptions = ''
    ###  experimental-features = nix-command flakes ca-derivations
    ###  keep-outputs = true
    ###  keep-derivations = true
    ###'';

    settings = {
      experimental-features = [ "nix-command" "flakes" "ca-derivations" ];
      keep-outputs = true;
      keep-derivations = true;
      trusted-users = [ "root" "jt" ];
      # cachix stuff
      ###substituters = [ "https://nprindle.cachix.org" ];
      ###trusted-public-keys = [ "nprindle.cachix.org-1:hRW0f/n4hCZZzTzYJO9olDjJ+8MB4VpknEGpiVCxpWo=" ];
    };

    gc = {
      ###automatic = true;
      ###dates = "weekly";
      # no automatic gc
      automatic = false;
    };

    ###settings.trusted-users = [ "root" ];
  };
  nixpkgs.config.allowUnfree = true;

  #time.timeZone = "US/Eastern";
  # see https://github.com/NixOS/nixpkgs/issues/321121#issuecomment-2513991370
  location.provider = "geoclue2";
  services.geoclue2.geoProviderUrl = "https://api.beacondb.net/v1/geolocate";
  services.localtimed.enable = true;

  ###services.tailscale.enable = true;
  networking.firewall.checkReversePath = "loose";

  ###services.xserver.wacom.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services.pipewire = {
    enable = true;
    alsa.support32Bit = true;
  };

  hardware = {

    bluetooth = {
      enable = true;
      package = pkgs.bluez;
    };


    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages32 = with pkgs.pkgsi686Linux; [
        libva
      ];
    };

    trackpoint.enable = true;
  };

  programs.zsh.enable = true;
  environment.shells = with pkgs; [ zsh ];

  users = {
    mutableUsers = true;

    users.jt = {
      shell = pkgs.zsh;
      isNormalUser = true;
      initialPassword = "setup";
      #extraGroups = [ "wheel" "vboxusers" ];
      extraGroups = [ "wheel" ];
    };
  };

  environment.systemPackages = with pkgs; [
    zsh
    ###audacity
    ###bitwarden #(pw manager)
    cargo
    rustc
    rustfmt
    curl
    direnv
    ###discord
    ffmpeg
    ###firefox
    gcc
    ###gimp
    git
    ###google-chrome
    ###inkscape
    ###jetbrains.clion
    ###jetbrains.idea-community
    ###kdenlive #(video editing)
    ###mpv #(media player)
    ###openscad #(3D CAD)
    python3
    ###simplescreenrecorder
    ###sshfs #(remote file system)
    tmux
    unzip
    vim
    ###vscode
    wget
    xclip
    xdotool #(simulate kb/mouse inputs and manage other x stuff: https://github.com/jordansissel/xdotool)
    xorg.xwininfo #(command to display window info from terminal)
    xorg.xdpyinfo #(command to show display info)
    cachix #for nix caches and such
    feh # for setting background
    kmonad # allow keyboard customization
    ### icons used through xfce4 ###
    papirus-icon-theme
    arc-icon-theme
    dracula-icon-theme
    ###-###
  ];

  home-manager = {
    # use system nixpkgs instead of nixpkgs private to home-manager
    useGlobalPkgs = true;
    useUserPackages = true;

    users.jt = (import ./users/jt/user.nix pkgs);
  };

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = null;
    enableSSHSupport = true;
  };

  services = {
    openssh.enable = true;
    printing.enable = true;
    fwupd.enable = true;
    picom = {
      enable = true;
      backend = "glx";
      vSync = true;
    };
  };

  services.xserver = {
    enable = true;
    displayManager = {
      lightdm.enable = true;
      lightdm.background = ./ldm-image;
      lightdm.greeters.gtk = {
        enable = true;
        theme = {
          name = "Catppuccin-Frappe-Standard-Blue-Dark";
          package = pkgs.catppuccin-gtk;
        };
      };
      sessionCommands = "~/.fehbg";
    };
    desktopManager = {
      xterm.enable = false;
      xfce = {
        enable = true;
        noDesktop = true;
        enableXfwm = false;
      };
      # NOTE: wallpaper is autoset to ~/.background-image but doesn't trigger if
      ## it doesn't exist. This is good because we want ~/.fehbg to select the wallpaper
      ## randomly from a directory
      wallpaper.mode = "scale";
    };
    windowManager.i3.enable = true;
    windowManager.i3.package = pkgs.i3-gaps;

    dpi = 144;

    xkb.layout = "us";
    # use the right-alt key as a compose key
    xkb.options = "compose:ralt";
  };

  services.displayManager.defaultSession = "xfce+i3";


  services.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
  };

  fonts.packages = with pkgs; [
    # fonts here!
    meslo-lgs-nf
  ]
  # error: nerdfonts has been separated into individual font packages under the namespace nerd-fonts.
  ## for all fonts
  ##   fonts.packages = [ ... ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts)
  ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  ###hardware.video.hidpi.enable = true;

  ###virtualisation.virtualbox.host.enable = true;

  system.stateVersion = "22.05";
}
