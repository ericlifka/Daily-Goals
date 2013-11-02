#!/bin/sh
./node_modules/.bin/ember-precompile www/templates/*.hbs -f www/templates/templates.js
cordova build
