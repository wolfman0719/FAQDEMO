# FAQDEMO

FAQシステムのデモサイト


## Docker ビルドプロセス

### ビルド&実行
* ```docker-compose up -d --build```      

を実行

## ローカルインストール(WindowsやMacOSにインストールしたIRISでセットアップする)

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

  ローカルにセットアップした場合は、ポート番号を環境に合わせて変更する必要があるかもしれません


- 管理ポータル

  [localhost:52773/csp/sys/%25CSP.Portal.Home.zen?IRISUsername=_system&IRISPassword=SYS](http://localhost:52773/csp/sys/%25CSP.Portal.Home.zen?IRISUsername=_system&IRISPassword=SYS)

## reactアプリケーション

### PC版

セットアップに関しては、FAQ/react/faqpc/react-setup.mdを参照してください。

### Mobile版

セットアップに関しては、FAQ/react/faqsp/react-setup.mdを参照してください。
