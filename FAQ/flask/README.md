# flaskフレームワークのデモ

## セットアップ

## Webアプリケーションの設定

システム>セキュリティ管理>ウェブ・アプリケーション>ウェブ・アプリケーションの編集>

- 名前: /csp/faqflask

- WSGI

- アプリケーション名: topicbyid

- 呼び出し可能な名前: app

- WSGIアプリディレクトリ: <IRISインストールディレクトリ>/csp/faqflask/

- Python Protocol Type: WSGI

## ファイルのコピー

このflask配下のファイルを<IRISインストールディレクトリ>/csp/faqflask/にコピーする

## 実行方法

ポート番号は、実際の環境に合わせる

http://localhost:8080/csp/faqflask/topicid/:topicid

:topicidの所には実際のトピック番号を指定します。

例: http://localhost:8080/csp/faqflask/topicid/100
