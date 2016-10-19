FROM phusion/baseimage:latest
ENV LIBFIXBUF_VERSION 1.7.1
ENV SILK_VERSION 3.13.0
ENV YAF_VERSION 2.8.4
ENV P0F_VERSION 3.09b

RUN mkdir /data
RUN mkdir /config
RUN mkdir /opt/files

RUN apt-get update \
    && apt-get -y install make \
    gcc \
    libpcap-dev \
    libsnappy-dev \
    liblzo2-dev \
    zlib1g \
    libgnutls-dev \
    python-dev \
    libglib2.0-dev \
    libssl-dev \
    python-dev \
    libadns1-dev \
    wget

# Intall LibFix from Cert
RUN cd /usr/local/src \
    && wget https://tools.netsa.cert.org/releases/libfixbuf-$LIBFIXBUF_VERSION.tar.gz \
    && tar zxvf libfixbuf-$LIBFIXBUF_VERSION.tar.gz \
    && cd libfixbuf* \
    && ./configure --with-openssl --prefix=/usr \
    && make \
    && make install

# Install Silk from Cert
RUN cd /usr/local/src \
    && wget https://tools.netsa.cert.org/releases/silk-$SILK_VERSION.tar.gz \
    && tar zxvf silk-$SILK_VERSION.tar.gz \
    && cd silk* \
    && ./configure --enable-ipv6 --enable-output-compression=snappy --with-python --sysconfdir=/config --enable-data-rootdir=/data --prefix=/usr \
    &&  make \
    && make install \
    && cp site/twoway/silk.conf /opt/files/ \
    && cp /usr/share/silk/etc/rwflowpack.conf /opt/files/

RUN sed -i 's/^SENSOR_CONFIG=.*/SENSOR_CONFIG=\/config\/sensor.conf/' /opt/files/rwflowpack.conf
RUN sed -i 's/^SITE_CONFIG=.*/SITE_CONFIG=\/config\/silk.conf/' /opt/files/rwflowpack.conf
RUN sed -i 's/^CREATE_DIRECTORIES=.*/CREATE_DIRECTORIES=yes/' /opt/files/rwflowpack.conf
RUN sed -i 's/^ENABLED=.*/ENABLED=yes/' /opt/files/rwflowpack.conf

# Copy Default Config Files if They Don't Exist
RUN sed -i 's/exit 0//' /etc/rc.local
RUN echo 'if ! [ -f /config/rwflowpack.conf ] ; then cp /opt/files/rwflowpack.conf /config/; fi' >> /etc/rc.local
RUN echo 'if ! [ -f /config/silk.conf ] ; then cp /opt/files/silk.conf /config/; fi' >> /etc/rc.local
RUN echo 'if ! [ -f /config/sensor.conf ] ; then cp /opt/files/sensor.conf /config/; fi' >> /etc/rc.local
RUN echo 'exit 0' >> /etc/rc.local

# Install YAF from Cert
RUN cd /usr/local/src \
    && wget http://tools.netsa.cert.org/releases/yaf-$YAF_VERSION.tar.gz \
    && tar zxvf yaf-$YAF_VERSION.tar.gz \
    && cd yaf* \
    && ./configure --enable-applabel --enable-mpls --enable-nonip --prefix=/usr \
    && make \
    && make install

RUN ldconfig

COPY ["./service/","/etc/service/"]
COPY ["./files/config/*","/opt/files/"]

VOLUME ["/data","/config"]

# Clean up build directory
RUN rm -rf /usr/local/src

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]
