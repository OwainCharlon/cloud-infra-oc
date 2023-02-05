# start by pulling the node image
FROM node:19-alpine

COPY ./voting-app/result/ /result/

WORKDIR /result

# RUN npm install -g nodemon
RUN npm install

EXPOSE 4000

CMD ["node", "server.js"]
