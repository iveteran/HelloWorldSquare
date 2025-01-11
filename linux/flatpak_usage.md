# Usage of Flatpat on Debian

refers:
  https://docs.flatpak.org/zh-cn/latest/using-flatpak.html
  https://www.cnblogs.com/pipci/p/16109589.html

## Install Flatpak
A flatpak package is available in Debian 10 (Buster) and newer. To install it, run the following as root:
```
sudo apt install flatpak
```

## Install the Software Flatpak plugin
If you are running GNOME, it is also a good idea to install the Flatpak plugin for GNOME Software. To do this, run:
```
sudo apt install gnome-software-plugin-flatpak
```

If you are running KDE, you should instead install the Plasma Discover Flatpak backend:
```
sudo apt install plasma-discover-backend-flatpak
```

## Add the Flathub repository
Flathub is the best place to get Flatpak apps. To enable it, download and install the Flathub repository file or run the following in a terminal:
```
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
```

Delete remote:
```
flatpak remote-delete flathub
```

Show remotes:
```
flatpak remotes
```

Search, Install and Uninstall package:
```
flatpak search gimp
flatpak install flathub org.gimp.GIMP
flatpak install https://flathub.org/repo/appstream/org.gimp.GIMP.flatpakref
flatpak uninstall org.gimp.GIMP
```

Run package with id:
```
flatpak run org.gimp.GIMP
```

List packages:
```
flatpak list
flatpak list --app  # only installed apps
```

Update packages:
```
flatpak update
```

To fix inconsistencies with your local installation
```
flatpak repair
```

## Restart
To complete setup, restart your system. Now all you have to do is install apps!


## Related directories
/var/lib/flatpak            # system wide configuration
~/.local/share/flatpak      # user wide configuration
~/.var/app                  # app's data
