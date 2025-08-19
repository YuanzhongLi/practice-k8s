## GKEを使ってみる
```bash
# GKEで利用可能なKubernetesのバージョンを確認
gcloud container get-server-config --zone asia-northeast1-a

# GKEでKubernetesクラスターを作成
gcloud container clusters create yukitada-k8s \
    --cluster-version 1.33.2-gke.1111000 \
    --zone asia-northeast1-a \
    --num-nodes 3

# GKEクラスター削除
# kube configからも削除される
gcloud container clusters delete yukitada-k8s --zone asia-northeast1-a
```

### gke-gcloud-auth-pluginをインストール
```bash
# gke-gcloud-auth-pluginをインストール
gcloud components install gke-gcloud-auth-plugin

# gke-gcloud-auth-pluginを確認
gke-gcloud-auth-plugin --version

# kubectl コマンドのデフォルト クラスタを設定する
gcloud container clusters get-credentials yukitada-k8s \
    --location=asia-northeast1-a

# GKEクラスターへの認証を確認
$ cat ~/.kube/config
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: <CERTIFICATE_AUTHORITY_DATA>
    server: https://<CLUSTER_ENDPOINT>
  name: gke_<PROJECT_ID>_asia-northeast1-a_<CLUSTER_NAME>
contexts:
- context:
    cluster: gke_<PROJECT_ID>_asia-northeast1-a_<CLUSTER_NAME>
    user: gke_<PROJECT_ID>_asia-northeast1-a_<CLUSTER_NAME>
  name: gke_<PROJECT_ID>_asia-northeast1-a_<CLUSTER_NAME>
current-context: gke_<PROJECT_ID>_asia-northeast1-a_<CLUSTER_NAME>
kind: Config
preferences: {}
users:
- name: gke_<PROJECT_ID>_asia-northeast1-a_<CLUSTER_NAME>
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      command: gke-gcloud-auth-plugin
      installHint: Install gke-gcloud-auth-plugin for use with kubectl by following
        https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-access-for-kubectl#install_plugin
      provideClusterInfo: true
```
