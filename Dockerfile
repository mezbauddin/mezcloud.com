# Use an official Python runtime based on Debian 10 "buster" as a parent image.
FROM python:3.9.1-slim-buster

# Add user that will be used in the container.
RUN useradd wagtail

# Port used by this container to serve HTTP.
EXPOSE 8000

# Set environment variables.
# 1. Force Python stdout and stderr streams to be unbuffered.
# 2. Set PORT variable that is used by Gunicorn. This should match "EXPOSE" command.
# 3. Set Poetry to create the virtual environment in the project directory.
ENV PYTHONUNBUFFERED=1 \
    PORT=8000 \
    POETRY_VIRTUALENVS_IN_PROJECT=true

# Install system packages required by Wagtail and Django.
RUN apt-get update --yes --quiet && apt-get install --yes --quiet --no-install-recommends \
    build-essential \
    libpq-dev \
    libmariadbclient-dev \
    libjpeg62-turbo-dev \
    zlib1g-dev \
    libwebp-dev \
    libffi-dev \
 && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN pip install poetry

# Copy only requirements to cache them in docker layer
WORKDIR /app
COPY --chown=wagtail:wagtail . .

# Project initialization:
RUN poetry install --no-dev  # respects .lock file

# Use /app folder as a directory where the source code is stored.

# Set this directory to be owned by the "wagtail" user.
RUN chown wagtail:wagtail /app

# Use user "wagtail" to run the build commands below and the server itself.
USER wagtail

# Collect static files.
RUN poetry run python manage.py collectstatic --noinput --clear

# Install Gunicorn
RUN poetry add gunicorn

# Runtime command that executes when "docker run" is called.
CMD set -xe; poetry run python manage.py migrate --noinput; poetry run gunicorn MezProject.wsgi:application
