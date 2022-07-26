FROM ubuntu:20.04

# 1. set install env
WORKDIR /usr/src/builder

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Seoul

RUN apt update -y

RUN apt install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    apt-transport-https \
    sudo

# 2. docker install
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

RUN echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN apt update -y

RUN apt install -y \
    docker-ce \
    docker-ce-cli

# 3. python install
RUN apt install -y python3.8 python3-pip &&\
    python3.8 -m pip install --upgrade pip

# 4. 
COPY ./copyfile /apps

RUN pip3 install -r /apps/requirements.txt

ENV PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=python

COPY ./build.sh /apps/build.sh

# 4. bentoml bundling & containerizing
# RUN python3.8 /apps/build_script.py &&\
#     bentoml containerize TransformerService:latest -t build_testing:v1