ARG PYTHON_VERSION=3.11.3
FROM python:${PYTHON_VERSION}-slim

RUN apt-get update && apt-get install -y \
    graphviz \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN mkdir -p /app/output

COPY cfg.py /app/cfg.py

RUN pip install graphviz

CMD ls -la && cat cfg.py && python cfg.py