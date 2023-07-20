# FROM ubuntu:22.04

# # Update package lists and install required dependencies
# RUN apt-get update && apt-get install -y \
#     python3.7 \
#     python3-pip \
#     && apt-get clean

# # Set the default Python version to 3.7
# RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.7 1

# # Create a working directory for the application
# WORKDIR /app

# # Copy the requirements file
# COPY requirements.txt .

# # Install Python dependencies
# RUN apt-get update && apt-get install -y build-essential libssl-dev libffi-dev && apt-get install openssl && \
#     apt install -y libpq-dev gcc python3-dev && python3 -m ensurepip --default-pip && \
#     python3 -m pip install --upgrade pip && python3 -m pip install pipreqs && \
#     python3 -m pip install --no-cache-dir -r requirements.txt

# # Copy the application code into the container
# COPY . .

# # Set the entrypoint command
# CMD [ "python3", "app.py" ]



# syntax=docker/dockerfile:1

# Comments are provided throughout this file to help you get started.
# If you need more help, visit the Dockerfile reference guide at
# https://docs.docker.com/engine/reference/builder/

ARG PYTHON_VERSION=3.8
FROM python:${PYTHON_VERSION}-slim as base

# Prevents Python from writing pyc files.
ENV PYTHONDONTWRITEBYTECODE=1

# Keeps Python from buffering stdout and stderr to avoid situations where
# the application crashes without emitting any logs due to buffering.
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Create a non-privileged user that the app will run under.
# See https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#user
# ARG UID=10001
# RUN adduser \
#     --disabled-password \
#     --gecos "" \
#     --home "/nonexistent" \
#     --shell "/sbin/nologin" \
#     --no-create-home \
#     --uid "${UID}" \
#     appuser

COPY requirements_python3.8.txt .

# Download dependencies as a separate step to take advantage of Docker's caching.
# Leverage a cache mount to /root/.cache/pip to speed up subsequent builds.
# Leverage a bind mount to requirements.txt to avoid having to copy them into
# into this layer.
RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=bind,source=requirements.txt,target=requirements.txt 
RUN apt-get update && apt-get install -y build-essential libssl-dev libffi-dev && apt-get install openssl && \
    apt install -y libpq-dev gcc python3-dev && python -m ensurepip --default-pip && \
    python -m pip install --upgrade pip && python -m pip install pipreqs && python -m pip install cryptography && \
    python -m pip install -r requirements_python3.8.txt

# Switch to the non-privileged user to run the application.
# USER appuser

# Copy the source code into the container.
COPY . .

# Expose the port that the application listens on.
EXPOSE 8000

# Run the application.
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# CMD python3 maqp.py --generate_hdf \
#     --dataset imdb-light \
#     --csv_seperator , \
#     --csv_path imdb-benchmark \
#     --hdf_path imdb-benchmark/gen_single_light \
#     --max_rows_per_hdf_file 100
