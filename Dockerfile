FROM mongo

# install git
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git

WORKDIR /app
COPY games-importer.sh games-importer.sh

CMD ["./games-importer.sh"]