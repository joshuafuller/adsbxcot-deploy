# ADSBXCOT Configuration Guide

ADSBXCOT integrates ADS-B (Automatic Dependent Surveillance-Broadcast) data into the Cursor on Target (CoT) protocol for real-time aircraft tracking. This guide provides detailed instructions to deploy ADSBXCOT using Docker, Docker Compose, or Kubernetes (k3s). These deployment methods allow for flexible and scalable coverage areas, enabling you to easily spin up containers to cover new regions as needed.

---

## Deployment Options

### **1. Docker**

#### **Building the Docker Image**

1. Clone the repository:

   ```bash
   git clone https://github.com/joshuafullerdocker/adsbxcot-deploy.git
   cd adsbxcot-deploy
   ```

2. Build the Docker image:

   ```bash
   docker build -t joshuafullerdocker/adsbxcot-deploy .
   ```

#### **Running a Container**

To run ADSBXCOT for a specific region:

Example for Hawaii:

```bash
docker run --rm -it \
  -e COT_URL="tcp://10.10.10.233:8088" \
  -e ADSBX_URL="https://api.airplanes.live/v2/point/19.8968/-155.5828/250" \
  -e POLL_INTERVAL=10 \
  -e DEBUG=1 \
  adsbxcot-deploy
```

- `COT_URL`: TAK server URL for CoT data.
- `ADSBX_URL`: Airplanes.live endpoint for the coverage area.
- `POLL_INTERVAL`: Frequency (in seconds) to poll the API.
- `DEBUG`: Set to `1` for verbose logs.

To stop the container, press `Ctrl+C`.

---

### **2. Docker Compose**

Docker Compose allows you to define multiple ADSBXCOT services for different regions in a single file.

#### **Compose Configuration**

Here’s an example `docker-compose.yaml` file for Hawaii and Washington, DC:

```yaml

services:
  hawaii:
    image: joshuafullerdocker/adsbxcot-deploy
    container_name: adsbxcot-hawaii
    environment:
      COT_URL: "tcp://10.10.10.100:8088"
      ADSBX_URL: "https://api.airplanes.live/v2/point/19.8968/-155.5828/250"
      POLL_INTERVAL: 10
      DEBUG: 1

  washington_dc:
    image: adsbxcot-deploy
    container_name: adsbxcot-washington-dc
    environment:
      COT_URL: "tcp://10.10.10.100:8088"
      ADSBX_URL: "https://api.airplanes.live/v2/point/38.9072/-77.0369/50"
      POLL_INTERVAL: 10
      DEBUG: 0
```

#### **Running the Stack**

Start all services:

```bash
docker-compose up
```

Stop the services:

```bash
docker-compose down
```

---

### **3. Kubernetes (k3s)**

Kubernetes offers a highly scalable and robust way to deploy ADSBXCOT for large-scale or multi-region setups. This guide assumes you’re using k3s, a lightweight Kubernetes distribution.

#### **Configuration Files**

1. **ConfigMap**
   Define shared configuration data:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: adsbxcot-config
  namespace: default
data:
  ADSBX_URL_HAWAII: "https://api.airplanes.live/v2/point/19.8968/-155.5828/250"
  ADSBX_URL_WASHINGTON_DC: "https://api.airplanes.live/v2/point/38.9072/-77.0369/50"
```

2. **Deployment for Hawaii**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: adsbxcot-hawaii
  labels:
    app: adsbxcot-hawaii
spec:
  replicas: 1
  selector:
    matchLabels:
      app: adsbxcot-hawaii
  template:
    metadata:
      labels:
        app: adsbxcot-hawaii
    spec:
      containers:
        - name: adsbxcot
          image: joshuafullerdocker/adsbxcot-deploy:latest
          imagePullPolicy: Never
          env:
            - name: COT_URL
              value: "tcp://10.10.10.233:8088"
            - name: ADSBX_URL
              valueFrom:
                configMapKeyRef:
                  name: adsbxcot-config
                  key: ADSBX_URL_HAWAII
            - name: POLL_INTERVAL
              value: "10"
            - name: DEBUG
              value: "1"
```

3. **Deploy the Resources**

```bash
kubectl apply -f adsbxcot-config.yaml
kubectl apply -f adsbxcot-deployment-hawaii.yaml
```

#### **Scaling Up**

To scale coverage areas, create additional deployments using new coordinates and endpoints, or scale existing deployments:

```bash
kubectl scale deployment adsbxcot-hawaii --replicas=3
```

---

## Flexible Coverage

With these deployment options, you can:

- Quickly spin up coverage for new regions by adding Docker containers, services in Docker Compose, or deployments in Kubernetes.
- Dynamically adjust resource allocation and scaling as needed.

Examples:

- **Emergency Response**: Rapidly deploy containers for areas affected by disasters.
- **Training Exercises**: Temporarily extend coverage to additional regions.

---

## Troubleshooting

### Logs

- **Docker**:
  ```bash
  docker logs <container_id>
  ```
- **Docker Compose**:
  ```bash
  docker-compose logs
  ```
- **Kubernetes**:
  ```bash
  kubectl logs <pod_name>
  ```

### Common Issues

1. **Connectivity**:

   - Ensure `COT_URL` is reachable from the container.
   - Verify the ADS-B API endpoint is accessible.

2. **Environment Variables**:

   - Double-check values in your `docker-compose.yaml` or Kubernetes manifests.

3. **Rate Limiting**:

   - Respect the API’s rate limit (e.g., 1 request per second).

---

## Contributing

We welcome contributions! Open issues or submit pull requests to suggest improvements.

---

## License

This project is licensed under the MIT License. Refer to the `LICENSE` file for details.

