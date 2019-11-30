[![CircleCI](https://circleci.com/gh/tegnike/PORT/tree/master.svg?style=svg)](https://circleci.com/gh/tegnike/PORT/tree/master)

# PORT
PORTは、エンジニアが自身のポートフォリオを共有するためのサービスです。<br>
他のエンジニアのポートフォリオを参考にしたり、レビューを依頼することで、ポートフォリオのブラッシュアップに活用できます。<br>
<br>
就活用のポートフォリオとして作成しました。

## URL
https://port-port.herokuapp.com/

## 概要


## 開発に際して
実際の現場を想定し、メンターの方に依頼して「Issue」「作業ブランチ」「プルリクエスト」を活用した擬似的なチームスタイルで開発しました。

## 使用技術
* Ruby 2.5.3, Rails 5.2.3
* Docker/docker-compose
* Redis
* Webpacker
* CircleCI
* RSpec
* SASS, Bootstrap, JQuery

### 開発環境
* Dockerfile/docker-compose.yml
  - Redis
  - Spring
  - Chrome (for system spec)
* CircleCi：Githubへpush時 及び プルリク時の自動テスト

### 本番環境
* Heroku
  - Redis （for Session, PVランキング）
* AWS S3：画像保存用ストレージ

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
