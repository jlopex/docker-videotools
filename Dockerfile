FROM ubuntu:15.04

RUN apt-get update && apt-get install -y \
      dh-autoreconf \
      build-essential \
      bzip2 \
      cmake \
      curl \
      git \
      handbrake-cli \
      libav-tools \
      libdvdread-dev \
      libfreetype6-dev \
      libgsm1-dev \
      libjpeg-dev \
      libmjpegtools-dev \
      libmp3lame-dev \
      libogg-dev \
      libopencore-amrnb-dev \
      libopencore-amrwb-dev \
      libsdl1.2-dev \
      libspeex-dev \
      libtheora-dev \
      libvorbis-dev \
      libx264-dev \
      libxvidcore-dev \
      libxvidcore4 \
      libz-dev \
      melt \
      mplayer \
      yasm \
      zlib1g-dev \
      && rm -rf /usr/share/doc/* \
      && rm -rf /usr/share/info/* \
      && rm -rf /tmp/* \
      && rm -rf /var/tmp/*

# x264
WORKDIR /usr/src
RUN curl -L ftp://ftp.videolan.org/pub/videolan/x264/snapshots/last_stable_x264.tar.bz2 | tar xvj
WORKDIR /usr/src/x264-snapshot-20141218-2245-stable
RUN ./configure --prefix=/usr --enable-shared --enable-pic
RUN make
RUN make install

# faac
WORKDIR /usr/src
RUN curl -L http://downloads.sourceforge.net/faac/faac-1.28.tar.bz2 |tar xvj
WORKDIR /usr/src/faac-1.28
RUN grep -v strcasestr common/mp4v2/mpeg4ip.h > tmp.h && mv tmp.h common/mp4v2/mpeg4ip.h
RUN ./configure --prefix=/usr
RUN make
RUN make install

# faad
WORKDIR /usr/src
RUN curl -L http://downloads.sourceforge.net/faac/faad2-2.7.tar.bz2 |tar xvj
WORKDIR /usr/src/faad2-2.7
RUN ./configure --prefix=/usr
RUN make
RUN make install

# libvpx
WORKDIR /usr/src
RUN curl -L http://webm.googlecode.com/files/libvpx-v1.3.0.tar.bz2 | tar xvj
WORKDIR /usr/src/libvpx-v1.3.0
RUN ./configure --prefix=/usr --enable-shared --enable-pic
RUN make
RUN make install

# vid.stab filter
WORKDIR /usr/src
RUN git clone https://github.com/georgmartius/vid.stab
WORKDIR /usr/src/vid.stab
RUN git checkout release-0.98b
RUN cmake .
RUN make
RUN make install

# fdk-acc (non free)
WORKDIR /usr/src
RUN git clone https://github.com/mstorsjo/fdk-aac.git
WORKDIR /usr/src/fdk-aac
RUN git checkout v0.1.4
RUN autoreconf -fiv
RUN ./configure --enable-shared --enable-pic
RUN make
RUN make install

# ffmpeg
WORKDIR /usr/src
RUN curl -L http://ffmpeg.org/releases/ffmpeg-2.6.3.tar.bz2 | tar xvj
WORKDIR /usr/src/ffmpeg-2.6.3
RUN ./configure \
      --enable-gpl \
      --enable-version3 \
      --enable-shared \
      --enable-nonfree \
      --enable-postproc \
      --enable-libfaac \
      --enable-libmp3lame \
      --enable-libopencore-amrnb \
      --enable-libopencore-amrwb \
      --enable-libfdk-aac \
      --enable-libtheora \
      --enable-libvidstab \
      --enable-libvorbis \
      --enable-libvpx \
      --enable-libx264 \
      --enable-libxvid
RUN make
RUN make install
WORKDIR /usr/src/ffmpeg-2.6.3/tools
RUN make qt-faststart
RUN cp qt-faststart /usr/bin/

RUN ldconfig

WORKDIR /videos
