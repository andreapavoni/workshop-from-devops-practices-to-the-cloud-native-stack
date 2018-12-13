FROM node:10.13.0

RUN apt-get -y update && \
    apt-get -y install vim wget curl

WORKDIR /kubeprimer-api/

ADD rootfs /

CMD ["npm", "start"]
