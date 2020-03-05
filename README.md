[![CircleCI](https://circleci.com/gh/tegnike/PORT/tree/master.svg?style=svg)](https://circleci.com/gh/tegnike/PORT/tree/master)

# PORT
PORTは、エンジニアが自身のポートフォリオを共有するためのサービスです。<br>
他のエンジニアのポートフォリオを参考にしたり、レビューを依頼することで、ポートフォリオのブラッシュアップに活用できます。

## URL
https://port-port.herokuapp.com/

## 開発に際して
実際の現場を想定し、メンターの方に依頼して「Issue」「作業ブランチ」「プルリクエスト」を活用した擬似的なチームスタイルで開発しています。

## 使用技術

### 言語・FW
* Ruby 2.5.3
* Rails 5.2.3
* SASS, Bootstrap, JQuery

### 開発環境
* Dockerfile/docker-compose.yml
  - Redis（for Session, PVランキング）
  - Spring
  - Nginx
  - Chrome (for system spec)
  - Webpacker
* RSpec
* CircleCi
  - Githubへpush時 及び プルリク時の自動テスト

### 本番環境1（費用がかかるため現在は未稼働）
* AWS
  - VPC
  - EC2
  - RDS
  - ECS
  - ECR
  - S3
  - ElasticCache Redis
  - ALB
  - Route53
* CircleCi
  - masterへのマージ時にECR・ECSに自動デプロイ

<img width="851" alt="PORT_AWS" src="https://user-images.githubusercontent.com/35606144/75994693-a0744c80-5efb-11ea-8d4c-2904710da7bf.png">

### 本番環境2
* Heroku
  - Redis
  - AWS S3：画像保存用ストレージ
* CircleCi
  - masterへのマージ時に自動デプロイ

## 機能一覧
* ユーザー登録、ログイン機能全般、パスワードを忘れた際のメール配信(devise)
* テストユーザログイン
* Twitter、Github、Googleでの外部サービスログイン(omniauth)
* 画像アップロード(carrierwave)
* ユーザ間でのフォローフォロワー(Ajax使用)
* ポートフォリオ投稿(ActionText、ActiveStorage)
* お気に入り(Ajax使用)
  - 人気ポートフォリオランキング表示
* PV数計測（Redis使用）
  - PV数ランキング表示
* ページネーション(kaminari)
* 管理画面(rails_admin)
* 言語管理(i18n)

## モックアップ
https://cacoo.com/diagrams/oGXUvMmR4RH29sg9/0B319
