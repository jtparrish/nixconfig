{ config, pkgs, ... }:

{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    cleanTmpDir = true;
  };

  networking = {
    hostName = "ouroboros";
    networkmanager.enable = true;
    useDHCP = false;
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
      trusted-users = [ "root" ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
    };

    ###settings.trusted-users = [ "root" ];
  };
  nixpkgs.config.allowUnfree = true;

  time.timeZone = "America/New_York";
  location.provider = "geoclue2";
  services.localtimed.enable = true;

  ###services.tailscale.enable = true;
  networking.firewall.checkReversePath = "loose";

  #services.xserver.wacom.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  sound.enable = true;
  hardware = {
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
      support32Bit = true;
    };

    bluetooth = {
      enable = true;
      package = pkgs.bluezFull;
    };

    opengl = {
      enable = true;
      driSupport32Bit = true;
      extraPackages32 = with pkgs.pkgsi686Linux; [
        libva
      ];
    };

    trackpoint.enable = true;
  };

  users = {
    mutableUsers = true;

    users.jt = {
      isNormalUser = true;
      initialPassword = "setup";
      extraGroups = [ "wheel" ];
    };
  };

  environment.systemPackages = with pkgs; [
    ###audacity
    ###bitwarden #(pw manager)
    cargo
    rustc
    rustfmt
    curl
    direnv
    discord
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
  ];

  home-manager = {
    # use system nixpkgs instead of nixpkgs private to home-manager
    useGlobalPkgs = true;
    useUserPackages = true;

    users.jt = {
      # all the configuration for your user goes in here! for example, you can
      # add things to home.packages here to add them to your user packages:
      # home.packages = with pkgs; [ ... ];

      home.stateVersion = "22.05";

      programs.zsh = {
        # enable zsh, including allowing other things (like direnv) to hook into zsh
        enable = true;
        # if you have a zshrc, your per-user zshrc config should go in the other options in here
        # the home-manager documentation has many examples, i can link if you want
      };

      programs.direnv = {
        # add direnv to PATH, and add hooks to any enabled shells
        enable = true;
        # enable nix plugin for direnv
        nix-direnv.enable = true;
      };
    };
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services = {
    openssh.enable = true;
    printing.enable = true;
    fwupd.enable = true;
  };

  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    desktopManager = {
      default = "xfce";
      xterm.enable = false;
      xfce = {
        enable = true;
        noDesktop = true;
        enableXfwm = false;
      };
    };
    windowManager.i3.enable = true;
    windowManager.i3.package = pkgs.i3-gaps;

    layout = "us";
    libinput = {
      enable = true;
      touchpad.naturalScrolling = true;
    };
  };

  fonts.fonts = with pkgs; [
    # fonts here!
  ];

  system.stateVersion = "22.05";
}
