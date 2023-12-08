#!/bin/bash

read -p "URL: " URL

for v in {1..100}
do
  curl ${URL}
  sleep 1
done