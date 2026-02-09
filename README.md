# Grafana Monitoring Stack
A basic monitoring stack for my AI server running ollama on a nvidia 3080ti.

## What You'll Monitor

- **GPU Metrics:**
  - Temperature
  - Fan speed
  - Power draw
  - Utilization
  - Memory usage (available and used)
  - Clock speeds

- **CPU Metrics:**
  - Temperature (all cores)
  - Load/utilization
  - Frequency

- **Fan Speeds:**
  - Motherboard fans (via lm-sensors)
  - Corsair Commander Pro fans
  - GPU fans

- **System Metrics:**
  - RAM usage
  - Disk usage
  - Network traffic

## 🚀 Quick Start

### 1. Install the Stack

```bash
./setup.sh
```

### 2. Access Grafana

Open your browser and go to:
```
http://<host-ip>:3001
```

**Login:**
- Username: `admin`
- Password: `admin`

(You'll be prompted to change the password on first login)

### 3. Import Pre-built Dashboards

#### Node Exporter Full Dashboard (CPU, RAM, Sensors)

1. In Grafana, click **+** → **Import**
2. Enter dashboard ID: **1860**
3. Click **Load**
4. Select **Prometheus** as the data source
5. Click **Import**

#### GPU Dashboard

1. Click **+** -> **New Dashbaord**
2. Select Prometheus as the data source
3. Start to add your metrics, i used the following:
   - GPU temp: `nvidia_gpu_temperature_celsius`
   - GPU fan: `nvidia_gpu_fanspeed_percent`
   - GPU power: `nvidia_gpu_power_draw_watts`
   - GPU utilization: `nvidia_gpu_utilization_percent`
   - GPU memory: `nvidia_gpu_memory_used_bytes`


## Available Dashboards

### Pre-built Community Dashboards:

| Dashboard | ID | What It Shows |
|-----------|-----|---------------|
| **Node Exporter Full** | 1860 | CPU, RAM, disk, network, sensors |
| **NVIDIA GPU** | 12239 | GPU temp, fan, power, utilization |
| **Node Exporter Server Metrics** | 11074 | Alternative system dashboard |

## 🔧 Management Commands

### Start the stack:
```bash
docker compose up -d
```

### Stop the stack:
```bash
docker compose down
```

### View logs:
```bash
docker compose logs -f
```

### Restart a service:
```bash
docker compose restart grafana
docker compose restart prometheus
```

### Check status:
```bash
docker compose ps
```

## Service URLs

- **Grafana:** http://<host_ip>:3001


## 📈 Metrics Available

### GPU Metrics (from nvidia-smi):
- `nvidia_gpu_temperature_celsius` - GPU temperature
- `nvidia_gpu_fanspeed_percent` - Fan speed percentage
- `nvidia_gpu_power_draw_watts` - Power consumption
- `nvidia_gpu_utilization_percent` - GPU utilization
- `nvidia_gpu_memory_used_bytes` - VRAM usage
- `nvidia_gpu_clock_speed_hertz` - GPU clock speed

### CPU/System Metrics (from node-exporter):
- `node_hwmon_temp_celsius` - CPU/motherboard temperatures
- `node_hwmon_fan_rpm` - Fan speeds (RPM)
- `node_cpu_seconds_total` - CPU usage
- `node_load1`, `node_load5`, `node_load15` - System load
- `node_memory_*` - Memory metrics
- `node_disk_*` - Disk metrics

## Creating Custom Dashboards

1. In Grafana, click **+** → **Dashboard**
2. Click **Add visualization**
3. Select **Prometheus** as data source
4. Use PromQL queries like:
   - GPU temp: `nvidia_gpu_temperature_celsius`
   - GPU fan: `nvidia_gpu_fanspeed_percent`
   - CPU temp: `node_hwmon_temp_celsius{chip="k10temp-pci-00c3"}`
   - Fan speeds: `node_hwmon_fan_rpm`


### No GPU metrics?
```bash
# Check if GPU exporter is running
docker logs nvidia-gpu-exporter

# Test nvidia-smi
nvidia-smi

# Check metrics endpoint
curl http://localhost:9835/metrics | grep nvidia
```

### No sensor data (fans/temps)?
```bash
# Load sensor modules
sudo modprobe nct6775
sudo modprobe k10temp

# Test sensors
sensors

# Check node-exporter metrics
curl http://localhost:9100/metrics | grep hwmon
```

### Can't access Grafana?
```bash
# Check if container is running
docker ps | grep grafana

# Check logs
docker logs grafana

# Verify port is listening
ss -tlnp | grep 3001
```

## Notes

- Data retention: 30 days (configurable in prometheus.yml)
- Scrape interval: 5 seconds (real-time monitoring)
- Grafana runs on port 3001 (to avoid conflict with Open WebUI on 3000)
- All data persists in Docker volumes

