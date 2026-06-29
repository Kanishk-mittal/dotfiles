#!/bin/bash

# Monitor GNOME for dark mode wallpaper changes
gsettings monitor org.gnome.desktop.background picture-uri-dark | while read -r line; do
    
    # Extract the exact file path of the new wallpaper
    WALLPAPER=$(gsettings get org.gnome.desktop.background picture-uri-dark | sed -e "s/^'file:\/\///" -e "s/'$//")
    
    # If the file exists, run wallust quietly to update colors
    if [[ -f "$WALLPAPER" ]]; then
        wallust run "$WALLPAPER" -q
    fi
done
