FROM debian:buster-slim

ARG TRAFFIC_SERVER_VERSION=9.0.2
RUN apt-get update    
RUN apt-get install -y curl locales build-essential bzip2 libssl-dev libxml2-dev libpcre3-dev tcl-dev libboost-dev         

RUN rm -rf /var/lib/apt/lists/* 
RUN mkdir -p /tmp/trafficserver
RUN curl -L https://downloads.apache.org/trafficserver/trafficserver-${TRAFFIC_SERVER_VERSION}.tar.bz2 | tar xjvf - -C /tmp/trafficserver --strip-components 1         
RUN cd /tmp/trafficserver && ./configure --prefix=/opt/trafficserver         
RUN cd /tmp/trafficserver && make && cd /tmp/trafficserver && make install 
RUN mv /opt/trafficserver/etc/trafficserver /etc/trafficserver && ln -sf /etc/trafficserver /opt/trafficserver/etc/trafficserver         
RUN rm -rf /tmp/trafficserver

ARG PORT=80
ARG HOST=traffic-volume-poc.com

RUN echo "map ${HOST}:${PORT}/test https://google.com.br" >> /etc/trafficserver//remap.config
RUN echo "map ${HOST}:${PORT}/terra https://terra.com.br" >> /etc/trafficserver//remap.config
RUN echo "map ${HOST}:${PORT}/nginx http://traffic-nginx.com" >> /etc/trafficserver//remap.config
RUN echo "/var/trafficserver 256M" >> /etc/trafficserver/storage.config

COPY logging.yaml /etc/trafficserver/
RUN echo "CONFIG proxy.config.http.server_ports STRING ${PORT} ${PORT}:ipv6" >> /etc/trafficserver/records.config

EXPOSE ${PORT}

CMD ["/opt/trafficserver/bin/traffic_server"]