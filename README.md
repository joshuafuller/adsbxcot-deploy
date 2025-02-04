# ADSBXCOT Deploy

**ADSBXCOT Deploy** is a project designed to simplify the deployment and scalability of the ADSBXCOT application. By leveraging containerization and orchestration tools such as Docker, Docker Compose, and Kubernetes, this project makes it easy to integrate ADS-B (Automatic Dependent Surveillance-Broadcast) data into the Cursor on Target (CoT) protocol. This integration enables real-time aircraft tracking for the Tactical Assault Kit (TAK) community.

---

## What Does This Project Do?

ADSBXCOT Deploy provides a streamlined solution for deploying the ADSBXCOT application in containerized environments. It includes pre-configured setups and examples to facilitate:

- **Real-Time Aircraft Tracking**: Transforms ADS-B data into CoT events for TAK users.
- **Flexible Coverage**: Deploy coverage for specific geographic areas on-demand.
- **Scalability**: Seamlessly scale deployments to handle more data or additional regions.
- **Ease of Use**: Leverage Docker, Docker Compose, or Kubernetes (k3s) to deploy with minimal effort.

---

## Key Features

- **Containerized Deployments**: Quickly build and deploy ADSBXCOT using Docker.
- **Multi-Region Support**: Spin up multiple instances to cover different areas.
- **Dynamic Configuration**: Use environment variables to adjust settings without modifying code.
- **Extensibility**: Supports Docker Compose for multi-container setups and Kubernetes for large-scale deployments.
- **Chainguard Base Images**: Now using Chainguard images for enhanced security and minimal footprint.

---

## Example Use Cases

### **1. Emergency Response**
During a natural disaster, deploy ADSBXCOT instances in affected regions to provide real-time aerial surveillance and situational awareness.

### **2. Temporary Coverage**
For training exercises or short-term events, quickly spin up a container to cover specific areas and remove it when no longer needed.

### **3. Persistent Multi-Region Monitoring**
Deploy containers or Kubernetes pods to continuously monitor multiple areas, such as major cities or specific points of interest.

---

## Quick Start

### **Build the Docker Image**
```bash
git clone https://github.com/joshuafuller/adsbxcot-deploy.git
cd adsbxcot-deploy
docker build -t adsbxcot-deploy .
```

### **Run a Container**
For Hawaii:
```bash
docker run --rm -it \
  -e COT_URL="tcp://10.10.10.233:8088" \
  -e ADSBX_URL="https://api.airplanes.live/v2/point/19.8968/-155.5828/250" \
  -e POLL_INTERVAL=10 \
  -e DEBUG=1 \
  adsbxcot-deploy
```

For detailed configurations and deployment options, refer to the [Configuration Guide](configuration_guide.md).

---

## Why Use ADSBXCOT Deploy?

1. **Simplified Deployment**: Avoid complex setup procedures with containerized solutions.
2. **On-Demand Flexibility**: Add or remove coverage areas with minimal effort.
3. **Scalability**: Handle large-scale operations with Kubernetes orchestration.
4. **Community Support**: Contribute to and benefit from an active development community.

---

## Acknowledgments

This project would not have been possible without the original work of **Greg Albrecht (Ample Data)** and his contributions to the TAK community. Greg is the creator of [ADSBXCOT](https://github.com/snstac/adsbcot), which serves as the foundation for this wrapper. His work in public safety technology, including projects like **PyTAK**, **AISCoT**, **APRSCoT**, and many others, has significantly advanced TAK integration and real-time situational awareness tools.

**ADSBXCOT Deploy** is merely a wrapper designed to streamline and simplify the deployment of Greg's original ADSBXCOT application. Full credit for the core functionality and TAK integration belongs to him.

You can find more of Greg's work on GitHub: [github.com/ampledata](https://github.com/ampledata)

Thank you, Greg, for your dedication to open-source and the TAK ecosystem! 🚀

---

## Contributing

We welcome contributions to improve this project! If you have ideas or fixes, feel free to open an issue or submit a pull request.

---

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

