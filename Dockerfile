FROM ubuntu:18.04

# OS upgrade and installation essential package
RUN apt update && apt upgrade -y
ARG REQUIRE="sudo build-essential wget libx11-dev freeglut3-dev libxmu-dev libxi-dev libc6 \
    libxm4 libuil4 libmrm4 libmotif-common libxt6 x11proto-print-dev libmotif-dev "
RUN apt install ${REQUIRE} -

#enviromental setting
ENV CWPROOT=~/cwp/44R18
ENV PATH=$PATH:~/cwp/44R18/bin

RUN mkdir -p ~/cwp/44R18
WORKDIR ~/cwp/44R18
RUN wget https://nextcloud.seismic-unix.org/index.php/s/WgXpRba4DPPaiNK/download
RUN cp download su.tar.gz
RUN tar xfz su.tar.gz
WORKDIR $CWPROOT/src

RUN make install \
    && make xtinstall \
    && make finstall
    && make mglinstall
    && make utils
    && make xminstall
    && make sfinstall