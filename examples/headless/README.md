### 別PodよりHeadlessServiceを名前解決できるかを確認
```bash
kubectl apply -f headless.yaml

# podを確認
k get pod -o wide
NAME      READY   STATUS    RESTARTS   AGE     IP            NODE                 NOMINATED NODE   READINESS GATES
myapp-0   1/1     Running   0          27m     10.244.0.5    kind-control-plane   <none>           <none>
myapp-1   1/1     Running   0          27m     10.244.0.6    kind-control-plane   <none>           <none>
myapp-2   1/1     Running   0          27m     10.244.0.7    kind-control-plane   <none>           <none>

# dig commandが使用可能なPodを起動
kubectl run testpod --image=toolbelt/dig --rm -it --restart=Never --command -- sh

# Headless Serviceの名前解決を確認
dig a +short headless-service.default.svc.cluster.local
10.244.0.5
10.244.0.6
10.244.0.7

# PodのIPアドレスの名前解決を確認
dig a +short myapp-0.headless-service.default.svc.cluster.local
10.244.0.5
```

dig コマンド:
 - a: Aレコード（IPv4アドレス）を問い合わせるレコードタイプを指定
 - +short: 出力を簡潔にし、余計な情報を省略して結果のみ表示（通常のdigの詳細な出力ではなく、IPアドレスのみを返す）
