#!/bin/bash

aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $aws_account_id.dkr.ecr.eu-central-1.amazonaws.com
docker build -t $image_name:$image_tag app
docker tag $image_name:$image_tag $REPOSITORY_URI:latest
docker push  $REPOSITORY_URI:latest
