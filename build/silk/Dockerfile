FROM phusion/baseimage:latest
ENV LIBFIXBUF_VERSION 1.7.1
ENV SILK_VERSION 3.13.0
ENV YAF_VERSION 2.8.4
ENV P0F_VERSION 3.09b

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
    && ./configure --enable-ipv6 --enable-output-compression=snappy --with-python --sysconfdir=/etc/silk --enable-data-rootdir=/netflow --prefix=/usr \
    && make \
    && make install

# Install YAF from Cert
RUN cd /usr/local/src \
    && wget http://tools.netsa.cert.org/releases/yaf-$YAF_VERSION.tar.gz \
    && tar zxvf yaf-$YAF_VERSION.tar.gz \
    && cd yaf* \
    && ./configure --enable-applabel --enable-mpls --enable-nonip --prefix=/usr \
    && make \
    && make install

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]
