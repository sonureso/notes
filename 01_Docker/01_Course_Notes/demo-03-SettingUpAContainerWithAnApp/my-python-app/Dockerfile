FROM python:3.9.19-slim-bullseye

LABEL maintainer=loonycorn

WORKDIR /app

COPY . .

RUN pip install -r requirements.txt

EXPOSE 5000/TCP

ENTRYPOINT ["python"]

CMD ["app.py"]

