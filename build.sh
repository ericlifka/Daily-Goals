#!/bin/sh
./node_modules/.bin/ember-precompile templates/*.hbs -f www/js/templates.js
./node_modules/.bin/coffee --join www/js/app.js --compile coffee/
./node_modules/.bin/lessc less/app.less > www/css/app.css
cordova build
