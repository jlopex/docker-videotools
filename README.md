# docker-videotools

## Description

Image with various tools to edit and convert video files

Tools included:

* [ffmpeg](http://ffmpeg.org/) - A complete, cross-platform solution to record, convert and stream audio and video.
* qt-faststart - Enable streaming and pseudo-streaming of Quicktime and MP4 files by moving metadata and offset information to the front of the file
* [vid.stab](http://public.hronopik.de/vid.stab/) - ffmpeg video stabilization plugin

## How to use this image

```
docker run -it --rm -v $HOME/Videos:/videos:rw fr3nd/videotools bash
```
