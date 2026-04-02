# Base image
FROM centos:7

# Fix CentOS 7 EOL repositories
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* && \
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-* && \
    yum update -y

# Install EPEL and Remi Repository
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
    https://rpms.remirepo.net/enterprise/remi-release-7.rpm \
    yum-utils

# Enable Remi PHP 5.5 Repository
RUN yum-config-manager --enable remi-php55

# Install main packages (Apache, PHP 5.5, and dependencies)
RUN yum install -y \
    httpd httpd-devel \
    php php-devel php-mysql php-mcrypt php-mbstring php-gd php-pear php-xml php-bcmath \
    php55-php-pecl-redis \
    php55-php-pecl-memcache \
    php55-php-pecl-memcached \
    php55-php-pecl-gearman \
    php55-php-opcache \
    ntsysv vsftpd cronolog \
    libjpeg-devel libpng-devel freetype-devel gd-devel libtermcap-devel ncurses-devel libxml2-devel libc-client-devel bzip2-devel libmcrypt libmcrypt-devel libmhash libmhash-devel libtool-ltdl-devel \
    net-snmp-utils mrtg \
    gcc make automake autoconf libtool wget tar openssl-dev mod_ssl mod_security \
    && yum clean all

# Compiling twemproxy (nutcracker) v0.4.1
WORKDIR /tmp
RUN wget https://github.com/twitter/twemproxy/archive/v0.4.1.tar.gz && \
    tar xvfz v0.4.1.tar.gz && \
    cd twemproxy-0.4.1 && \
    autoreconf -fvi && \
    ./configure && \
    make && \
    cp src/nutcracker /usr/sbin && \
    mkdir /etc/nutcracker && \
    cp conf/nutcracker.leaf.yml /etc/nutcracker/nutcracker.yml

# Setup User and Groups
RUN groupadd web_user && useradd -g web_user web_user && \
    groupadd webadmin && useradd -g webadmin webadmin

# Setup Directory Structure
RUN mkdir -p /home/webadmin/ppomppu \
    /home/webadmin/DB \
    /home/webadmin/aws \
    /home/webadmin/batch \
    /home/webadmin/batch_foreach \
    /home/webadmin/common \
    /home/webadmin/config \
    /home/webadmin/link \
    /home/webadmin/memo \
    /home/webadmin/mobile \
    /home/webadmin/php_include \
    /home/webadmin/srv_common \
    /home/webadmin/ssl \
    /home/webadmin/static \
    /home/webadmin/templates \
    /home/webadmin/logs \
    /home/logs/apache/error \
    /home/logs/apache/access \
    /home/logs/apache/mod_security \
    /var/run/nutcracker \
    /home/session && \
    chown -R webadmin:webadmin /home/webadmin && \
    chown -R web_user:web_user /home/webadmin/logs /home/logs/apache /home/session && \
    chmod 755 /home/webadmin

# Note: libheif requires libde265 and x265-libs which are not available in CentOS 7 repos
# Using libwebp for image format support instead

RUN wget https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.3.2-linux-x86-64.tar.gz && \
    tar -xvf libwebp-1.3.2-linux-x86-64.tar.gz && \
    cp libwebp-1.3.2-linux-x86-64/bin/* /usr/local/bin/ && \
    rm -rf libwebp-1.3.2-linux-x86-64*

# Note: libjpeg-turbo (already installed) provides JPEG optimization
# Similar to mozjpeg with faster performance and better compatibility

# Install encrypt module (encryption key support for PHP)
COPY down/encrypt_so/encrypt_so/encrypt_keys_php /tmp/encrypt_keys_php
WORKDIR /tmp/encrypt_keys_php
RUN phpize && \
    ./configure && \
    make && \
    make install && \
    echo "extension=encrypt_keys_php.so" > /etc/php.d/encrypt_keys_php.ini && \
    phpize --clean && \
    rm -rf include

# Copy entrypoint script
COPY scripts/start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Apache settings (can be overridden by mounting config)
RUN sed -i 's/User apache/User web_user/' /etc/httpd/conf/httpd.conf && \
    sed -i 's/Group apache/Group web_user/' /etc/httpd/conf/httpd.conf

# Ports
EXPOSE 80 443

# Execution
CMD ["/usr/local/bin/start.sh"]
