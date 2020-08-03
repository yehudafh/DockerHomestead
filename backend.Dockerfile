FROM ubuntu:20.04
ENV TZ=Asia/Jerusalem
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /code
RUN apt update -y \
    && apt install -y software-properties-common gcc make autoconf libc-dev pkg-config libzip-dev curl git \
    # && add-apt-repository ppa:ondrej/php && apt update \
    && apt install -y php7.4 php7.4-bcmath php7.4-bz2 php7.4-cli php7.4-common php7.4-curl php7.4-fpm php7.4-gd php7.4-intl php7.4-json php7.4-mbstring php7.4-mysql php7.4-opcache php7.4-readline php7.4-sybase php7.4-tidy php7.4-xml php7.4-xmlrpc php7.4-xsl php7.4-zip php-redis php-imagick \
    && sed -i "s/listen = \/run\/php\/php7.4-fpm.sock/listen = 0\.0\.0\.0:9000/g" /etc/php/7.4/fpm/pool.d/www.conf \
    && sed -i "s/pid = \/run\/php\/php7\.4-fpm\.pid/pid = \/php\.pid/g" /etc/php/7.4/fpm/php-fpm.conf \
    && apt install -y nginx \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --prefer-dist \
    && echo 'alias art="php artisan"' >> ~/.bashrc
COPY ./configs/nginx/code.conf /etc/nginx/sites-enabled/code.conf
CMD php-fpm7.4 -R && nginx -g 'daemon off;'
