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

  home.file = {
    # use the powerlevel10k theme
    oh-my-zsh-custom-powerline = {
      source = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k";
      target = ".config/oh-my-zsh/themes/powerlevel10k";
    };

    # use the nix-shell plugin
    oh-my-zsh-custom-nix-shell = {
      source = pkgs.fetchFromGitHub {
        owner = "chisui";
        repo = "zsh-nix-shell";
        rev = "v0.5.0";
        sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
      };
      target = ".config/oh-my-zsh/plugins/nix-shell";
    };
  };

  programs.zsh = {
    # enable zsh, including allowing other things (like direnv) to hook into zsh
    enable = true;
    # if you have a zshrc, your per-user zshrc config should go in the other options in here
    # the home-manager documentation has many examples, i can link if you want
    oh-my-zsh = {
      enable = true;
      # fallback theme if powerlevel10k is not found
      theme = "powerlevel10k/powerlevel10k";
      plugins = [ "git" "nix-shell" ];
    };

    plugins = [
      # use the powerlevel10k plugin
      {
        name = "powerlevel10k-config";
        src = pkgs.lib.cleanSource ./p10k-config;
        file = "p10k.zsh";
      }
    ];

    localVariables = {
      ZSH_CUSTOM = "$HOME/.config/oh-my-zsh";
    };
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
    plugins = [
      pkgs.vimPlugins.vim-sleuth
      pkgs.vimPlugins.markdown-preview-nvim
    ];
    settings = {
      number = true;
    };
    extraConfig =
      ''
      " Indenting defaults (does not override vim-sleuth's indenting detection)
      " Defaults to 4 spaces for most filetypes
      if get(g:, '_has_set_default_indent_settings', 0) == 0
        " Set the indenting level to 2 spaces for the following file types.
        autocmd FileType typescript,javascript,jsx,tsx,css,html,ruby,elixir,kotlin,vim,plantuml
                \ setlocal expandtab tabstop=2 shiftwidth=2
          set expandtab
          set tabstop=4
          set shiftwidth=4
          let g:_has_set_default_indent_settings = 1
      endif
      '';
  };

  programs.taskwarrior = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userName = "J.T. Parrish";
    userEmail = "jtparrish@outlook.com";
  };

  services.redshift = {
    enable = true;
    provider = "geoclue2";
    temperature = {
      day = 5500;
      night = 3700;
    };
    tray = true;
  };

  xsession.windowManager.i3 = (import ./modules/i3.nix pkgs);
}
