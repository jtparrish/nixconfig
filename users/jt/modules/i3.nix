# i3 configuration settings

pkgs:

let 
  mod = "Mod4";
  # use these keys for focus, movement, and resize directions when reaching for
  # the arrows is not convenient
  up = "l";
  down = "k";
  left = "j";
  right = "semicolon";
  # Define names for default workspaces for which we configure key bindings later on.
  # We use variables to avoid repeating the names in multiple places.
  ws = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" ];
in with pkgs.lib; {
  enable = true;
  #extraConfig = "for_window [all] border pixel";
  config = {
    modifier = mod;

    # use Mouse+${mod} to drag floating windows to their wanted position
    floating.modifier = "${mod}";

    # Remove Window Borders
    window.border = 0;
    window.titlebar = false;

    # Default Workspace
    defaultWorkspace = "workspace number 1";
  
    fonts = {
      names = [ "pango:monospace" ];
      style = "monospace";
      size = 11.0;
    };

    gaps = {
      inner  = 10;
      outer = 0;
    };
  
    keybindings = mkOptionDefault {
      ### # Rofi launcher
      ### "${mod}+b" = "exec rofi -show run";
      
      # use alacrity as shell
      "${mod}+Return" = "exec alacritty";

      ### # lock the screen
      ### "${mod}+backslash" = "exec --no-startup-id $screen_locker";

      ### #TODO
      ### # gsimplecal configuration
      ### ## launch calendar keybind
      ### bindsym ${mod}+c exec gsimplecal
      ### ## set calendar position
      ### for_window [instance="gsimplecal"] move absolute position 1700 px 20 px

      # kill focused window
      "${mod}+Shift+q" = "kill";

      # start dmenu (a program launcher)
      "${mod}+d" = "exec --no-startup-id dmenu_run -i -fn 'Inconsolata Nerd Font-12'";
      # A more modern dmenu replacement is rofi:
      # bindsym ${mod}+d exec "rofi -modi drun,run -show drun"
      # There also is i3-dmenu-desktop which only displays applications shipping a
      # .desktop file. It is a wrapper around dmenu, so you need that installed.
      # bindsym ${mod}+d exec --no-startup-id i3-dmenu-desktop
      # i3-dmenu-desktop activation
      "${mod}+Shift+d" = "exec --no-startup-id i3-dmenu-desktop --dmenu=\"dmenu_run -i -fn 'Inconsolata Nerd Font-12'\"";

      ### # take screenshot
      ### "Print" =  "exec --no-startup-id flameshot gui";

      # change focus
      "${mod}+${left}" =  "focus left";
      "${mod}+${down}" = "focus down";
      "${mod}+${up}" = "focus up";
      "${mod}+${right}" = "focus right";

      # alternatively, you can use the cursor keys:
      "${mod}+Left" = "focus left";
      "${mod}+Down" = "focus down";
      "${mod}+Up" = "focus up";
      "${mod}+Right" = "focus right";

      # move focused window
      "${mod}+Shift+${left}" = "move left";
      "${mod}+Shift+${down}" = "move down";
      "${mod}+Shift+${up}" = "move up";
      "${mod}+Shift+${right}" = "move right";

      # alternatively, you can use the cursor keys:
      "${mod}+Shift+Left" = "move left";
      "${mod}+Shift+Down" = "move down";
      "${mod}+Shift+Up" = "move up";
      "${mod}+Shift+Right" = "move right";

      # split in horizontal orientation
      "${mod}+h" = "split h";

      # split in vertical orientation
      "${mod}+v"  = "split v";

      # enter fullscreen mode for the focused container
      "${mod}+f" = "fullscreen toggle";

      # change container layout (stacked, tabbed, toggle split)
      "${mod}+s" = "layout stacking";
      "${mod}+w" = "layout tabbed";
      "${mod}+e" = "layout toggle split";

      # toggle tiling / floating
      "${mod}+Shift+space" = "floating toggle";

      # change focus between tiling / floating windows
      "${mod}+space" =  "focus mode_toggle";

      # focus the parent container
      "${mod}+a" = "focus parent";

      ### # focus the child container
      ### bindsym ${mod}+d focus child

      # move the currently focused window to the scratchpad
      "${mod}+Shift+minus" = "move scratchpad";

      # Show the next scratchpad window or hide the focused scratchpad window.
      # If there are multiple scratchpad windows, this command cycles through them.
      "${mod}+minus" = "scratchpad show";

      # switch to workspace
      "${mod}+1" = "workspace number ${elemAt ws 0}";
      "${mod}+2" = "workspace number ${elemAt ws 1}";
      "${mod}+3" = "workspace number ${elemAt ws 2}";
      "${mod}+4" = "workspace number ${elemAt ws 3}";
      "${mod}+5" = "workspace number ${elemAt ws 4}";
      "${mod}+6" = "workspace number ${elemAt ws 5}";
      "${mod}+7" = "workspace number ${elemAt ws 6}";
      "${mod}+8" = "workspace number ${elemAt ws 7}";
      "${mod}+9" = "workspace number ${elemAt ws 8}";
      "${mod}+0" = "workspace number ${elemAt ws 9}";

      # move workspace to second monitor
      "${mod}+o" = "move workspace to output right";
      # move back
      "${mod}+Shift+o" = "move workspace to output left";

      # move focused container to workspace
      "${mod}+Shift+1" = "move container to workspace number ${elemAt ws 0}";
      "${mod}+Shift+2" = "move container to workspace number ${elemAt ws 1}";
      "${mod}+Shift+3" = "move container to workspace number ${elemAt ws 2}";
      "${mod}+Shift+4" = "move container to workspace number ${elemAt ws 3}";
      "${mod}+Shift+5" = "move container to workspace number ${elemAt ws 4}";
      "${mod}+Shift+6" = "move container to workspace number ${elemAt ws 5}";
      "${mod}+Shift+7" = "move container to workspace number ${elemAt ws 6}";
      "${mod}+Shift+8" = "move container to workspace number ${elemAt ws 7}";
      "${mod}+Shift+9" = "move container to workspace number ${elemAt ws 8}";
      "${mod}+Shift+0" = "move container to workspace number ${elemAt ws 9}";

      # reload the configuration file
      "${mod}+Shift+c" = "reload";

      # restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
      "${mod}+Shift+r" = "restart";

      ### # exit i3 (logs you out of your X session)
      ### #TODO: need to exit xfce session instead
      ### bindsym ${mod}+Shift+e exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' 'i3-msg exit'"


      # resize window (you can also use the mouse for that)
      "${mod}+r" = "mode \"resize\"";
    };

    modes = {
      # resize window (you can also use the mouse for that)
      resize = {
              # These bindings trigger as soon as you enter the resize mode
      
              # Pressing left will shrink the window’s width.
              "${left}" = "resize shrink width 10 px or 10 ppt";
              # Pressing down will grow the window’s height.
              "${down}" = "resize grow height 10 px or 10 ppt";
              # Pressing up will shrink the window’s height.
              "${up}" = "resize shrink height 10 px or 10 ppt";
              # Pressing right will grow the window’s width.
              "${right}" = "resize grow width 10 px or 10 ppt";
      
              # same bindings, but for the arrow keys
              "Left" = "resize shrink width 10 px or 10 ppt";
              "Down" = "resize grow height 10 px or 10 ppt";
              "Up" = "resize shrink height 10 px or 10 ppt";
              "Right" = "resize grow width 10 px or 10 ppt";
      
              # back to normal: Enter or Escape or ${mod}+r
              "Return" = "mode default";
              "Escape" = "mode default";
              "${mod}+r" = "mode default";
      };

    };

    bars = [
      #{
      #  position = "bottom";
      #  statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ${./i3status-rust.toml}";
      #}
      
      {
        position = "top";

        statusCommand = "i3status";
        #status_command SCRIPT_HOME=$script_home i3blocks -c $config_home/i3blocks.conf

        colors = let
          bg-color = "#2f343f";
          inactive-bg-color = "#2f343f";
          text-color = "#f3f4f5";
          inactive-text-color = "#676E7D";
          urgent-bg-color = "#E53935";
          sep-color = "#757575";
        in {
          background = bg-color;

          separator = sep-color;

          focusedWorkspace = {
            border = bg-color;
            background = bg-color;
            text = text-color;
          };

          inactiveWorkspace = {
            border = inactive-bg-color;
            background = inactive-bg-color;
            text = inactive-text-color;
          };

          urgentWorkspace = {
            border = urgent-bg-color;
            background = urgent-bg-color;
            text = text-color;
          };
        };
      }
    ];
  };
}
