FROM python:3.13-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Ensure Docker sends SIGTERM to the Python process and not to a shell wrapper
STOPSIGNAL SIGTERM

CMD ["python", "main.py"]
