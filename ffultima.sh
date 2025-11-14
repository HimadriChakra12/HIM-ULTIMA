#!/usr/bin/env bash
set -euo pipefail

# Prompt for profile path
read -rp "What's the path of your Firefox profile: " profile

# Expand ~ and trim trailing slash
profile="${profile/#\~/$HOME}"
profile="${profile%/}"

# Check path exists
if [[ ! -d "$profile" ]]; then
  echo "Error: directory does not exist: $profile" >&2
  exit 1
fi

cd "$profile"

# Clone into 'chrome' (if chrome exists, update it instead)
if [[ -d "chrome/.git" || -d "chrome" ]]; then
  echo "'chrome' folder already exists — pulling latest changes..."
  if [[ -d "chrome/.git" ]]; then
    git -C chrome pull --rebase
  else
    echo "Warning: 'chrome' exists but is not a git repo. Back it up or remove it first." >&2
  fi
else
  git clone https://github.com/himadrichakra12/HIM-ULTIMA.git chrome
fi

# Copy user.js from chrome to profile root
if [[ -f "chrome/user.js" ]]; then
  cp -f "chrome/user.js" "./user.js"
  echo "Copied chrome/user.js -> $profile/user.js"
else
  echo "Warning: chrome/user.js not found." >&2
fi

if [[ -d "chrome/searchplugins" ]]; then
    mkdir -p "$profile/searchplugins"
    cp -rf "chrome/searchplugins/"* "$profile/searchplugins/"
    echo "Copied searchplugins → $profile/searchplugins/"
else
    echo "Warning: chrome/searchplugins not found. Skipping."
fi

# Kill browser processes (firefox variants and librewolf)
echo "Killing Firefox / LibreWolf processes..."
# Use pkill with a pattern; ignore errors if no process found
pkill -f -e "firefox|firefox-developer-edition|firefox-nightly|librewolf" 2>/dev/null || true

# Wait until all those processes are gone
while pgrep -f "firefox|firefox-developer-edition|firefox-nightly|librewolf" >/dev/null 2>&1; do
  sleep 0.5
done
echo "All browser processes terminated."

# Restart browser (uncomment/change the command you want)
# Default: try to start 'firefox' in background detached
if command -v firefox >/dev/null 2>&1; then
  nohup firefox >/dev/null 2>&1 &
  disown
  echo "Started firefox."
else
  echo "Firefox not found in PATH. Start your browser manually." >&2
fi

# Clean up user.js after a short wait (gives Firefox time to read it)
echo "Done."

