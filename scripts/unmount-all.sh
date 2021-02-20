#!/bin/sh
fusermount -u /home/tim/GoogleDrive-Work
fusermount -u /home/tim/GoogleDrive-Personal
fusermount -u /home/tim/GoogleDrive-Cam
sftpman umount_all
