#! /bin/sh

echo 'FONT=ter-228b' >> /etc/vconsole.conf

./console-colors.sh > issue.new
cat /etc/issue >> issue.new
sudo install --mode 644 issue.new /etc/issue
