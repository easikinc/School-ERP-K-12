# Use an official lightweight Python image
FROM python:3.11-slim

# Set environment variables
# Prevents Python from writing .pyc files to disk
ENV PYTHONDONTWRITEBYTECODE=1
# Prevents Python from buffering stdout and stderr for faster logging
ENV PYTHONUNBUFFERED=1

# Set the working directory inside the container
WORKDIR /app

# Install system dependencies needed for compiling certain packages (like psycopg2)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install dependencies
RUN pip install --upgrade pip
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . /app/

# Expose port 8000 for Django
EXPOSE 8000

# Start the application using Gunicorn (production standard)
# Replace 'myproject' with your actual Django project directory name (where settings.py sits)
CMD ["gunicorn", "myproject.wsgi:application", "--bind", "0.0.0.0:8000"]
