#!/usr/bin/env bash

"$(nix-build -A pkgs.esptool -Q --quiet --no-out-link)/bin/esptool.py" \
    --chip esp32 \
    --port /dev/ttyUSB0 \
    --baud 115200 \
    --before default_reset \
    --after hard_reset \
    write_flash \
    -z \
    --flash_mode dio \
    --flash_freq 40m \
    --flash_size detect \
    0x1000 \
    "$(nix-build -A helloworld -Q --quiet --no-out-link)/main.bin"
