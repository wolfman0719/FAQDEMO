# reactアプリケーション設定

## react app テンプレート作成

```% npx create-react-app faqpc --template typescript```

## bootstrapインストール

```% cd faqpc```

```% npm install react-bootstrap bootstrap```

## react-router-domインストール

```% npm install --save react-router-dom```

## axios インストール

```% npm install axios```

## ファイルコピー

以下のファイルをここからダウンロードし、上で作成したテンプレートディレクトリにコピーする

- public

  index.html

- src

  index.tsx

  App.tsx

  serverconfig.json

 - components

   DoqnloadFile.tsx
   
   Header.tsx

   Query.tsx

   RelatedTopics.tsx

   TopicContent.tsx

   TopicList.tsx

  - hooks

    useWindowSize.ts

## serverconfig.jsonの調整

 IRISサーバーのIPアドレス、ポート番号を反映
 (デフォルト　IPアドレス = localhost IPポート番号: 52773)

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
