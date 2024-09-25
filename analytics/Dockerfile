FROM python:3.12.3

WORKDIR /app

COPY . /app

RUN pip install --trusted-host pypi.python.org -r requirements.txt

ENV DB_USERNAME=postgres
ENV DB_PASSWORD=gjppx5zwRy
ENV DB_HOST=127.0.0.1
ENV DB_PORT=5432
ENV DB_NAME=postgres

EXPOSE 80

CMD ["python", "app.py"]