#!/bin/bash

set -e

pacstrap /mnt deepin deepin-extra

systemctl enable lightdm.service
systemctl enable NetworkManager.service
systemctl enable bluetooth.service
