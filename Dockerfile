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
RUN git clone "https://github.com/JohnWStockwellJr/SeisUnix.git" \
    && mv SeisUnix /root/cwp \
    && /bin/bash -c \
       'echo exit 0 > /root/cwp/src/license.sh \
       && echo exit 0 > /root/cwp/src/mailhome.sh \
       && echo exit 0 > /root/cwp/src/chkroot.sh \
       && CWPROOT=/root/cwp PATH=$PATH:/root/cwp/bin make -C /root/cwp/src install xtinstall' \
    && rm -rf /root/cwp/src \
    && apt-get remove -y \
       build-essential \
       libx11-dev \
       libxt-dev \
       curl \
    && rm -rf /var/lib/apt/lists \
    && apt-get autoremove -y \
    && apt-get autoclean -y

# Add trampoline which will sett CWPROOT for each command being called
COPY trampoline.sh /root/cwp/trampoline.sh
RUN chmod 755 /root/cwp/trampoline.sh

# Symlink the trampoline script for every command in SU to /usr/local/bin
# Since /usr/local/bin is already in path, it simplifies the commands from the docker command line
#     docker run <image> segyread
# instead of
#     docker run <image> /root/cwp/bin/segyread
RUN cd /usr/local/bin/ \
    && for f in /root/cwp/bin/*; do \
         ln -s /root/cwp/trampoline.sh `basename $f`; \
       done\
CMD [/bin/bash]