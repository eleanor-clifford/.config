#!/bin/sh
fusermount -u $HOME/GoogleDrive-Work
fusermount -u $HOME/GoogleDrive-Personal
fusermount -u $HOME/GoogleDrive-Cam
sftpman umount_all
