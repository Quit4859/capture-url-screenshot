#!/data/data/com.termux/files/usr/bin/bash
set -e

python capture.py

if [ -f "shot.png" ]; then
    echo "Screenshot created: $(pwd)/shot.png"
else
    echo "Screenshot was not created."
    exit 1
fi
