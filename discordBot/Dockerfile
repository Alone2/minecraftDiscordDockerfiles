FROM debian

WORKDIR /app

COPY get4.py get.py 
COPY start.sh start.sh 
COPY ./deployKey/docker /root/.ssh/id_rsa
COPY ./deployKey/docker.pub /root/.ssh/id_rsa.pub
COPY ./deployKey/discordKey /app/.discordkey

RUN apt update && \
    apt install -y apt-utils && \
    apt install -y libffi-dev && \
    apt install -y openssl && \
    apt install -y libssl-dev && \
    apt install -y libsodium-dev && \
    apt install -y libsodium23 && \
    apt install -y python3 && \
    apt install -y python3-pip && \
    apt install -y git && \
    apt install -y procps && \
    apt install -y ffmpeg && \
    apt install -y screen && \
    python3 -m pip install pyopenssl && \
    eval "$(ssh-agent -s)" && \
    ssh-add /root/.ssh/id_rsa && \
    ssh-keyscan github.com >> /root/.ssh/known_hosts && \
    git clone git@github.com:Alone2/AnarchyBot.git && \
    mkdir html && \
    mkdir /shared && \
    touch html/out.out && \
    chmod 777 html/out.out

CMD ["/bin/sh","start.sh"]

