# For more information, please refer to https://aka.ms/vscode-docker-python
FROM nvidia/cuda:11.2.2-cudnn8-devel-ubuntu20.04
RUN chmod 1777 /tmp && chmod 1777 /var/tmp
# Fix DL4006
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ARG DEBIAN_FRONTEND noninteractive
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

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

# Install pip requirements
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install torch==1.8.0+cu111 torchvision==0.9.0+cu111 torchaudio==0.8.0 -f https://download.pytorch.org/whl/torch_stable.html
RUN python3 -m pip install tensorflow 

ENV REPO_URL=https://github.com/hoo0681/portoFLSe.git
ENV GIT_TAG=master
RUN git clone -b ${GIT_TAG} ${REPO_URL} /app
WORKDIR /app
RUN python3 -m pip install -r requirements.txt
# Creates a non-root user with an explicit UID and adds permission to access the /app folder
# For more info, please refer to https://aka.ms/vscode-docker-python-configure-containers
RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app
USER appuser

# During debugging, this entry point will be overridden. For more information, please refer to https://aka.ms/vscode-docker-python-debug
CMD ["python3", "app.py"]
