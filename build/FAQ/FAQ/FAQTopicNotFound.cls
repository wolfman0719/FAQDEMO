Class FAQ.FAQTopicNotFound Extends %ZEN.Component.page
{

/// このページが属するアプリケーションのクラス名です。
Parameter APPLICATION = "FAQ.FAQApp";

/// このページの表示名です。
Parameter PAGENAME = "InterSystems FAQ Not Found";

/// ローカライズで使用されるドメインです。
Parameter DOMAIN;

Parameter PAGETITLE = "InterSystems FAQ Not Found";

/// この Style ブロックにはページ固有のCSSスタイル定義を記述します。
XData Style
{
<style type="text/css">

/* style for title bar */
#titlehgroup {
	background: url('images/background/header-gradient.gif');
	background-repeat: repeat-x;
	padding: 5px;
}

#title1 {
	color: #333399;
	font-family:arial;
	font-size: 33px;
	font-weight: bold;
	border: 0px;
}

#title2 {
	color: #333399;
	font-family:arial;
	font-size: 25px;
	border: 0px;
}

</style>
}

/// このXMLブロックはこのページのコンテンツを定義します。
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page xmlns="http://www.intersystems.com/zen" title="">
<hgroup id="titlehgroup" width="100%">
<vgroup width="50%" align="left" height="100%">
<html valign="bottom"><span id="title1" style="padding:0px 0px 0px 30px;">FAQ </span><span id="title2">(よくあるご質問)</span></html>
</vgroup>
<vgroup width="48%" align="center" height="100%">
<html align="right" ><a href="http://www.intersystems.co.jp" ><img src="images/logo/CompanyLogo.png" width="200" height="50" border="0"/></a></html>
</vgroup>
<spacer width="5" />
</hgroup>
<spacer height="30" />
<hgroup align="center">
<label id="msglabel" value="＊指定された番号のトピックは存在しません。＊"/>
</hgroup>
<spacer height="30"/>
<hgroup align="center">
<link id="totoppage" href="FAQ.FAQTopicSearch.cls" caption="InterSystems FAQトピック検索 Topへ" style=""/> 
</hgroup>
</page>
}

}
