# FAQDEMO

FAQシステムのDocker Build デモサイト


## ビルドプロセス

### ビルド
* ```./build.sh```      for Linux, MacOS
* ```build.sh```        for Windows
### 実行
* ```./run.sh```        for Linux, MacOS
* ```./run.sh```        for Windows

-bash: ./build.sh: Permission deniedとエラーになる場合は、

```chmod 777 *.sh```

を実行後、再度ビルドと実行

## アプリケーション起動

* FAQシステムエントリー

  [localhost:52775/csp/user/FAQ.FAQApp.cls?IRISUsername=_system&IRISPassword=demosystem](http://localhost:52775/csp/user/FAQ.FAQApp.cls?IRISUsername=_system&IRISPassword=demosystem)

- 管理ポータル

  [localhost:52775/csp/sys/%25CSP.Portal.Home.zen?IRISUsername=_system&IRISPassword=demosystem](http://localhost:52775/csp/sys/%25CSP.Portal.Home.zen?IRISUsername=_system&IRISPassword=demosystem)

