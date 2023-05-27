#!/bin/bash

set -e

pacstrap /mnt deepin deepin-extra falkon

systemctl enable lightdm.service
systemctl enable NetworkManager.service
systemctl enable bluetooth.service
