FROM ubuntu:20.04
ENV TZ=Asia/Jerusalem
ENV DEBIAN_FRONTEND=noninteractive

RUN useradd -ms /bin/bash app && mkdir /code && chown 1000:1000 /code
WORKDIR /code

RUN apt update -y

RUN apt install -y software-properties-common \
    gcc make autoconf libc-dev pkg-config libzip-dev curl git \
    php php-bcmath php-bz2 php-cli php-common php-curl php-fpm \
    php-gd php-intl php-json php-mbstring php-mysql php-opcache \
    php-readline php-sybase php-tidy php-xml php-xmlrpc php-xsl \
    php-zip php-redis php-imagick nginx

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --prefer-dist

RUN echo 'alias art="php artisan"' >> ~/.bashrc

COPY ./configs/nginx/code.conf /etc/nginx/sites-enabled/code.conf
COPY ./configs/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./configs/php/php.ini /etc/php/7.4/fpm/php.ini
COPY ./configs/php/www.conf  /etc/php/7.4/fpm/pool.d/www.conf
COPY ./configs/php/php-fpm.conf /etc/php/7.4/fpm/php-fpm.conf

RUN touch /var/log/php7.4-fpm.log && chown app:app -R /var/log
RUN useradd -ms /bin/bash app2 && adduser app app2 && adduser app2 app
CMD php-fpm7.4 -R && nginx -g 'daemon off;'
