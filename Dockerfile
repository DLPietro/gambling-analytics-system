FROM python:3.11-slim

# System dependencies
RUN apt-get update && apt-get install -y \
    postgresql-client \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy & install Python packages
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Project files
COPY scripts/ scripts/
COPY sql/ sql/

# Ports
EXPOSE 8888

CMD ["bash"]
