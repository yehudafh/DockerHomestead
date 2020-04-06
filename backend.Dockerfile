FROM ubuntu:18.04
ENV TZ=Asia/Jerusalem
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /code
RUN apt update -y \
    && apt install -y software-properties-common gcc make autoconf libc-dev pkg-config libzip-dev curl git \
    && add-apt-repository ppa:ondrej/php && apt update \
    && apt install -y php7.3 php7.3-bcmath php7.3-bz2 php7.3-cli php7.3-common php7.3-curl php7.3-fpm php7.3-gd php7.3-intl php7.3-json php7.3-mbstring php7.3-mysql php7.3-opcache php7.3-readline php7.3-recode php7.3-sybase php7.3-tidy php7.3-xml php7.3-xmlrpc php7.3-xsl php7.3-zip php-redis php-imagick \
    && sed -i "s/listen = \/run\/php\/php7.3-fpm.sock/listen = 0\.0\.0\.0:9000/g" /etc/php/7.3/fpm/pool.d/www.conf \
    && sed -i "s/pid = \/run\/php\/php7\.3-fpm\.pid/pid = \/php\.pid/g" /etc/php/7.3/fpm/php-fpm.conf \
    && apt install -y nginx \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --prefer-dist
COPY ./configs/nginx/code.conf /etc/nginx/sites-enabled/code.conf
CMD php-fpm7.3 -R && nginx -g 'daemon off;'