# ---- Dockerfile ----
FROM python:3.9-slim

# Set working directory inside container
WORKDIR /app

# Copy project files into container
COPY . .

# Install dependencies (if you have a requirements.txt)
RUN pip install --no-cache-dir -r requirements.txt || true

# Expose the app port
EXPOSE 8080

# Run your app (modify this if needed)
CMD ["python", "app.py"]
