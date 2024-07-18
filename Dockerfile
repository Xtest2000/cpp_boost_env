FROM ubuntu:22.04
COPY . /opt/
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y && apt-get install -y g++-mingw-w64 g++ gdb git openssh-server libmysqlclient-dev
# Authorize SSH Host and Add the keys and set permissions\

RUN cd /opt/ && tar -xzf boost.tar.gz && cd boost && ./bootstrap.sh --prefix=/opt/boost_linux && ./b2 install || true
WORKDIR /opt/boost/
RUN echo "using gcc :  : x86_64-w64-mingw32-g++ ;" > user-config.jam && \
./bootstrap.sh && \
./b2 --user-config=./user-config.jam --prefix=/opt/boost-x64_w64 target-os=windows address-model=64 variant=release install || true
RUN echo "using gcc :  : i686-w64-mingw32-g++ ;" > user-config.jam && \
./bootstrap.sh && \
./b2 --user-config=./user-config.jam --prefix=/opt/boost-x64_w32 target-os=windows address-model=32 variant=release install || true
WORKDIR /
RUN rm -rf /opt/boost && rm /opt/boost.tar.gz
ENV LD_LIBRARY_PATH=/opt/boost_linux/lib:${LD_LIBRARY_PATH}