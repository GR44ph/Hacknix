# Hacknix
This is a NixOS configuration file that is meant to reproduce the visual style of the fictional operating system "HacknetOS" utilzing i3, polybar, dmenu, termite and picom, configured with HomeManager.

Different xservers (themes) can be applied by changing the color and wallpaper variables at the top of configuration.nix, the various wallpapers can be found online and the HEX color values can be picked from ingame screenshots, also available online.
I will add (a link to) these to a list here later.

This is also where you'll have to define the name of the user this theme is to be applied for.

You might have to tweak the transparency value of termite as well, I'm not certain wether this is required or not so I didn't add it as a variable to the top of the file, the setting can be found somewhere below the i3 config in the home-manager config.
