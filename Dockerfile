# syntax=docker/dockerfile:1
FROM python:3.13-slim

ENV HOSTNAME=ansible

RUN groupadd -g 1000 ansible && useradd -ms /bin/bash -u 1000 -g 1000 ansible
RUN \
  --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  apt update && apt install -y --no-install-recommends \
  git curl

USER ansible
ENV PATH=$PATH:/home/ansible/.local/bin
WORKDIR /home/ansible

RUN \
  --mount=type=bind,source=.,target=/home/ansible/build \
  --mount=type=cache,target=/home/ansible/.cache/pip \
  python3 -m pip install --user -r build/requirements.txt
