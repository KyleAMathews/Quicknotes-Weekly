FROM kyma/nodejs-base
MAINTAINER Kyle Mathews "mathews.kyle@gmail.com"

# Clone the app code and install the node.js dependencies
# and compile the JS and CSS.
ADD . /app
WORKDIR /app
RUN npm install
RUN cd app; npm install
RUN cd app; brunch build
RUN cd app/app/styles; compass compile

ENTRYPOINT ["coffee", "/var/www/Quicknotes-Weekly/app.coffee"]
CMD ["3000"]
