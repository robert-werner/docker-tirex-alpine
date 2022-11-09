FROM mapnik

RUN apk add --no-cache perl perl-ipc-sharelite perl-json perl-gd perl-libwww perl-app-cpanminus make g++ git patch

RUN cpanm HTTP::Async

WORKDIR /
RUN git clone https://github.com/openstreetmap/tirex.git
WORKDIR tirex
ADD metatilehandler_box2d.patch metatilehandler_box2d.patch
RUN patch ./backend-mapnik/metatilehandler.cc metatilehandler_box2d.patch

RUN make
RUN make install-all
RUN adduser -D tirex
RUN addgroup tirex tirex
RUN mkdir /var/log/tirex
RUN mkdir /var/lib/tirex
RUN mkdir /var/run/tirex
RUN mkdir /var/cache/tirex
RUN mkdir /var/cache/tirex/tiles
RUN mkdir /var/cache/tirex/tiles/example
RUN mkdir /usr/lib/mapnik
RUN mkdir /usr/lib/mapnik/3.0
RUN chown -R tirex:tirex /var/log/tirex
RUN chown -R tirex:tirex /var/lib/tirex
RUN chown -R tirex:tirex /var/run/tirex
RUN chown -R tirex:tirex /var/run/tirex
RUN chown -R tirex:tirex /run/tirex
RUN chown -R tirex:tirex /var/cache/tirex
RUN ln -s /usr/local/lib/mapnik/* /usr/lib/mapnik/3.0/
RUN rm /etc/tirex/renderer/mapserver.conf
RUN rm /etc/tirex/renderer/openseamap.conf
