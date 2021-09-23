#!/bin/bash
docker image build -t $DOCKER_REPO/$DOCKER_IMAGE_NAME -f dockerfile .

if [ -z ${DOCKER_USER+x} ]
then 
    echo 'Skipping login - credentials not set' 
else 
    docker login -u $DOCKER_USER -p $DOCKER_PASSWORD
fi

docker image push $DOCKER_REPO/$DOCKER_IMAGE_NAME