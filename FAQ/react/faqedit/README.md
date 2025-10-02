# FAQ編集アプリケーション設定

## react app テンプレート作成

```% npx create-react-app faqedit --template typescript```

## bootstrapインストール

```% cd faqedit```

```% npm install react-bootstrap bootstrap```

## bootstrap iconインストール

```% npm install bootstrap bootstrap-icons```

## react-router-domインストール

```% npm install react-router-dom```

## axios インストール

```% npm install axios```

## react-tabs インストール

```% npm install react-tabs```


## ckeditor4-react@4.3.0のインストール

```% npm --force install ckeditor4-react@4.3.0```

## highlight.jsのインストール

```% npm --force install highlight.js```

## react-hook-formのインストール

```% npm --force install react-hook-form```

## ファイルコピー

以下のファイルをここからダウンロードし、上で作成したテンプレートディレクトリにコピーする

- ルート

  package.json
  
- public

  intersystems.css

  images/

- src

  index.tsx

  App.tsx

  Table.css

  serverconfig.json

 - components

   DownloadFile.tsx
   
   Header.tsx

   Home.tsx

   NoSignin.tsx

   Query.tsx

   QueryById.tsx

   RelatedTopics.tsx

   Signin.css
   
   Signin.tsx

   snippet.css

   style.css

   sysedit.css

   TopicContent.tsx

   TopicEditor.tsx

   TopicInfo.tsx   

   TopicList.tsx

   TopicVectorList.tsx

   VectorSearchQuery.tsx

  - hooks

    useWindowSize.ts

## serverconfig.jsonの調整

 IRISサーバーのIPアドレス、ポート番号を反映
 (デフォルト　IPアドレス = localhost IPポート番号: 52773)

 ローカルにセットアップした環境では、ポート番号をその環境に合わせて変更する

 Edit

  trueの場合、トピックの作成/編集が可能(FAQEditロールがあるユーザーでログインする必要あり）
  
  falseの場合、トピック参照のみ

VectorSearch

  trueの場合、ベクトル検索用のタブが表示される
  
  falseの場合、ベクトル検索用のタブは表示されない

## reactアプリケーションの起動

- npm start

    Starts the development server.

- npm run build

    Bundles the app into static files for production.

- npm test

    Starts the test runner.

- npm run eject

    Removes this tool and copies build dependencies, configuration files
    and scripts into the app directory. If you do this, you can’t go back!

## ブラウザからのアクセス

### 開発モード

  npm startの場合

- http://localhost:3000/faqedit/

 ユーザー名、パスワードは任意のユーザーアカウントのものを使用する
 
 編集機能を使うためには、FAQEditorロールが必要

### デプロイモード

npm run buildの場合
   
- http://localhost:8080/faqedit/

  npm run buildして生成されたbuildディレクトリをfaqeditに名前変更し、httpのドキュメントルートにコピーする

## CORS設定

開発モード(npm start)で動作させるためには、CORSの設定が必要

### http.confの修正（以下の行を追加）

macOSの場合

```
/opt/homebrew/etc/httpd
```

```
<IfModule mod_headers>
    Header set Access-Control-Allow-Origin "*"
    Header set Access-Control-Allow-Methods "GET,POST,PUT,DELETE,OPTIONS, PATCH"
    Header set Access-Control-Allow-Headers "Content-Type,Authorization,X-Requested-With"
    Header set Access-Control-Allow-Credentials "true"
</IfModule>
```

### IIS

IISの場合は、以下の設定を参考


https://mihono-bourbon.com/iis-cors/

## デプロイの際（npm run build）には.htaccessを作成し、redirectの設定を行う

### http.conf

```
<Directory />
  AllowOverride All
</Directory>
```

### .htaccessの内容

以下の様な内容を記述する
(必ず最後に空白行が必要）

```
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteCond %{REQUEST_FILENAME} !-l
RewriteRule ^ index.html [QSA,L]

```

## 制限事項

### 開発モードの制限事項

ckeditor4のファイルアップロード機能が動作しない
（CORS環境ではckeditor4のアップローダが動作できないため）

buildモードではOK

### 新規トピック作成時の添付ファイルアップロード

実装上の制約により（添付ファイル名にトピックIDが含まれる）、新規作成時にはファイルを添付できないように制限している。

### Docker環境の制限

Dockerで実装されているコミュニテイ版の簡易Webサーバーでは、BrowserRouterでは動作しないため、HashRouterに置き換える必要がある

App.tsxのBrowserRouterをHashRouterに全て置き換える。

Base Nameの部分も削除

変更後、npm run buildで再構築
