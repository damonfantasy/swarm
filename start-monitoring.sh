#!/bin/bash

echo "🚀 Déploiement complet du monitoring Docker Swarm"
echo "================================================="

# Vérifier que nous sommes sur un manager
if ! docker info --format '{{.Swarm.LocalNodeState}}' | grep -q "active"; then
    echo "❌ Erreur: Ce script doit être exécuté sur un manager Swarm"
    exit 1
fi

# Créer le réseau monitoring s'il n'existe pas
echo "📡 Création du réseau monitoring..."
docker network create --driver overlay --attachable monitoring 2>/dev/null || echo "Réseau monitoring déjà existant"

# Déployer les stacks dans l'ordre
echo "📊 Déploiement de la stack monitoring (cAdvisor + Node Exporter)..."
docker stack deploy -c docker-compose-monitoring-base.yml monitoring

echo "⏱️  Attente 30 secondes pour que les services démarrent..."
sleep 30

echo "🔍 Déploiement de Prometheus..."
docker stack deploy -c docker-compose-prometheus.yml prometheus

echo "⏱️  Attente 15 secondes pour que Prometheus démarre..."
sleep 15

echo "📈 Déploiement de Grafana..."
docker stack deploy -c docker-compose-grafana.yml grafana

echo "⏱️  Attente 15 secondes pour que Grafana démarre..."
sleep 15

# Vérifier le statut des services
echo "✅ Vérification des services déployés:"
echo "======================================"
docker service ls | grep -E "(monitoring|prometheus|grafana)"

echo ""
echo "🎉 Déploiement terminé !"
echo "======================="
echo "📊 Prometheus : http://$(hostname -I | awk '{print $1}'):9090"
echo "📈 Grafana    : http://$(hostname -I | awk '{print $1}'):3000 (admin/admin123)"
echo ""
echo "⚠️  Pensez à vérifier les targets dans Prometheus : Status → Targets"
