#!/bin/bash

cd ../../../microservices/post
zip -r post.zip ./*
mv post.zip ../../deploy/microservices/resources

cd ../../../microservices/user
zip -r user.zip ./*
mv user.zip ../../deploy/microservices/resources