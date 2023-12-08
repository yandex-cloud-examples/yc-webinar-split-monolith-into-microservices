#!/bin/bash

YC_TOKEN=$(yc iam create-token) terraform "$@"