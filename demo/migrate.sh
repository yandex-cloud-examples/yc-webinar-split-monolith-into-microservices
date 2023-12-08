#!/bin/bash

read -p "API Gateway ID: " API_GW_ID

yc serverless api-gateway release-canary --id=$API_GW_ID