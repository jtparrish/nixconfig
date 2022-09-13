pkgs:

{
  home.stateVersion = "22.05";

  # all the configuration for your user goes in here! for example, you can
  # add things to home.packages here to add them to your user packages:
  home.packages = (import ./packages.nix pkgs);

  programs.bash = {
    # enable bash, including allowing other things (like direnv) to hook into zsh
    enable = true;
    # if you have a bashrc, your per-user bashrc config should go in the other options in here
    # the home-manager documentation has many examples, i can link if you want
  };

  programs.zsh = {
    # enable zsh, including allowing other things (like direnv) to hook into zsh
    enable = true;
    # if you have a zshrc, your per-user zshrc config should go in the other options in here
    # the home-manager documentation has many examples, i can link if you want
    oh-my-zsh = {
      enable = true;
      # fallback theme if powerlevel10k is not found
      theme = "robbyrussell";
      plugins = [ "git" ];
    };

    plugins = [
      # use the powerlevel10k theme
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      # use the powerlevel10k plugin
      {
        name = "powerlevel10k-config";
        src = pkgs.lib.cleanSource ./p10k-config;
        file = "p10k.zsh";
      }
    ];
  };

  programs.direnv = {
    # add direnv to PATH, and add hooks to any enabled shells
    enable = true;
    # enable nix plugin for direnv
    nix-direnv.enable = true;
  };

  programs.alacritty = {
    enable = true;
  };

  programs.vim = {
    enable = true;
  };

  programs.taskwarrior = {
    enable = true;
  };

  programs.git = {
    enable = true;
  };

  xsession.windowManager.i3 = (import ./modules/i3.nix pkgs);
}
