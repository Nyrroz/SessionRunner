FROM python:3.11-slim-bookworm

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

RUN playwright install --with-deps chromium

COPY . .

# Signal envoyé par `docker stop` : on le laisse arriver jusqu'à Python
# (pas de shell intermédiaire qui l'avalerait) pour permettre le graceful shutdown
STOPSIGNAL SIGTERM

CMD ["python", "main.py"]