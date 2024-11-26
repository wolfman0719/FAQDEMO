# reactアプリケーション（Topic ID直接指定）設定

## react app テンプレート作成

```% npx create-react-app faqdirect --template typescript```

## bootstrapインストール

```% cd faqdirect```

```% npm install react-bootstrap bootstrap```

## react-router-domインストール

```% npm install react-router-dom```

## axios インストール

```% npm install axios```

## highlight.jsのインストール

```% npm install highlight.js```

## ファイルコピー

以下のファイルをここからダウンロードし、上で作成したテンプレートディレクトリにコピーする

- ルート

  package.json

- public

  index.html
  
  htaccess

    .htaccessにリネームする

  intersystems.css

  images/

- src

  index.tsx

  App.tsx

  serverconfig.json

 - components

   DownloadFile.tsx
   
   Header.tsx

   Home.tsx

   RelatedTopics.tsx

   TopicContent.tsx

  - hooks

    useWindowSize.ts

## serverconfig.jsonの調整

 IRISサーバーのIPアドレス、ポート番号を反映
 (デフォルト　IPアドレス = localhost IPポート番号: 52773)

 ローカルにセットアップした環境では、ポート番号をその環境に合わせて変更する

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

## Topicの指定方法

http://localhost:3000/#/Content/100

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

## .htaccessの設定

デプロイの際（npm run build）には.htaccessを作成し、redirectの設定を行う

### http.conf

```
<Directory />
  AllowOverride All
</Directory>
```

### .htaccessの内容

以下の様な内容を記述する

```
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteCond %{REQUEST_FILENAME} !-l
RewriteRule ^ index.html [QSA,L]
```

