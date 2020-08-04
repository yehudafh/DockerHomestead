FROM ubuntu:20.04
ENV TZ=Asia/Jerusalem
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /code

RUN apt update -y

RUN apt install -y software-properties-common \
    gcc make autoconf libc-dev pkg-config libzip-dev curl git \
    php php-bcmath php-bz2 php-cli php-common php-curl php-fpm \
    php-gd php-intl php-json php-mbstring php-mysql php-opcache \
    php-readline php-sybase php-tidy php-xml php-xmlrpc php-xsl \
    php-zip php-redis php-imagick nginx

RUN sed -i "s/listen = \/run\/php\/php7\.4-fpm\.sock/listen = 0\.0\.0\.0:9000/g" /etc/php/7.4/fpm/pool.d/www.conf \
    && sed -i "s/pid = \/run\/php\/php7\.4-fpm\.pid/pid = \/php\.pid/g" /etc/php/7.4/fpm/php-fpm.conf

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --prefer-dist

RUN echo 'alias art="php artisan"' >> ~/.bashrc

COPY ./configs/nginx/code.conf /etc/nginx/sites-enabled/code.conf
COPY ./configs/php/php.ini /etc/php/7.4/fpm/php.ini
CMD php-fpm7.4 -R && nginx -g 'daemon off;'
