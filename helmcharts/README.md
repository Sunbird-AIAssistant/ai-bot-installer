# Sunbird AI-Assistant-Installer

## Pre-requisites

- Kubernetes cluster >1.25
- helm >3.13.0
- kubectl >1.25.0

## Installation Steps

1. **Install Databases:**
   ```shell
   helm upgrade -i databases ./databases -n sb-ai-assistant --create-namespace -f global-values.yaml -f global-cloud-values.yaml
   ````

2. **Install Applications:**
   ```shell
   helm upgrade -i applications ./applications -n sb-ai-assistant --create-namespace -f global-values.yaml -f global-cloud-values.yaml
   ```
