Class FAQ.FAQError Extends (%ZEN.Component.page, %CSP.Error)
{

/// このページが属するアプリケーションのクラス名です。
Parameter APPLICATION = "FAQ.FAQApp";

/// このページの表示名です。
Parameter PAGENAME = "FAQErrorPage";

/// ローカライズで使用されるドメインです。
Parameter DOMAIN;

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
<label id="msglabel" value="＊ページエラーが発生しました。恐れ入りますが、Top画面より再度検索を実行して下さい。＊"/>
</hgroup>
<spacer height="30"/>
<hgroup align="center">
<link id="totoppage" href="FAQ.FAQApp.cls" caption="InterSystems FAQトピック検索 Topへ" style=""/> 
</hgroup>
</page>
}

/// If the user with a new session goes to a page that causes an error before a license is obtained then in order to
/// display the standard error page to report this error CSP would take out a license. To avoid this license use in
/// this case the default behavior is to report a 'HTTP/1.1 404 Page not found' HTTP response. This does not require
/// a license. You may change
/// this by setting the class parameter OTHERSTATICERRORPAGE on the error page for this CSP application (or the default
/// error page in the case of the application not found error). The values are:<ul>
/// 
/// <li>"" - Return the 404 Page not found error (this is the default)</li>
/// <li>1 - Will obtain a license and display the standard error page.</li>
/// <li>Path to a static HTML page - Will display this static page, for example '/csp/samples/static.html' will use the
/// stream server to serve up this static file. This does not require a license, but it will only work with static content.</li></ul>
Parameter OTHERSTATICERRORPAGE As STRING = 1;

/// If the user with a new session goes to a page that is not present then in order to display the standard error page
/// to report this error CSP would take out a license. To avoid this license use if the error is because the application
/// is not found, or the page is not found, or the class does not exist, or the page is private and the token is not
/// correct then the default behavior is to report a 'HTTP/1.1 404 Page not found' HTTP response. This does not require
/// a license and it is standard behavior if you goto a page that is not present on a normal web server. You may change
/// this by setting the class parameter PAGENOTFOUNDERRORPAGE on the error page for this CSP application (or the default
/// error page in the case of the application not found error). The values are:<ul>
/// 
/// <li>"" - Return the 404 Page not found error (this is the default)</li>
/// <li>1 - Will obtain a license and display the standard error page.</li>
/// <li>Path to a static HTML page - Will display this static page, for example '/csp/samples/static.html' will use the
/// stream server to serve up this static file. This does not require a license, but it will only work with static content.</li></ul>
Parameter PAGENOTFOUNDERRORPAGE As STRING = 1;

/// Zen page notification of an HTTP request. This method can be overwritten
/// by subclasses.<br/>
/// This is called <em>before</em> the standard Zen pre-HTTP processing occurs.
ClassMethod %OnPreHTTP() As %Boolean [ ServerOnly = 1 ]
{
 Try {
	    Set tSC=%request.Get("Error:ErrorCode")
		if tSC'=1 {
			if tSC = "" Quit
			$$$ThrowStatus(tSC)
		}
	}
		Catch tE {
		set tSC = ##class(FAQ.Error).StoreErrorInformation(tE)
        }
	Quit $$$OK
}

}
