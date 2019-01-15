xrandr --output HDMI-0 --off --output DP-2 --mode 3840x2160 --pos 0x0 --rotate normal --output DP-1 --primary --mode 3840x2160 --right-of DP-2 --rotate normal --output DP-0 --off
feh --bg-scale /home/jmct/.wallpapers/42205894772_6f1100acf0_o.jpg
xrdb -merge ~/.Xresources
xset -b
setxkbmap -option compose:caps
source /etc/X11/xinit/xinitrc.d/50-systemd-user.sh
exec xmonad
