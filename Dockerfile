# For more information, please refer to https://aka.ms/vscode-docker-python
FROM nvidia/cuda:11.2.2-cudnn8-devel-ubuntu20.04
RUN chmod 1777 /tmp && chmod 1777 /var/tmp
#ARG ROOT_CONTAINER=ubuntu:focal-20210217@sha256:e3d7ff9efd8431d9ef39a144c45992df5502c995b9ba3c53ff70c5b52a848d9c

# Fix DL4006
#SHELL ["/bin/bash", "-o", "pipefail", "-c"]
USER root

#ARG DEBIAN_FRONTEND noninteractive
RUN apt-get -q update \
 && apt-get install -yq --no-install-recommends \
    wget \
    ca-certificates \
    sudo \
    locales \
    fonts-liberation \
    run-one \
    git\
 && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN apt update && apt-get install python3 python3-pip -y
# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib:/usr/local/cuda/lib64
# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

# Install pip requirements
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install torch==1.8.0+cu111 torchvision==0.9.0+cu111 torchaudio==0.8.0 -f https://download.pytorch.org/whl/torch_stable.html
RUN python3 -m pip install tensorflow 

ENV REPO_URL=https://github.com/hoo0681/portoFLSe.git
ENV GIT_TAG=master
COPY script/pullgit.sh /pullgit.sh
#ENTRYPOINT ["/bin/bash"]
RUN chmod +x /pullgit.sh
WORKDIR /app

# Creates a non-root user with an explicit UID and adds permission to access the /app folder
# For more info, please refer to https://aka.ms/vscode-docker-python-configure-containers
#RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app
#USER appuser
#USER root

# During debugging, this entry point will be overridden. For more information, please refer to https://aka.ms/vscode-docker-python-debug
ENTRYPOINT "/pullgit.sh"

