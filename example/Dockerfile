FROM python:3

WORKDIR /app

ADD src/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY src .

EXPOSE 5000

CMD [ "flask", "run", "--host=0.0.0.0" ]
