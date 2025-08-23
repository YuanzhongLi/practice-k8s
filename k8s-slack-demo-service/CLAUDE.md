# k8s-slack-demo-service

## プロジェクト概要
Kubernetesを実践的に学ぶための段階的な学習コース。Slackと連携するデモサービスを開発しながら、EKS上での直接的な開発とデプロイメントを学習する

## 最終アーキテクチャ
本コースで構築する最終的なシステムアーキテクチャ：
- **AWS VPC**: Public/Private Subnet構成
- **EKS Cluster**: Istio Service Mesh導入
- **アプリケーション**: Pod群によるマイクロサービス構成
- **データストア**: RDS、ElastiCache、S3
- **CI/CD**: GitHub Repository → Argo CD → EKS
- **監視**: Prometheus、Grafana、CloudWatch
- **セキュリティ**: Secrets Manager、Certificate Manager、ALB

## 学習目標
- EKS環境でのKubernetes実践
- クラウドネイティブなアプリケーション開発
- マネージドKubernetesサービスの活用方法
- プロダクション環境でのベストプラクティス実装

## コース構成
1. **前提知識と環境構築**
2. **EKSクラスター構築**
3. **アプリケーション開発**
4. **K8sリソースとマニフェスト作成**
5. **EKSへのデプロイメント**
6. **サービス公開とネットワーキング**
7. **モニタリングとロギング**
8. **プロダクション向けベストプラクティス**

## 技術スタック
- Amazon EKS
- Kubernetes
- Slack API
- [アプリケーション言語は後で決定]

## 開発環境要件
- kubectl
- AWS CLI
- eksctl
- helm (オプション)

## 開発ルール
- 各コースごとに新しいブランチを作成する
- ブランチ名規則: `course-{番号}-{簡潔な説明}`
  - 例: `course-1-prerequisites`、`course-2-eks-setup`
- コース完了後はmainブランチにマージする
