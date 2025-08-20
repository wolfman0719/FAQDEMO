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
>Do $system.OBJ.Load(pDir_"\KB\UsersVoice.cls","ck")
>Do $system.OBJ.Load(pDir_"\KB\Utility.cls","ck")
```

### SetupLocalの実行

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
   /300の部分は、トピック番号を入力

 - React版FAQ検索＆編集

   [localhost:52773/csp/faqedit/index.html](http://localhost:52773/csp/faqedit/index.html)

   ログインユーザー: _system

   パスワード: SYS
  

## reactアプリケーション

### PC版

セットアップに関しては、FAQ/react/faqpc/README.mdを参照してください。

### Mobile版

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
