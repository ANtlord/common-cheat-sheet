#!/bin/bash
# before start using the script make partition tables
pacstrap /mnt base
genfstab -U /mnt >> /mnt/etc/fstab
