#! /bin/bash
sudo lsof -iTCP -sTCP:LISTEN -P | grep 9292
