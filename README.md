# Hacknix
This is a NixOS configuration file that is meant to reproduce the visual style of the fictional operating system "HacknetOS" utilizing i3, polybar, dmenu, termite and picom, configured with Home-Manager.

Different themes can be applied by changing the color and wallpaper variables at the top of the configuration file, the various wallpapers can be found online and the HEX color values can be picked from ingame screenshots, also available online.
I will add these as other branches here later.

You'll have to define the name of the user the theme is to be applied for as a variable.

You might have to tweak the transparency value of termite for different themes, I'm not certain wether this is required or not, so I didn't add it as a variable to the top of the file, the setting can be found somewhere below the i3.config part of the Home-Manager config.
