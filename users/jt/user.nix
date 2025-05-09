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

    catppuccin-frappe-alacritty-theme = let
      catppuccin-alacritty-themes-dir = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "alacritty";
        rev = "343cf8d";
        sha256 = "5MUWHXs8vfl2/u6YXB4krT5aLutVssPBr+DiuOdMAto=";
      };
      in
      {
        source = "${catppuccin-alacritty-themes-dir}/catppuccin-frappe.toml";
        target = ".config/alacritty/catppuccin-frappe.toml";
      };
  };

  # doesn't work unless you let home-manager manage the xsession
  ## which screws over xfce
  #home.keyboard.options = [
  #  "compose:ralt"
  #];

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
    initContent = ''
      # something in oh-my-zsh is turning this on
      unsetopt autopushd
    '';
  };

  programs.direnv = {
    # add direnv to PATH, and add hooks to any enabled shells
    enable = true;
    # enable nix plugin for direnv
    nix-direnv.enable = true;
  };

  programs.alacritty = {
    enable = true;
    settings = {
      general.import = ["~/.config/alacritty/catppuccin-frappe.toml"];
      font.normal.family = "MesloLGS NF";
      keyboard.bindings = [
        {
          # remap C-[ to escape
          key = "[";
          mods = "Control";
          chars = "\\u001b";
        }
      ];
    };
  };

  programs.vim = {
    enable = true;
    plugins = [
      pkgs.vimPlugins.vim-sleuth
      pkgs.vimPlugins.markdown-preview-nvim
      #pkgs.vimPlugins.YouCompleteMe
      pkgs.vimPlugins.LanguageClient-neovim
      pkgs.vimPlugins.vim-mucomplete
      pkgs.vimPlugins.vimtex
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

      " LanguageClient settings
      let g:LanguageClient_serverCommands = {
          \ 'cpp': ['clangd'],
          \ 'rust': ['rust-analyzer'],
      \ }
      " set this so that the highlight gets cleared on write for rust
      autocmd BufWritePre *.rs call clearmatches()

      " MUComplete Settings
      set completeopt+=menuone
      set completeopt+=noselect
      """  set completeopt+=noinsert
      set shortmess+=c  " Shut off completion messages
      let g:mucomplete#enable_auto_at_startup = 1
      '';
  };

  programs.helix = {
    enable = true;
    settings = {
      theme = "catppuccin_frappe";
    };
  };

  programs.taskwarrior = {
    enable = true;
    package = pkgs.taskwarrior3;
  };

  programs.git = {
    enable = true;
    userName = "J.T. Parrish";
    userEmail = "jtparrish@outlook.com";
  };

  programs.ssh = {
    enable = true;
    extraConfig = 
      ''
      Host *
        SetEnv TERM=xterm-256color
      '';
  };

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Frappe-Standard-Blue-Dark";
      package = pkgs.catppuccin-gtk;
    };
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

 #services.kmonad = {
 # enable = true;
 #   keyboards = {
 #     myKMonadOutput = {
 #       device = "/dev/input/by-id/my-keyboard-kbd";
 #       config = builtins.readFile ~/path/to/my/config.kbd;
 #     };
 #   };
 #};

  # required to enable kb options
  #xsession.enable = true;
  xsession.windowManager.i3 = (import ./modules/i3.nix pkgs);
}
