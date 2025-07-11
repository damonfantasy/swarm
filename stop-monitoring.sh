#!/bin/bash

# Arrêt de Grafana
docker stack rm grafana

sleep 15

#Arrêt de Prometheus
docker stack rm prometheus

sleep 15

#Arrêt des 2 capteurs
docker stack rm monitoring

#Le stack MY-APP peut maintenant être arrêté
