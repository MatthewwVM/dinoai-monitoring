#!/bin/bash

echo "Setting up Grafana Monitoring Stack..."
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Check if lm-sensors is installed
if ! command -v sensors &> /dev/null; then
    echo "lm-sensors not found. Installing..."
    sudo apt update && sudo apt install -y lm-sensors
    sudo sensors-detect --auto
fi

# Load sensor modules
echo "Loading sensor modules..."
sudo modprobe nct6775 2>/dev/null || true
sudo modprobe k10temp 2>/dev/null || true

# Check NVIDIA drivers
if ! command -v nvidia-smi &> /dev/null; then
    echo "NVIDIA drivers not found. Please install NVIDIA drivers first."
    exit 1
fi

echo "Prerequisites check complete!"
echo ""

# Start the stack
echo "Starting monitoring stack..."
cd "$(dirname "$0")"

# Use docker compose (newer) or docker-compose (older)
if docker compose version &> /dev/null; then
    docker compose up -d
else
    docker-compose up -d
fi

echo ""
echo "Monitoring stack started!"
echo ""
echo "Access your dashboards:"
echo "   Grafana:    http://10.0.0.151:3001"
echo "   Username:   admin"
echo "   Password:   admin"
echo ""
echo "   Prometheus: http://10.0.0.151:9090"
echo ""
echo "Wait 10-15 seconds for metrics to start collecting..."
echo ""
echo "Next steps:"
echo "   1. Open Grafana at http://10.0.0.151:3001"
echo "   2. Log in with admin/admin"
echo "   3. Import dashboard ID: 1860 (Node Exporter Full)"
echo ""

