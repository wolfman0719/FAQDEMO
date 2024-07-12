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

- public

  index.html

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
