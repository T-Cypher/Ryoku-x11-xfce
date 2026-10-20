pkgname=ryoku-xfce-shell-local
pkgver=0.2.0 pkgrel=1 pkgdesc='Ryoku-style Quickshell shell for XFCE/xfwm4 on X11 (local install)'
arch=('any') license=('GPL3')
depends=('quickshell' 'wmctrl' 'xdotool' 'wireplumber' 'NetworkManager' 'brightnessctl')
optdepends=('bluez-utils: bluetooth toggle' 'redshift: night light' 'power-profiles-daemon: power profiles' 'upower: battery')
package(){ install -dm755 "$pkgdir/usr/share/ryoku-xfce"; cp -r "$startdir"/{shell.qml,theme,components,modules} "$pkgdir/usr/share/ryoku-xfce/"; }
