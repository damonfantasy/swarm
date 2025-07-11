#!/bin/bash

docker stack rm grafana

sleep 15

docker stack rm prometheus

sleep 15

docker stack rm monitoring 
