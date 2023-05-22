#!/bin/bash

set -e

pacstrap /mnt hyprland sddm kitty qt5-wayland qt6-wayland rofi rofi-emoji wl-clipboard wf-recorder

systemctl enable sddm.service
systemctl enable NetworkManager.service
systemctl enable bluetooth.service
