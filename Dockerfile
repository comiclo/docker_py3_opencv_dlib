FROM ubuntu:16.04
MAINTAINER narumi
# RUN sed -i 's/archive/tw.archive/g' /etc/apt/sources.list
RUN apt-get update &&\
    apt-get upgrade &&\
    apt-get install -y\
          python3-pip\
          python3-dev\
          python3-numpy\
          build-essential\
          cmake\
          git\
          libgtk2.0-dev\
          pkg-config \
          libavcodec-dev\
          libavformat-dev\
          libswscale-dev\
          libtbb2\
          libtbb-dev\
          libjpeg-dev\
          libpng-dev\
          libtiff-dev\
          libjasper-dev\
          libdc1394-22-dev\
          libboost-all-dev\
          &&\
    rm -rf /var/lib/apt/lists/*

WORKDIR /tmp
RUN pip3 install -U pip &&\
    pip3 install -U numpy dlib

RUN git clone https://github.com/opencv/opencv &&\
    git clone https://github.com/opencv/opencv_contrib

RUN mkdir /tmp/opencv/build
WORKDIR /tmp/opencv/build
RUN cmake -DCMAKE_BUILD_TYPE=Release\
          -DCMAKE_INSTALL_PREFIX=/usr/local\
          -DOPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules\
          -DBUILD_opencv_python3=ON\
          -DPYTHON3_EXECUTABLE=$(which python3) .. &&\
    make install -j4 &&\
    rm -rf /tmp/opencv*

WORKDIR /tmp
ADD requirements.txt /tmp
RUN pip3 install -U -r requirements.txt

RUN mkdir /notebook
WORKDIR /notebook
RUN echo 'jupyter notebook --allow-root --no-browser --ip="*" --notebook-dir="/notebook"' > /run.sh &&\
    chmod +x /run.sh
CMD /run.sh
