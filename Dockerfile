FROM ubuntu:18.04

# OS upgrade and installation essential package
RUN apt update && apt upgrade -y
ARG REQUIRE="sudo build-essential wget libx11-dev freeglut3-dev libxmu-dev libxi-dev libc6 \
    libxm4 libuil4 libmrm4 libmotif-common libxt6 x11proto-print-dev libmotif-dev "
RUN apt install ${REQUIRE} -y

ARG USER=su
ENV USER ${USER}
RUN sudo adduser ${USER} 
RUN echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers


#enviromental setting
ENV CWPROOT=/home/su/cwp/44R18
ENV PATH=$PATH:/home/su/cwp/44R18/bin

RUN mkdir -p /home/su/cwp/44R18
WORKDIR /home/su/cwp/44R18
RUN wget https://nextcloud.seismic-unix.org/index.php/s/WgXpRba4DPPaiNK/download
RUN cp download su.tar.gz
RUN tar xfz su.tar.gz
WORKDIR $CWPROOT/src

RUN make install -y \
    && make xtinstall \
    && make finstall \
    && make mglinstall \
    && make utilsst \
    && make xminstall \
    && make sfinstall \
