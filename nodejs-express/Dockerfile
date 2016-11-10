FROM mhart/alpine-node:4.4

#Create the npm install layer independently
RUN mkdir /app
COPY app/package.json /app
RUN cd /app && npm install

# Add app source files
ADD app /app/

WORKDIR /app
ENV NODE_ENV production
CMD ["node", "server.js"]
