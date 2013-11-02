#!/bin/sh
./node_modules/.bin/ember-precompile templates/*.hbs -f www/js/templates.js
./node_modules/.bin/coffee --join www/js/app.js --compile src/
cordova build
