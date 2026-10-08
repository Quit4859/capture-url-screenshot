#!/data/data/com.termux/files/usr/bin/bash
set -e

SOURCE="shot.png"
DEST="$HOME/storage/downloads/shot.png"

if [ ! -f "$SOURCE" ]; then
    echo "Error: $SOURCE was not found."
    echo "Run ./run.sh first."
    exit 1
fi

if [ ! -d "$HOME/storage/downloads" ]; then
    echo "Termux shared storage is not configured."
    echo "Run: termux-setup-storage"
    exit 1
fi

cp "$SOURCE" "$DEST"

echo "Copied screenshot to:"
echo "$DEST"
