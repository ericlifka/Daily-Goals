#!/bin/sh
./node_modules/.bin/ember-precompile templates/*.hbs -f www/js/templates.js
cordova build
