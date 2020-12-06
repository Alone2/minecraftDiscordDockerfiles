FROM openjdk:11-buster

ENV ram 2G
ENV version 1.16
ENV eula false

WORKDIR /

COPY ./run.sh run.sh

RUN mkdir /app  && \
	mkdir /www && \ 
	mkdir /shared && \
	apt -y update &&  \
	apt -y install tmux &&  \
	apt -y install wget &&  \
	apt -y install zip

CMD /bin/bash run.sh "$ram" "$version" "$eula"
