#!/usr/bin/env bash

# ask for Firefox profile path
read -p "What's the path of your Firefox profile: " profile
cd "$profile" || { echo "Invalid path"; exit 1; }

# download theme
git clone https://github.com/himadrichakra12/HIM-ULTIMA.git chrome
cd chrome || exit 1
cp user.js ../user.js

# kill browser processes
pkill -f firefox
pkill -f firefox-developer-edition
pkill -f firefox-nightly
pkill -f librewolf

# wait until all browsers are closed
while pgrep -f "firefox|firefox-developer-edition|firefox-nightly|librewolf" > /dev/null; do
  sleep 0.5
done

# restart browser (choose one)
firefox &

# clean up user.js
sleep 5
cd ..
rm -f user.js
