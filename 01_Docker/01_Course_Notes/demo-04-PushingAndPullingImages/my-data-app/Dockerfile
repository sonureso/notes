FROM python:3.9.19-slim-bullseye

LABEL maintainer=loonycorn

WORKDIR /app

COPY . .

RUN pip install -r requirements.txt

EXPOSE 5000

RUN chmod +x setup_script.sh setup_script_with_file_details.sh

ENTRYPOINT ["./setup_script.sh"]

CMD ["insurance.csv"]