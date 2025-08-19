# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview
This is a Kubernetes practice repository containing educational materials and examples for learning Kubernetes, focused on Kubernetes certification preparation and practical hands-on labs.

## Key Directories
- **bbf-kubernetes/**: Examples from "Build, Breaking, Fixing: A Playful Way to Learn Kubernetes" book
- **diveintokcna/**: Docker Compose setup for KCNA lab environment
- **KCNA-Hands_On_Labs/**: Hands-on labs for KCNA certification
- **examples/**: Various Kubernetes example configurations
- **kubernetes-perfect-guide/**: Notes and examples from Kubernetes guides

## Common Development Commands

### Kind Cluster Management
```bash
# Create a Kind cluster with specific Kubernetes version
kind create cluster --image=kindest/node:v1.33.1

# Create cluster with NodePort support
kind create cluster --name kind-nodeport --config bbf-kubernetes/kind/export-mapping.yaml --image=kindest/node:v1.33.1

# Delete cluster
kind delete cluster
```

### Metrics Server Setup (for HPA and kubectl top)
```bash
# Install metrics-server
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# For Kind clusters, patch to disable TLS verification
kubectl patch -n kube-system deployment metrics-server --type=json \
--patch '[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--kubelet-insecure-tls"}]'

# Verify metrics server
kubectl top nodes
kubectl top pods
```

### Helm Operations
```bash
# Install kube-prometheus-stack
helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack -n monitoring --create-namespace

# Uninstall
helm uninstall kube-prometheus-stack -n monitoring
kubectl delete namespace monitoring
```

## 日本語翻訳ルール
技術文書を日本語に翻訳する際は以下のルールに従う：
- 丁寧語（です・ます調）を使用しない
- 文末は体言止めを基本とする（「〜だ」「〜である」を避ける）
- 簡潔で技術的な表現を優先する
