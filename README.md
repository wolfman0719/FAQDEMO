# FAQDEMO

FAQシステムのデモサイト

## gitクローン

* ```git clone https://github.com/wolfman0719/faqdemo.git```

## Docker ビルドプロセス

### ビルド&実行
* ```docker-compose up -d --build```      

を実行

## ローカルインストール(WindowsやMacOSにインストールしたIRISでセットアップする)

###  Python　Flaskパッケージのインストール

```python3 -m pip install --target c:¥Intersystems¥iris¥mgr¥python flask```

### FAQネームスペース作成

管理ポータルでFAQネームスペースを作成

### Setupクラスのロード

ターミナルでログイン

```
>zn "FAQ"
>set pDir = "c:\git\FAQDEMO\FAQ"
>Do $system.OBJ.Load(pDir_"\KB\Setup.cls","ck")
```

### SetupLocalの実行

#### pDirの場所を変更する場合

c:¥git¥FAQDEMO(Windows)、$Home/git/faqdemo/git(MacOS)以外にリポジトリのファイルを展開した場合

KB.SetupクラスのsetConfigParamsクラスメソッドの以下の行を変更

(WindowsはEnvID=5, MacOSはEnvID=6)

```
set setupdir = "c:\git\faqdemo"
```

#### SetupLocalメソッドの実行

```
>do ##class(KB.Setup).SetupLocal(pDir)
```

## アプリケーション起動(Docker環境)

* FAQシステムエントリー

  [localhost:52773/csp/user/FAQ.FAQApp.cls?IRISUsername=_system&IRISPassword=SYS](http://localhost:52773/csp/user/FAQ.FAQApp.cls?IRISUsername=_system&IRISPassword=SYS)

  * ポート番号は、Dockerでビルドした場合の番号です。
 
  * ローカルにセットアップした場合は、ポート番号とネームスペース名を環境に合わせて変更する必要があります


- 管理ポータル

  [localhost:52773/csp/sys/%25CSP.Portal.Home.zen?IRISUsername=_system&IRISPassword=SYS](http://localhost:52773/csp/sys/%25CSP.Portal.Home.zen?IRISUsername=_system&IRISPassword=SYS)

- Flask版トピックID検索
 
  [localhost:52773/csp/faqflask/topicid/200](http://localhost:52773/csp/faqflask/topicid/200)

  /200の部分は、トピック番号を入力

- React版FAQ検索＆編集

  [localhost:52773/csp/faqedit/user/index.html](http://localhost:52773/csp/user/faqedit/index.html)

  ログインユーザー: _system

  パスワード: SYS

  - クラウド環境でDocker環境を構築した場合等localhostではないipアドレスまたは異なるポート番号を使用する場合

  　FAQ/faqedit/static/jsの所にあるjsファイルからlocalhost（ポート番号）を検索し、そのipアドレス（ポート番号）に変更/保存し、docker-composeを実行する

  　ブラウザキャッシュをクリアしないとその変更が反映しないケースがある
  

## reactアプリケーション

### PC版トピック表示

セットアップに関しては、FAQ/react/faqpc/README.mdを参照してください。

### Mobile版トピック表示

セットアップに関しては、FAQ/react/faqsp/README.mdを参照してください。

### 直接ID指定

セットアップに関しては、FAQ/react/faqdirect/README.mdを参照してください。

### トピック編集

セットアップに関しては、FAQ/react/faqedit/README.mdを参照してください。

## Flaskアプリケーション

起動方法は、FAQ/flask/README.mdを参照してください

## ベクトル検索機能

試験的にベクトル検索機能を実装してみたが、現時点ではヒット率や精度がまだ満足できるレベルではないため、デフォルトではこの機能はディセーブルになっている。

以下の操作を行うことで、機能がイネーブルになる

### reactのfaqeditのserverconfig.json

デフォルトではVectorSearch=falseとなっているが、trueに設定することで、ベクトル検索用のタブが追加される

### KB.SetupクラスのsetConfigParamsメソッド

最後の処理が以下のようになっているが、このパラメータを0から1に変更することでエンベッデングやインデックスの構築を行う

do ##class(KB.Config).setVectorSearch(0)
