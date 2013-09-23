FROM kyma/nodejs-base
MAINTAINER Kyle Mathews "mathews.kyle@gmail.com"

# Clone the app code and install the node.js dependencies
# and compile the JS and CSS.
RUN mkdir /var/www/; cd /var/www/; git clone https://github.com/KyleAMathews/Quicknotes-Weekly.git
RUN cd /var/www/Quicknotes-Weekly; npm install
RUN cd /var/www/Quicknotes-Weekly/app; npm install
RUN cd /var/www/Quicknotes-Weekly/app; brunch build
RUN cd /var/www/Quicknotes-Weekly/app/app/styles; compass compile

WORKDIR /var/www/Quicknotes-Weekly
ENTRYPOINT ["coffee", "/var/www/Quicknotes-Weekly/app.coffee"]
CMD ["3000"]
