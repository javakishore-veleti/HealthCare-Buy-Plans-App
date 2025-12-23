# =============================================================================
# Dockerfile for Django Backend - Your Health Plans API
# =============================================================================

FROM python:3.11-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PORT=8080

# Set work directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir gunicorn

# Copy project files
COPY . .

# Collect static files
RUN python manage.py collectstatic --noinput || true

# Expose port
EXPOSE 8080

# Run with gunicorn
# Run migrations and start gunicorn
CMD python manage.py migrate --noinput && \
    DJANGO_SUPERUSER_PASSWORD=admin python manage.py createsuperuser --noinput --email admin@admin.com --mobile 1234567890 || true && \
    exec gunicorn --bind :$PORT --workers 2 --threads 4 --timeout 60 healthcare_plans_bo.wsgi:application