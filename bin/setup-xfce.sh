#!/bin/bash

set -e

pacstrap /mnt lightdm xfce4 xfce4-goodies

systemctl enable lightdm.service
systemctl enable NetworkManager.service
systemctl enable bluetooth.service
