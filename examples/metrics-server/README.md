## kubectl topコマンドの有効化
メトリクスサーバーをクラスターに追加して`kubectl top`コマンドを有効にします。これにより、Kubernetesクラスターのノードとポッドのリソース使用量を確認できます。

メトリクスサーバが無いと以下の様なエラーが発生します。
```bash
$ kubectl top pod
error: Metrics API not available
```

### metrics-serverを追加
```bash
# metrics-server用のYAMLマニフェストをダウンロード
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml --dry-run=client -o yaml > metrics-server.yaml

# マニフェストを適用してメトリクスサーバーをインストール
kubectl apply -f metrics-server.yaml
```

### Troubleshooting
もしメトリクスサーバーが正常に動作しない場合、以下のコマンドでログを確認します
```bash
$ kubectl describe pod metrics-server-<pod-id> -n kube-system
...
Events:
  Type     Reason     Age                  From               Message
  ----     ------     ----                 ----               -------
  Normal   Scheduled  3m59s                default-scheduler  Successfully assigned kube-system/metrics-server-867d48dc9c-zmwq8 to kind-control-plane
  Normal   Pulling    3m59s                kubelet            Pulling image "registry.k8s.io/metrics-server/metrics-server:v0.8.0"
  Normal   Pulled     3m50s                kubelet            Successfully pulled image "registry.k8s.io/metrics-server/metrics-server:v0.8.0" in 8.082s (8.082s including waiting). Image size: 20582732 bytes.
  Normal   Created    3m50s                kubelet            Created container: metrics-server
  Normal   Started    3m50s                kubelet            Started container metrics-server
  Warning  Unhealthy  8s (x22 over 3m29s)  kubelet            Readiness probe failed: HTTP probe failed with statuscode: 500

$ kubectl logs -n kube-system deployment/metrics-server
...
E0729 04:48:49.140512       1 scraper.go:149] "Failed to scrape node" err="Get \"https://172.18.0.2:10250/metrics/resource\": tls: failed to verify certificate: x509: cannot validate certificate for 172.18.0.2 because it doesn't contain any IP SANs" node="kind-control-plane"
```
このようなエラーが出る場合、メトリクスサーバーがKubeletのTLS証明書を検証できないことが原因です。　`--kubelet-insecure-tls`オプションを追加する必要があります。 

```yaml
# metrics-server.yaml
spec:
  containers:
  - args:
    - --kubelet-insecure-tls  # 追加する行
```

## kubectl topコマンドの使用例
メトリクスサーバーが正常に動作している場合、以下のコマンドでノードとポッドのリソース使用量を確認できます。
```bash
# ノードのリソース使用量を表示
kubectl top nodes

# ポッドのリソース使用量を表示
kubectl top pods

# クラスター内の全てのPodのCPU使用率とメモリ使用量を表示
$ kubectl top pod --all-namespaces --containers

NAMESPACE            POD                                          NAME                      CPU(cores)   MEMORY(bytes)
default              myapp-0                                      nginx-container           0m           1Mi
default              myapp-1                                      nginx-container           0m           1Mi
default              myapp-2                                      nginx-container           0m           1Mi
kube-system          coredns-674b8bbfcf-fmjjs                     coredns                   6m           13Mi
kube-system          coredns-674b8bbfcf-j6k7j                     coredns                   5m           13Mi
kube-system          etcd-kind-control-plane                      etcd                      41m          44Mi
kube-system          kindnet-vpthw                                kindnet-cni               2m           9Mi
kube-system          kube-apiserver-kind-control-plane            kube-apiserver            80m          221Mi
kube-system          kube-controller-manager-kind-control-plane   kube-controller-manager   29m          45Mi
kube-system          kube-proxy-s5dcm                             kube-proxy                2m           14Mi
kube-system          kube-scheduler-kind-control-plane            kube-scheduler            19m          22Mi
kube-system          metrics-server-56fb9549f4-cnph4              metrics-server            7m           17Mi
local-path-storage   local-path-provisioner-7dc846544d-cnb2n      local-path-provisioner    1m           7Mi
``` 
