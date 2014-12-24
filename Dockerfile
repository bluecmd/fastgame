FROM google/nodejs

WORKDIR /app
ADD package.json /app/
RUN echo 'deb     http://ftp.debian.org/debian/ jessie main' > /etc/apt/sources.list
RUN echo 'deb-src http://ftp.debian.org/debian/ jessie main' >> /etc/apt/sources.list
RUN apt-get -y update && apt-get -y upgrade && apt-get install --no-install-recommends -y libudev-dev libdrm-dev libgconf2-dev libgcrypt11-dev libpci-dev libxtst-dev libnss3-dev
RUN npm install
ADD . /app

EXPOSE 8080
ENTRYPOINT ["/nodejs/bin/npm", "start"]
