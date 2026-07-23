# FAQDEMO

FAQシステムのデモサイト

## gitクローン

* ```git clone https://github.com/wolfman0719/faqdemo.git```

## Docker ビルドプロセス

### ビルド&実行
* ```docker-compose up -d --build```      

を実行

### 後処理

2025.3以降、Dockerビルド実行後、以下の後処理を実行しないとCSPが正しく動作しない

```
docker exec -it faqdemo /bin/sh
$ iris session iris

ノード: iris インスタンス: IRIS

USER>do $system.CSP.LoadPageDir("/csp/user","ck")

CSPページのロード開始 07/23/2026 14:52:07
ファイル /usr/irissys/csp/user/complete.csp を csp としてロード中
ファイルのコンパイル中 /csp/user/complete.csp
ファイル /usr/irissys/csp/user/history.csp を csp としてロード中
ファイルのコンパイル中 /csp/user/history.csp
ファイル /usr/irissys/csp/user/howto.csp を csp としてロード中
ファイルのコンパイル中 /csp/user/howto.csp
ファイル /usr/irissys/csp/user/howtoforeditors.csp を csp としてロード中
ファイルのコンパイル中 /csp/user/howtoforeditors.csp
ファイル /usr/irissys/csp/user/imageupload.csp を csp としてロード中
ファイルのコンパイル中 /csp/user/imageupload.csp
ファイル /usr/irissys/csp/user/edit.csp を csp としてロード中
ファイルのコンパイル中 /csp/user/edit.csp
ファイル /usr/irissys/csp/user/menu.csp を csp としてロード中
ファイルのコンパイル中 /csp/user/menu.csp
ファイル /usr/irissys/csp/user/new.csp を csp としてロード中
ファイルのコンパイル中 /csp/user/new.csp
ファイル /usr/irissys/csp/user/result.csp を csp としてロード中
ファイルのコンパイル中 /csp/user/result.csp
ファイル /usr/irissys/csp/user/transfer.csp を csp としてロード中
ファイルのコンパイル中 /csp/user/transfer.csp
ファイル /usr/irissys/csp/user/showsource.csp を csp としてロード中
ファイルのコンパイル中 /csp/user/showsource.csp
, 11 クラスをコンパイル中
クラスのコンパイル中 csp.complete
クラスのコンパイル中 csp.edit
クラスのコンパイル中 csp.history
クラスのコンパイル中 csp.howto
クラスのコンパイル中 csp.howtoforeditors
クラスのコンパイル中 csp.imageupload
クラスのコンパイル中 csp.menu
クラスのコンパイル中 csp.new
クラスのコンパイル中 csp.result
クラスのコンパイル中 csp.transfer
クラスのコンパイル中 csp.showsource
ルーチンのコンパイル中 csp.complete.1
ルーチンのコンパイル中 csp.history.1
ルーチンのコンパイル中 csp.howto.1
ルーチンのコンパイル中 csp.howtoforeditors.1
ルーチンのコンパイル中 csp.imageupload.1
ルーチンのコンパイル中 csp.edit.1
ルーチンのコンパイル中 csp.menu.1
ルーチンのコンパイル中 csp.result.1
ルーチンのコンパイル中 csp.showsource.1
ルーチンのコンパイル中 csp.transfer.1
ルーチンのコンパイル中 csp.new.1
ロードが正常に完了しました。

USER>
```

## ローカルインストール(WindowsやMacOSにインストールしたIRISでセットアップする)

### Python Flaskパッケージのインストール

--targetは環境により異なる

```python3 -m pip install --upgrade　--target c:¥Intersystems¥iris¥mgr¥python flask```

### Python ベクトル検索用パッケージインストール

--targetは環境により異なる

```
python3 -m pip install --upgrade　--target c:¥Intersystems¥iris¥mgr¥python　sentence_transformers
python3 -m pip install --upgrade --target c:¥Intersystems¥iris¥mgr¥python langchain_text_splitters
```

### FAQネームスペース作成

管理ポータルでFAQネームスペースを作成

### Setupクラスのロード

ターミナルでログイン

```
>zn "FAQ"
>set pDir = "c:\git\FAQDEMO\FAQ"
>Do $system.OBJ.Import(pDir_"\KB\Setup.cls","ck")
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

- React版FAQ検索

  webgatewayコンテナ経由のアクセス

  [localhost:8882/faqreact/faqsearch/](http://localhost:8882/faqreact/faqsearch)

  nginxコンテナ経由のアクセス

  [localhost:8885/faqreact/faqsearch/](http://localhost:8885/faqreact/faqsearch/)


  - クラウド環境でDocker環境を構築した場合等localhostではないipアドレスまたは異なるポート番号を使用する場合

    FAQ/faqedit/static/jsの所にあるjsファイルからlocalhost（ポート番号）を検索し、そのipアドレス（ポート番号）に変更/保存し、docker-composeを実行する

    以下のような文字列を検索

    JSON.parse('{"CJ":"localhost","NO":8080,"jZ":"_system","_2":"SYS","cq":"/api/faq","Zs":"http"}

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

試験的にベクトル検索機能を実装してみました。

現時点ではヒット率や精度が満足できるレベルに達していないため、デフォルトではこの機能はディセーブルにしています。


### Vector DBの構築

```
>do ##class(FAQ.TopicVector).BuildVectorsFromDescriptionSummaries(file)
```

fileには、各トピック内容をGoogleのNoteBookLMでサマライズした内容を保存したエクセルファイル名を指定する

このレポジトリのFAQ/excel/faq-summary.xlsxを使用する
### ロードしたモデルをキャッシュする

詳細は、FAQ/python/readme.mdを参照
