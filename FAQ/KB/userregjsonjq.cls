Class KB.userregjsonjq Extends %CSP.Page
{

/// Event handler for <b>PAGE</b> event: this is invoked in order to  
/// generate the content of a csp page.
ClassMethod OnPage() As %Status [ ServerOnly = 1 ]
{
 set tLocale = $$SetIO^%NLS("UTF8")
 Set tError = $$$OK
 Set sts = $$$OK
 Set tNamespace = $namespace
 Try {
   Zn "%SYS"
   set RegisterInfo = %request.Data("registerInfo",1)
   do ##class(%ZEN.Auxiliary.jsonProvider).%ConvertJSONToObject(RegisterInfo,,.tUserOBJ)
   set Username = tUserOBJ.Username
   set Password = tUserOBJ.Password
   set Name = tUserOBJ.Name
   set Company = tUserOBJ.Company
   set Email = tUserOBJ.Email
   set Dep = tUserOBJ.Dep
   set Confirm = tUserOBJ.Confirm
   If $Get(Username)="" set Error="ユーザ名を入力して下さい" THROW ##class(%Exception.General).%New("ユーザー登録エラー","996",,Error)  
   If $classmethod("Security.Users","Exists",Username,.sts) Set Error="ユーザ名は、既に登録されています。他のユーザ名をお使いください" THROW ##class(%Exception.General).%New("ユーザー登録エラー","991",,Error)
   If $Get(Password)'=$Get(Confirm) Set Error="パスワード確認ができませんでした。" THROW ##class(%Exception.General).%New("ユーザー登録エラー","992",,Error)
   If $Get(Name)="" Set Error="お名前の入力をお願いします。" THROW ##class(%Exception.General).%New("ユーザー登録エラー","993",,Error)
   If $Get(Company)="" Set Error="会社名（あるいは所属組織名）の入力をお願いします。" THROW ##class(%Exception.General).%New("ユーザー登録エラー","994",,Error)
   If $Get(Email)="" Set Error="E-mailアドレスの入力をお願いします。" THROW ##class(%Exception.General).%New("ユーザー登録エラー","995",,Error)
   Set sts = $classmethod("Security.Users","Create",Username,,Password,Name,,,,,1,$Listbuild(Email,Company,Dep))
 }
 catch ErrorH {
	 set tErrorText = ErrorH.Data
	 set tError = ErrorH.AsStatus()
 }
 Zn tNamespace
 If $$$ISERR(tError) Write tErrorText,! Quit $$$OK
 If $$$ISERR(sts) Write $system.Status.DisplayError(sts) Quit $$$OK
 
 //以下のコードを動作させるためにはSMTP関連の設定が必要
 // smtpサーバーのアドレス
 // smtpサーバーのポート番号（デフォルト25ではない場合）
 // メールの送信アドレス
 // smtpの認証ユーザーとパスワード
 
 Set s=##class(%Net.SMTP).%New()
 Set s.smtpserver=$Get(^Techinfo("SMTP Server"))
 set auth=##class(%Net.Authenticator).%New() ; use default authentication list
 set auth.UserName="zzz"
 set auth.Password="zzz"
 set s.authenticator=auth
 Set m=##class(%Net.MailMessage).%New()
 Set m.From=$Get(^Techinfo("Mail Sender"))
 Do m.To.Insert(Email)
 Set m.Subject="Cach&eacute;ソリューションページへのユーザご登録"
 Set m.Charset = "ISO-2022-JP"
 Set crlf=$C(13,10)
 Do m.TextData.Write("このたびは、Cach&eacute;ソリューションページへのユーザご登録")
 Do m.TextData.Write("誠にありがとうございます。")
 Do m.TextData.Write(crlf)
 Do m.TextData.Write(crlf)
 Do m.TextData.Write("お客様のユーザ名、パスワードは、以下の様になっています。")
 Do m.TextData.Write(crlf)
 Do m.TextData.Write(crlf)
 Do m.TextData.Write("ユーザ名: "_Username)
 Do m.TextData.Write(crlf)
 Do m.TextData.Write("パスワード: "_Password)
 Do m.TextData.Write(crlf)
 Do m.TextData.Write(crlf)
 Do m.TextData.Write("今後ともCach&eacute;をご愛顧いただきますよう、")
 Do m.TextData.Write(crlf)
 Do m.TextData.Write("よろしくお願い申し上げます。")
 Do m.TextData.Write(crlf)
 Do m.TextData.Write(crlf)
 Do m.TextData.Write("インターシステムズジャパン株式会社")
 Do m.TextData.Write(crlf)
 Do m.TextData.Write(crlf)
 Do m.TextData.Write("※本メールの一部、または全部の無断転載を禁じます。")
 Do m.TextData.Write(crlf)
 set status=s.Send(m)
 If $$$ISERR(status) Write $System.Status.GetErrorText(status) Quit $$$OK
 write "登録しました",! quit $$$OK
}

/// Event handler for <b>PreHTTP</b> event: this is invoked before
/// the HTTP headers for a CSP page have been sent.  All changes to the
/// <class>%CSP.Response</class> class, such as adding cookies, HTTP headers,
/// setting the content type etc. must be made from within the OnPreHTTP() method.
/// Also changes to the state of the CSP application such as changing
/// %session.EndSession or %session.AppTimeout must be made within the OnPreHTTP() method.
/// It is prefered that changes to %session.Preserve are also made in the OnPreHTTP() method
/// as this is more efficient, although it is supported in any section of the page.
/// Return <b>0</b> to prevent <method>OnPage</method> from being called.
ClassMethod OnPreHTTP() As %Boolean [ ServerOnly = 1 ]
{
    Set %response.ContentType = "text/plain" //So the browser understands that this is JSONP
    Quit $$$OK
}

}
