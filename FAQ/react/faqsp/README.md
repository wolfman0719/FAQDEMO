# reactアプリケーション設定

## react app (Mobile用)テンプレート作成

```% npx create-react-app faqmobile --template typescript```

## bootstrapインストール

```% cd faqmobile```

```% npm install react-bootstrap bootstrap```

## react-router-domインストール

```% npm install react-router-dom```

## axios インストール

```% npm install axios```

## react-tabs インストール

```% npm install react-tabs```

## highlight.jsのインストール

```% npm install highlight.js```

## ファイルコピー

以下のファイルをここからダウンロードし、上で作成したテンプレートディレクトリにコピーする

- ルート

  package.json
  
- public

  index.html

- src

  index.tsx

  App.tsx

  serverconfig.json

 - components
   
   Header.tsx

   Home.tsx

   Query.tsx

   QueryById.tsx

   TopicContent.tsx

   TopicList.tsx

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

