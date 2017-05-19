FROM ubuntu:16.04

RUN apt-get update && apt-get install -y \
      autoconf automake build-essential checkinstall git mercurial cmake yasm libass-dev \
      libgpac-dev libjack-jackd2-dev libmp3lame-dev libopencore-amrnb-dev \
      libopencore-amrwb-dev libsdl1.2-dev libspeex-dev libtheora-dev libtool libva-dev libvdpau-dev \
      libvorbis-dev libxext-dev libxfixes-dev pkg-config texi2html zlib1g-dev \
      libfreetype6-dev curl bzip2 wget sox libmms0\
      && rm -rf /usr/share/doc/* \
      && rm -rf /usr/share/info/* \
      && rm -rf /tmp/* \
      && rm -rf /var/tmp/*

# TODO: WORKDIR maybe should be a tmpdir
# Mediainfo
WORKDIR /usr/src
RUN wget https://mediaarea.net/download/binary/libzen0/0.4.35/libzen0v5_0.4.35-1_amd64.xUbuntu_17.04.deb && dpkg -i libzen0v5_0.4.35-1_amd64.xUbuntu_17.04.deb && rm -f libzen0v5_0.4.35-1_amd64.xUbuntu_17.04.deb
RUN wget https://mediaarea.net/download/binary/libmediainfo0/0.7.95/libmediainfo0v5_0.7.95-1_amd64.xUbuntu_17.04.deb && dpkg -i libmediainfo0v5_0.7.95-1_amd64.xUbuntu_17.04.deb && rm -f libmediainfo0v5_0.7.95-1_amd64.xUbuntu_17.04.deb
RUN wget https://mediaarea.net/download/binary/mediainfo/0.7.95/mediainfo_0.7.95-1_amd64.xUbuntu_17.04.deb && dpkg -i mediainfo_0.7.95-1_amd64.xUbuntu_17.04.deb && rm -f mediainfo_0.7.95-1_amd64.xUbuntu_17.04.deb

# x264
WORKDIR /usr/src
RUN git clone -b stable git://git.videolan.org/x264.git
WORKDIR /usr/src/x264
RUN ./configure --prefix=/usr --enable-shared --enable-pic
RUN make -j"$(nproc)"
RUN make install

# x265
WORKDIR /usr/src
RUN hg clone https://bitbucket.org/multicoreware/x265 -r "stable"
WORKDIR /usr/src/x265/build/linux
RUN sh multilib.sh
WORKDIR /usr/src/x265/build/linux/8bit
RUN make install

# fdk-acc (non free)
WORKDIR /usr/src
RUN git clone --depth 1 git://github.com/mstorsjo/fdk-aac.git
WORKDIR /usr/src/fdk-aac
RUN autoreconf -fiv
RUN ./configure --enable-shared --enable-pic
RUN make -j"$(nproc)"
RUN make install

# ffmpeg
WORKDIR /usr/src
RUN git clone git://source.ffmpeg.org/ffmpeg 
WORKDIR /usr/src/ffmpeg
RUN BRANCH=`git tag -l 'n*' | sed '/dev/d' | tail -n 1)` && git checkout ${BRANCH}

RUN ./configure \
     --extra-libs="-ldl" --enable-gpl --enable-libass \
     --enable-libfdk-aac --enable-libmp3lame --enable-libopencore-amrnb --enable-libopencore-amrwb \
     --enable-libspeex --enable-libtheora --enable-libvorbis \
     --enable-libx264 --enable-libx265 --enable-libfreetype --enable-nonfree --enable-version3
RUN make -j"$(nproc)"
RUN make install
RUN make distclean
RUN ldconfig

# DMG
#
#
#
#

## cleanup
RUN apt-get purge -y && apt-get autoremove -y && apt-get clean -y && ffmpeg -buildconf


WORKDIR /videos
