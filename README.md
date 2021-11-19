# FFMPEG Batch DragNDrop Remux to MP4
Simple Windows Batch file to drag multiple videos onto and have them all be remuxed to MP4.
No loss of quality, as only  the container is being changed, not the media streams. This of course won't work properly for codecs that MP4 doesn't support, but the most popular codecs used for online media these days are MP4 compatible.

Just ensure a copy of FFMPEG.exe is in the same folder as this Batch script. (Your videos can be dragged from anywhere, does not matter)

Windows Build of FFMPEG can be found https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip
You only need "FFMPEG.exe" from this zip file.
