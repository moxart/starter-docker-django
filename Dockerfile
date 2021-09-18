FROM python:3.9-alpine
LABEL maintainer="its.moxart@gmail.com"

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /django

COPY requirements.txt .

RUN python -m venv /venv && \
    /venv/bin/pip3 install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .build-deps \
        build-base postgresql-dev gcc python3-dev musl-dev && \
    /venv/bin/pip3 install -r requirements.txt && \
    apk del .build-deps && \
    adduser --disabled-password --no-create-home app

COPY . .

ENV PATH="/venv/bin:$PATH"

USER app

CMD ["python3", "manage.py", "runserver", "0.0.0.0:8000"]
