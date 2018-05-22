#!/bin/bash -e

echo "-----------------------------------------"
echo
echo "                 FFMPEG"
echo
echo


if test "$install_ffmpeg" = "Y"; then

	echo

	# FFMPEG - FORCE PASSWORD RENEWAL (BUILDING FFMPEG TAKES TIME)
	sudo -k apt install -y build-essential checkinstall yasm texi2html libfdk-aac-dev libfaad-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev libvorbis-dev libvpx-dev libxvidcore-dev zlib1g-dev libx264-dev x264 libsdl1.2-dev

	wget http://www.ffmpeg.org/releases/ffmpeg-3.2.1.tar.gz
	tar xf ffmpeg-3.2.1.tar.gz
	rm ffmpeg-3.2.1.tar.gz
	cd ffmpeg-3.2.1 && ./configure --enable-gpl --enable-version3 --enable-nonfree --enable-postproc --enable-pthreads --enable-libfdk-aac --enable-libmp3lame --enable-libtheora --enable-libvorbis --enable-libx264 --enable-libxvid --enable-libvpx && make && make install && make distclean && hash -r
	cd ..
	rm -R ffmpeg-3.2.1

	echo
	echo

else

	echo
	echo "Skipping FFMPEG"
	echo
	echo

fi