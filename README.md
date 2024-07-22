# FAQDEMO

FAQシステムのデモサイト

## gitクローン

* ```git clone https://github.com/wolfman0719/faqdemo.git```

## Docker ビルドプロセス

### ビルド&実行
* ```docker-compose up -d --build```      

を実行

## ローカルインストール(WindowsやMacOSにインストールしたIRISでセットアップする)

### FAQネームスペース作成

管理ポータルでFAQネームスペースを作成

### Setup.clsの編集

コードの一部に環境依存の部分があるので事前に修正

クラスメソッドのsetConfigParamsの以下に該当する部分を修正

```
	} elseif envID=5  {
		set ns = "FAQ"
		set auth = "96"		
		set separator = "\"
		set cspdir = "c:\InterSystems\IRIS\CSP\faq"
		set cspurl = "/csp/faq"
		set ftpdir = "c:\InterSystems\IRIS\CSP\faq\downloads"
		set setupdir = "c:\git\faqdemo"
		set classfiledir = ""
		set globalfilename = "TopicD.xml"
	//その他、ローカルに環境を作りたいときなどに使用(上の3つの内容を変更せずにここを利用) for MacOS
	} elseif envID=6  {
		set ns = "FAQ"
		set auth = "96"		
		set separator = "/"
		set cspdir = "/Applications/iris/csp/faq"
		set cspurl = "/csp/faq"
		set ftpdir = "/Applications/iris/csp/faq/downloads"
		set setupdir = "/Users/hsatoctr/git/faqdemo"
		set classfiledir = ""
		set globalfilename = "TopicD.xml"
	}

```

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

セットアップに関しては、FAQ/react/faqpc/README.mdを参照してください。

### Mobile版

セットアップに関しては、FAQ/react/faqsp/README.mdを参照してください。

### 直接ID指定

セットアップに関しては、FAQ/react/faqdirect/README.mdを参照してください。
