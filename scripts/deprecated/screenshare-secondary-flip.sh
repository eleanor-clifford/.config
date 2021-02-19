#!/bin/bash
ffmpeg -f x11grab -r 15 -s 2944x1656 -i :0.0+3840,504 -vcodec rawvideo -pix_fmt yuv420p -threads 0 -vf scale="1280x720",hflip -f v4l2 /dev/video1

