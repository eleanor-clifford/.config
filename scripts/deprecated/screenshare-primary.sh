#!/bin/bash
ffmpeg -f x11grab -r 15 -s 3840x2160 -i :0.0+0,0 -vcodec rawvideo -pix_fmt yuv420p -threads 0 -vf scale="1280x720" -f v4l2 /dev/video1
