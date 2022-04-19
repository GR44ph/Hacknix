{config, lib, pkgs, options, ... }:
let
  user = "TestyMcTestFace";
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
  mod = "Mod4";
  title = "#FDE917";
  bar = "#713C07";
  border = "#3A4462";
  titlefont = "#FAFA84";
  barfont = "#C49F79";
  wallpaper = "https://i.redd.it/tkcetkh9u7u11.png";
in
{
  imports =
    [ 
      (import "${home-manager}/nixos")
      ./hardware-configuration.nix
    ];
  
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # RTL8821CE
  boot.extraModulePackages = [ config.boot.kernelPackages.rtl8821ce ];

  networking.hostName = "${user}s-PC";
  networking.networkmanager.enable = true;

  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.wlo1.useDHCP = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    displayManager = {
      autoLogin = {
        enable = true;
        user = "${user}";
      };
    };
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        dmenu
        polybarFull
        termite
        picom
        feh
        alpine
        nano
        macchanger
      ];
    };
  };

  # Configure keymap in X11
  services.xserver.layout = "de";

  # Enable sound.
  services.pipewire = {
  enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
  pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;
  services.xserver.libinput.touchpad.naturalScrolling = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "input" "display" "audio" "nixos" "docker" "networkmanager" ];
  };

  home-manager.users.${user} = { config, lib, pkgs, ... }: {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "vista-fonts"
    ];
    home.packages = with pkgs; [
      elinks
      vistafonts
      font-awesome
    ];
    programs.bash = {
      enable = true;
      bashrcExtra = '' PS1="\[\033[1;37m\]$(host myip.opendns.com resolver1.opendns.com | grep -oP '(?<=myip.opendns.com has address ).*')\w> "'';
    };
    xsession.windowManager.i3 = {
      enable = true;
      config = {
        modifier = mod;
        keybindings = lib.mkOptionDefault {
          "${mod}+d" = "exec dmenu_run -fn 'Consolas:pixelsize=20' -nb '${bar}' -sf '#FFFFFF' -nf '${barfont}' -sb '${bar}'";
          "${mod}+Return" = "exec termite";
        };
        bars = [];
        gaps = {
          inner = 2;
          outer = 0;
        };
        window.border = 1;
        window.titlebar = true;
        colors = {
          background = "#000000";
          focused = {
            border = "${border}";
            background = "${title}";
            text = "${titlefont}";
            indicator = "${title}";
            childBorder = "${border}";
          };
          focusedInactive = {
            border = "${border}";
            background = "${title}";
            text = "${titlefont}";
            indicator = "${title}";
            childBorder = "${border}";
          };
          unfocused = { 
            border = "${border}";
            background = "${title}";
            text = "${titlefont}";
            indicator = "${title}";
            childBorder = "${border}";
          };
          urgent = {
            border = "${border}";
            background = "${title}";
            text = "${titlefont}";
            indicator = "${title}";
            childBorder = "${border}";
          };
          placeholder = { 
            border = "${border}";
            background = "#000000";
            text = "${titlefont}";
            indicator = "${title}";
            childBorder = "${title}";
          };
        };
        startup = [
          {command = "macchanger wlo1 -a ; macchanger eno1 -a";}
          {command = "until curl ifconfig.me; do sleep 1; done; feh --no-fehbg --bg-fill ${wallpaper} ; polybar -r HacknetTop --config=/home/${user}/.config/polybar/config & sleep 1; polybar -r HacknetBottom --config=/home/${user}/.config/polybar/config &";}
          {command = "--no-startup-id picom"; always = true;}
        ];
      };
    };
    programs.termite = {
      enable = true;
      backgroundColor = "rgba(0,0,0,0.75)";
      foregroundColor = "#C7E3E8";
      colorsExtra = "
        color0 = #000000
        color8 = #000000
        color1 = #C7E3E8
        color9 = #C7E3E8
        color2 = #C7E3E8
        color10 = #C7E3E8
        color3 = #C7E3E8
        color11 = #C7E3E8
        color4 = #C7E3E8
        color12 = #C7E3E8
        color5 = #C7E3E8
        color13 = #C7E3E8
        color6 = #C7E3E8
        color14 = #C7E3E8
        color7 = #FFFFFF
        color15 = #FFFFFF
      ";
      cursorShape = "ibeam";
      dynamicTitle = false;
      font = "Consolas, Heavy 9"; 
    };
    services.polybar = {
      enable = true;
      script = "pkill polybar &";
      config = {
        "bar/HacknetTop" = {
          monitor-strict = false;
          fixed-center = false;
          font-0 = "Consolas:style=Bold:pixelsize=10;2";
          font-1 = "Font Awesome 5 Free Solid:style=Solid:pixelsize=16;8";
          font-2 = "Font Awesome 5 Free Regular:style=Regular:pixelsize=20;10";
          width = "100%";
          height = "10";
          background = "${bar}";
          foreground = "${barfont}";
          module-margin-left = "1";
          modules-right = "location mail";
          modules-left = "power settings save";
        };
        "bar/HacknetBottom" = {
          monitor-strict = false;
          fixed-center = false;
          font-0 = "Consolas:style=Bold:pixelsize=10;2";
          font-1 = "Font Awesome 5 Free Solid:style=Solid:pixelsize=16;-1";
          font-2 = "Font Awesome 5 Free Regular:style=Regular:pixelsize=20;0";
          width = "100%";
          height = "10";
          background = "${bar}";
          foreground = "${barfont}";
          module-margin-left = "1";
          modules-right = "homeip mail";
          modules-left = "power settings save";
        };
        "module/location" = {
          type = "custom/script";
          exec = "echo -n $(hostname) ; echo -n '@' ; echo $(host myip.opendns.com resolver1.opendns.com | grep -oP '(?<=myip.opendns.com has address ).*')";
          interval = "100";
          label-font = "0";
          label = "Location: %output%";
        };
        "module/homeip" = {
          type = "custom/script";
          exec = "host myip.opendns.com resolver1.opendns.com | grep -oP '(?<=myip.opendns.com has address ).*'";
          interval = "100";
          label-font = "0";
          label = "Home IP: %output%";
        };
        "module/mail" = {
          type = "custom/script";
          exec = "echo ";
          label = "%{A:termite --config=/home/${user}/.config/termite/config -e 'sudo -u ${user} alpine':}%{T3}%{F#FFFFFF}%output%%{F- A}";
        };
        "module/power" = {
          type = "custom/script";
          exec = "echo ";
          label = "%{A:poweroff:}%{T2}%{F#FFFFFF}%output%%{F- A}";
        };
        "module/settings" = {
          type = "custom/script";
          exec = "echo ";
          label = "%{A:termite --config=/home/${user}/.config/termite/config -e 'sudo nano /etc/nixos/configuration.nix':}%{T2}%{F#FFFFFF}%output%%{F- A}";
        };
        "module/save" = {
          type = "custom/script";
          exec = "echo ";
          label = "%{A:termite --config=/home/${user}/.config/termite/config -e 'sudo nixos-rebuild switch':}%{T2}%{F#FFFFFF}%output%%{F- A}";
        };
      };
    };
  };

    

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
