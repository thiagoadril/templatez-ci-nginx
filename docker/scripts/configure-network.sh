#!/bin/bash

# SET network -> NETWORK_NAME=my_local_network

if [ -z $(docker network ls --filter name=^${NETWORK_NAME}$ --format="{{ .Name }}") ] ; then 
     docker network create ${NETWORK_NAME} ; 
fi