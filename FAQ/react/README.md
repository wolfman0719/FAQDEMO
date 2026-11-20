# React版　FAQクライアント

## クライアントの種類

### faqdirect

トピックID直接指定

### faqedit

トピック検索&編集

### faqpc

PC用FAQ検索

### faqsp

モバイル用FAQ検索

### faqedit5

トピック検索&編集

ckeditor4をckeditor5に変更

## 本番環境での稼働に必要な設定（デプロイモード）

### Webゲートウェイ設定

#### dir_moduleのロード

LoadModule dir_module /usr/lib/apache2/modules/mod_dir.so

#### DirectyIndexの設定

<IfModule dir_module>
  DirectoryIndex index.html
</IfModule>

#### ドキュメントルートの設定

DocumentRoot "/var/www/html"

詳細は、Webgatewayのcsp.confの内容を確認してください

### デプロイの際のファイルの配置

faqdirect、faqedit、faqedit5、faqspに関して、ドキュメントルート配下に配置するディレクトリ構造には依存性がある

現状のソースでは/faqreact配下に配置する想定になっている

- /faqreact/faqmobile/
- /faqreact/faqdirect/
- /faqreact/faqedit/
- /faqreact/faqedit5/

これを以下のように変更するためには、

- /faqmobile/
- /faqdirect/
- /faqedit/
- /faqedit5/

以下のファイルを変更する必要がある

- package.json




