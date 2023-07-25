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

## ファイルコピー

以下のファイルをここからダウンロードし、上で作成したテンプレートディレクトリにコピーする

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


## serverconfig.jsonの調整

 IRISサーバーのIPアドレス、ポート番号を反映
 (デフォルト　IPアドレス = localhost IPポート番号: 52773)

 docker環境では、ポート番号を52775に変更する

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
