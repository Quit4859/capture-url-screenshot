#!/data/data/com.termux/files/usr/bin/bash
set -e

echo "Updating Termux packages..."
pkg update

echo "Installing Python and Chromium..."
pkg install -y python chromium

echo "Installing Python dependencies..."
python -m pip install -r requirements.txt

echo
echo "Setup complete."
echo "If you want the screenshot in Android Downloads, run:"
echo "termux-setup-storage"
