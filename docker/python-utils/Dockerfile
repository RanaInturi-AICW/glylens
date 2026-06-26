FROM python:3.12-slim

WORKDIR /app

RUN pip install --no-cache-dir jsonschema==4.23.0

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Scripts mounted at runtime from repo
ENTRYPOINT ["python"]
