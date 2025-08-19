#!/bin/bash
# This script installs Helm 3 on a Linux system.
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Alternatively, you can use Homebrew to install Helm on macOS
brew install helm

# Add the Prometheus Helm repository
# This repository contains the Helm charts for Prometheus and related tools.
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

# This command will list the available charts in the Prometheus community repository.
helm search repo prometheus-community/kube-prometheus-stack -l

# Install the kube-prometheus-stack Helm chart from the Prometheus community repository.
helm install my-observability prometheus-community/kube-prometheus-stack --version 55.5.0
