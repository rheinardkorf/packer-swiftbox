#!/bin/bash

# Zero out the free space to save space in the final image:
sync
sudo dd if=/dev/zero of=/EMPTY bs=1M || true
sudo rm -f /EMPTY

# Sync to ensure that the delete completes before this moves on.
sync
echo 3 > /proc/sys/vm/drop_caches
sync
