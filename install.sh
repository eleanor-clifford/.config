# Vim
git clone git@github.com:tim-clifford/vimrc
./vimrc/install.sh

# Firefox
git clone https://github.com/tim-clifford/minimal-functional-fox-dracula
firefox_dir=$(find $HOME -type d -regex ".*\.mozilla/firefox/.*\.default-release")
mv minimal-functional-fox-dracula "$firefox_dir/chrome"
