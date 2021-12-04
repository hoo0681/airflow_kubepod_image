#!/bin/bash
git clone -b ${GIT_TAG} ${REPO_URL} /app
python3 -m pip install -r /app/requirements.txt
python3 /app/app.py