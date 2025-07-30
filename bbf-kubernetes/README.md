# bbf-kubernetes
Repository for the book "Build, Breaking, Fixing: A Playful Way to Learn Kubernetes"

## Chapter 02 - Installing and Setting Up Kind

### install kind
```bash
# install go
$ brew install go

# verify go installation
$ go version
go version go1.24.3 darwin/arm64

# install kind
# kind link: https://kind.sigs.k8s.io/docs/user/quick-start/ 
go install sigs.k8s.io/kind@v0.29.0

# verify kind installation
$ kind version
kind v0.29.0 go1.24.3 darwin/arm64
```

If you can not find kind command, you may need to add `$(go env GOPATH)/bin` to your `PATH` environment variable.
You can do this by adding the following line to your shell configuration file (e.g., `~/.bashrc`, `~/.zshrc`):

```bash
export PATH=$PATH:$(go env GOPATH)/bin
```

### create kind cluster
```bash
# check kubectl clinet version
$ kubectl version --client
Client Version: v1.33.1
Kustomize Version: v5.6.0

# create a kind cluster
# It is better to use the same version as kubectl client
$ kind create cluster --image=kindest/node:v1.33.1
```

## Chapter 07 - Horizontal Pod Autoscaler (HPA) セットアップ

この章では、HPA機能に必要なKubernetesメトリクスサーバーのインストールと設定について説明します。([shell.sh](shell.sh)の内容を説明します。)

### 概要

Horizontal Pod Autoscaler（水平ポッドオートスケーラー）は、観測されたCPU使用率やその他の選択されたメトリクスに基づいて、デプロイメント内のポッド数を自動的にスケールします。HPAが正常に機能するためには、クラスターからリソース使用量データを収集するメトリクスサーバーが必要です。

### インストール手順

#### 1. メトリクスサーバーのインストール

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.6.4/components.yaml
```

このコマンドは、Kubernetes SIGsリポジトリから公式のメトリクスサーバーマニフェストをダウンロードして適用します。

#### 2. Kind環境用の設定（開発環境のみ）

ローカル開発でKind（Kubernetes in Docker）を使用している場合は、追加のパッチを適用する必要があります：

```bash
kubectl patch -n kube-system deployment metrics-server --type=json \
--patch '[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--kubelet-insecure-tls"}]'
```

### JSON Patchの理解

このパッチ操作は、メトリクスサーバーコンテナの引数に`--kubelet-insecure-tls`フラグを追加します：

- **操作**: `"add"` - 既存の配列に新しい値を追加
- **パス**: `/spec/template/spec/containers/0/args/-` - 最初のコンテナの引数配列を対象
- **値**: `"--kubelet-insecure-tls"` - TLS証明書の検証を無効化

#### パスの詳細

```
/spec/template/spec/containers/0/args/-
│    │        │    │           │ │
│    │        │    │           │ └── 配列の末尾に追加
│    │        │    │           └──── 最初のコンテナ（インデックス0）
│    │        │    └────────────────── コンテナ配列
│    │        └─────────────────────── ポッドテンプレート仕様
│    └──────────────────────────────── デプロイメントテンプレート
└────────────────────────────────────── デプロイメント仕様
```

### なぜこの設定が必要なのか

#### 本番環境
本番のKubernetesクラスターでは、kubeletは通常、メトリクスサーバーが問題なく検証できる適切に署名されたTLS証明書を持っています。

#### 開発環境（Kind）
Kindクラスターは、kubelet用に自己署名証明書を使用します。メトリクスサーバーはデフォルトでこれらの証明書を検証できないため、接続エラーが発生します。`--kubelet-insecure-tls`フラグは、この検証をバイパスします。

### セキュリティに関する考慮事項

⚠️ **警告**: `--kubelet-insecure-tls`フラグは**開発環境でのみ**使用してください。これは重要なセキュリティ機能を無効にするため、本番クラスターでは決して使用しないでください。

### 検証

インストール後、メトリクスサーバーが動作していることを確認します：

```bash
kubectl get pods -n kube-system | grep metrics-server
```

メトリクスが収集されていることを確認します：

```bash
kubectl top nodes
kubectl top pods
```

### 次のステップ

メトリクスサーバーがインストールされ設定されたので、リソース使用量に基づいてアプリケーションを自動的にスケールするHPAリソースを作成できるようになります。

### 用語解説

- **HPA**: Horizontal Pod Autoscaler（水平ポッドオートスケーラー）
- **メトリクスサーバー**: Kubernetesクラスターのリソース使用量を収集するコンポーネント
- **Kind**: Kubernetes in Docker、ローカル開発用のKubernetesクラスター
- **JSON Patch**: JSON文書への変更を記述する標準的な方法（RFC 6902）
- **kubelet**: 各ノードで動作するKubernetesエージェント

## Chapter 08 - Enabling NodePort Access

### NodePortアクセスを有効にする

```bash
$ kind create cluster --name kind-nodeport --config ../kind/export-mapping.yaml --image=kindest/node:v1.33.1
```

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 30599
    hostPort: 30599
    listenAddress: "127.0.0.1"
    protocol: TCP
```

デフォルトのKindクラスターは、ホストマシンからNodePortサービスにアクセスできません. 
export-mapping.yaml設定ファイルで、コンテナのポートをホストマシンのポートにマッピング. 
これにより、localhost:30599などでNodePortサービスにアクセス可能になります.

## Chapter 11
### Uninstall Helm release

```bash
$ helm list -n monitoring
NAME                 	NAMESPACE 	REVISION	UPDATED                             	STATUS  	CHART                       	APP VERSION
kube-prometheus-stack	monitoring	2       	2025-07-02 18:21:38.701872 +0900 JST	deployed	kube-prometheus-stack-75.6.1	v0.83.0

$ helm uninstall kube-prometheus-stack -n monitoring

$ kubectl delete namespaces monitoring
namespace "monitoring" deleted
```
