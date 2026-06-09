# reactアプリケーション（Topic ID直接指定）設定

## react app テンプレート作成

```% npx create-react-app faqdirect --template typescript```

## bootstrapインストール

```% cd faqdirect```

```% npm install react-bootstrap bootstrap```

## bootstrap iconインストール

```% npm install bootstrap bootstrap-icons```

## materializeインストール

```% npm i -S materialize-css```

## materialize typesインストール

```% npm i -D @types/materialize-css```

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

http://localhost:3000/faqdirect/Content/100

## CORS設定

開発モード(npm start)で動作させるためには、CORSの設定が必要

### webアプリケーションのCORS設定

2026.1以降のバージョンでは、この方法を推奨

管理ポータル>セキュリティ管理>ウェブ・アプリケーション>ウェブ・アプリケーションの編集

クロスオリジン設定タブを選んで、

- 許可されているオリジン
- 許可されているヘッダー

などの情報を適宜設定する

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

## .htaccessの設定（Apacheの場合）

デプロイの際（npm run build）には.htaccessを作成し、redirectの設定を行う

### http.conf

rewrite_moduleのロード

```
### コメントを外す
LoadModule rewrite_module lib/httpd/modules/mod_rewrite.so
```

AllowOverride Allの設定（ルート）

```
<Directory />
  AllowOverride All
</Directory>
```

AllowOverride Allの設定（ドキュメントルート）

```
<Directory "/opt/homebrew/var/www">
    #
    # Possible values for the Options directive are "None", "All",
    # or any combination of:
    #   Indexes Includes FollowSymLinks SymLinksifOwnerMatch ExecCGI MultiViews
    #
    # Note that "MultiViews" must be named *explicitly* --- "Options All"
    # doesn't give it to you.
    #
    # The Options directive is both complicated and important.  Please see
    # http://httpd.apache.org/docs/2.4/mod/core.html#options
    # for more information.
    #
    Options Indexes FollowSymLinks

    #
    # AllowOverride controls what directives may be placed in .htaccess files.
    # It can be "All", "None", or any combination of the keywords:
    #   AllowOverride FileInfo AuthConfig Limit
    #
    AllowOverride All

    #
    # Controls who can get stuff from this server.
    #
    Require all granted
</Directory>
```

### .htaccessの内容

以下の様な内容を記述する

```
RewriteEngine On
RewriteBase /faqdirect/
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteCond %{REQUEST_FILENAME} !-l
RewriteRule ^ index.html [QSA,L]
```

### packege.jsonの設定

以下の内容を追加

"homepage": "/faqdirect"

## web.configの設定(IISの場合)

IISの場合には、.htaccessの代わりにweb.configを設定する

```
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
  <system.webServer>
    <rewrite>
      <rules>
        <rule name="React Router" stopProcessing="true">
          <match url=".*" />
          <conditions logicalGrouping="MatchAll">
            <add input="{REQUEST_FILENAME}" matchType="IsFile" negate="true" />
            <add input="{REQUEST_FILENAME}" matchType="IsDirectory" negate="true" />
          </conditions>
          <action type="Rewrite" url="/faqdirect/index.html" />
        </rule>
      </rules>
    </rewrite>
  </system.webServer>
</configuration>
```

### 配置方法：

1. public/web.config としてファイルを作成
2. npm run build を実行 → build/web.config として自動的にコピーされる
3. build フォルダの中身をIISのサイトディレクトリにデプロイ

### 前提条件（IIS側の設定）：

|必要なもの|	確認方法|
|--------|--------|
|URL Rewrite モジュール	|IISマネージャー → モジュール一覧に RewriteModule があるか|
|インストールされていない場合|	Microsoft公式サイトからダウンロード|

