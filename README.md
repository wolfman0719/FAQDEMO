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

```
>do ##class(KB.Setup).SetupLocal(pDir)
```

## アプリケーション起動

* FAQシステムエントリー

  [localhost:52773/csp/user/FAQ.FAQApp.cls?IRISUsername=_system&IRISPassword=SYS](http://localhost:52773/csp/user/FAQ.FAQApp.cls?IRISUsername=_system&IRISPassword=SYS)

　ポート番号は、Dockerでビルドした場合の番号です。
  ローカルにセットアップした場合は、ポート番号とネームスペース名を環境に合わせて変更する必要があります


- 管理ポータル

  [localhost:52773/csp/sys/%25CSP.Portal.Home.zen?IRISUsername=_system&IRISPassword=SYS](http://localhost:52773/csp/sys/%25CSP.Portal.Home.zen?IRISUsername=_system&IRISPassword=SYS)

## reactアプリケーション

### PC版

セットアップに関しては、FAQ/react/faqpc/README.mdを参照してください。

### Mobile版

セットアップに関しては、FAQ/react/faqsp/README.mdを参照してください。

### 直接ID指定

セットアップに関しては、FAQ/react/faqdirect/README.mdを参照してください。

## Flaskアプリケーション

起動方法は、FAQ/flask/README.mdを参照してください
