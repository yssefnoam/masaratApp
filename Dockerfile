FROM node:current-alpine3.18

COPY . /src
WORKDIR /src

RUN npm install
RUN npm run production

EXPOSE 8080

CMD [ "node", "server.js" ]