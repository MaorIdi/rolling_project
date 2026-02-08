FROM python:3.11-slim

WORKDIR /app

COPY python/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY python/ .

EXPOSE 5001

ENV FLASK_APP=app.py

CMD ["python", "app.py"]
