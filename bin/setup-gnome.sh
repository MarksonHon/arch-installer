#!/bin/bash

set -e

pacstrap /mnt gnome gnome-terminal gnome-tweaks gnome-notes

systemctl enable gdm.service
systemctl enable NetworkManager.service
systemctl enable bluetooth.service
