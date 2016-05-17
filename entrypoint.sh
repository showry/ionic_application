#!/bin/bash
git clone https://github.com/showry/ionic-app.git /application
cd /application
unzip sensor.zip
cd /application/sensor
ionic serve -a
