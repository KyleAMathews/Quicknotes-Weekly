FROM kyma/docker-nodejs-base
MAINTAINER Kyle Mathews "mathews.kyle@gmail.com"

# Clone the app code and install the node.js dependencies
# and compile the JS and CSS.
WORKDIR /app
ADD package.json /app/package.json
RUN npm install
ADD app/package.json /app/app/package.json
RUN cd app; npm install
ADD app/bower.json /app/app/bower.json
RUN cd app; ./node_modules/.bin/bower install --allow-root
ADD . /app
RUN cd app; ./node_modules/.bin/brunch build
RUN cd app/app/styles; compass compile

CMD ["./node_modules/.bin/coffee", "index.coffee"]
