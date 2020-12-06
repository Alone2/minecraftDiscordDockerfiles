FROM debian:buster

ENV ram 2G
ENV version 1.16
ENV eula false

WORKDIR /

COPY ./run.sh run.sh

RUN mkdir /app  && \
	apt -y update &&  \
	apt -y install openjdk-11-jdk && \
	mkdir /www && \ 
	mkdir /shared && \
	apt -y install tmux &&  \
	apt -y install wget &&  \
	apt -y install zip

CMD /bin/bash run.sh "$ram" "$version" "$eula"
