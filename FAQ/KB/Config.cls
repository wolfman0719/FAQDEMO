Class KB.Config
{

ClassMethod getAttachedFileName() As %String
{
	quit $get(^Techinfo("AttachedFileName"))
}

ClassMethod getAuthenticationMethods() As %String
{
	quit $get(^Techinfo("AuthenticationMethods"))
}

ClassMethod getClassFileDir() As %String
{
	quit $get(^Techinfo("ClassFileDir"))
}

ClassMethod getCSPDirectory() As %String
{
	quit $get(^Techinfo("CSPDirectory"))
}

ClassMethod getCSPUrl() As %String
{
	quit $get(^Techinfo("CSPUrl"))
}

ClassMethod getDirectorySeparator() As %String
{
	quit $get(^Techinfo("DirectorySeparator"))
}

ClassMethod getErrorPage() As %String
{
	quit $get(^Techinfo("ErrorPage"))
}

ClassMethod getFTPDirectory() As %String
{
	quit $get(^Techinfo("FTPDirectory"))
}

ClassMethod getGlobalFileName() As %String
{
	quit $get(^Techinfo("GlobalFileName"))
}

ClassMethod getMailSender() As %String
{
	quit $get(^Techinfo("MailSender"))
}

ClassMethod getNamespace() As %String
{
	quit $get(^Techinfo("Namespace"))
}

ClassMethod getSMTPServer() As %String
{
	quit $get(^Techinfo("SMTPServer"))
}

ClassMethod getStartYear() As %String
{
	quit $get(^Techinfo("StartYear"))
}

ClassMethod getXMLExportDirectory() As %String
{
	quit $get(^Techinfo("XMLExportDirectory"))
}

ClassMethod getSetupDirectory() As %String
{
	quit $get(^Techinfo("SetupDirectory"))
}

ClassMethod getWebServerPort() As %String
{
	quit $get(^Techinfo("WebServerPort"))
}

ClassMethod getWebServerAddress() As %String
{
	set address = $get(^Techinfo("WebServerAddress"))
	quit $case(address,"":"localhost",:address)
}

ClassMethod setAttachedFileName(afile As %String) As %Status
{
	set ^Techinfo("AttachedFileName") = afile
	quit $$$OK
}

ClassMethod setAuthenticationMethods(auth As %String) As %Status
{
	set ^Techinfo("AuthenticationMethods") = auth
	quit $$$OK
}

ClassMethod setClassFileDir(cfile As %String) As %Status
{
	set ^Techinfo("ClassFileDir") = cfile
	quit $$$OK
}

ClassMethod setCSPDirectory(cspdir As %String) As %Status
{
	set ^Techinfo("CSPDirectory") = cspdir
	quit $$$OK
}

ClassMethod setCSPUrl(url As %String) As %Status
{
	set ^Techinfo("CSPUrl") = url
	quit $$$OK
}

ClassMethod setDirectorySeparator(separator As %String) As %Status
{
	set ^Techinfo("DirectorySeparator") = separator
	quit $$$OK
}

ClassMethod setErrorPage(errorpage As %String) As %Status
{
	set ^Techinfo("ErrorPage") = errorpage
	quit $$$OK
}

ClassMethod setFTPDirectory(ftpdir As %String) As %Status
{
	set ^Techinfo("FTPDirectory") = ftpdir
	quit $$$OK
}

ClassMethod setGlobalFileName(gfile As %String) As %Status
{
	set ^Techinfo("GlobalFileName") = gfile
	quit $$$OK
}

ClassMethod setKatakanaWordsFileName(katakanafile As %String) As %Status
{
	set ^Techinfo("KatakanaWordsFileName") = katakanafile
	quit $$$OK
}

ClassMethod setMailSender(mailsender As %String) As %Status
{
	set ^Techinfo("MailSender") = mailsender
	quit $$$OK
}

ClassMethod setNamespace(ns As %String) As %Status
{
	set ^Techinfo("Namespace") = ns
	quit $$$OK
}

ClassMethod setSMTPServer(smtp As %String) As %Status
{
	set ^Techinfo("SMTPServer") = smtp
	quit $$$OK
}

ClassMethod setStartYear(syear As %String) As %Status
{
	set ^Techinfo("StartYear") = syear
	quit $$$OK
}

ClassMethod setXMLExportDirectory(xmldir As %String) As %Status
{
	set ^Techinfo("XMLExportDirectory") = xmldir
	quit $$$OK
}

ClassMethod setSetupDirectory(setupdir As %String) As %Status
{
	set ^Techinfo("SetupDirectory") = setupdir
	quit $$$OK
}

ClassMethod setWebServer() As %Status
{
	set status = $$$OK
	set namespace = $namespace
	set $namespace = "%SYS"
	set status = ##class(Config.Startup).Get(.p)
	set $namespace = namespace
	set ^Techinfo("WebServerAddress") = p("WebServerName")
	set ^Techinfo("WebServerPort") = p("WebServerPort")
	quit status
}

ClassMethod setWebServerPort(port As %Integer) As %Status
{
	set ^Techinfo("WebServerPort") = port
	quit $$$OK
}

Storage Default
{
<Data name="ConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DirectorySeparator</Value>
</Value>
<Value name="3">
<Value>FTPDirectory</Value>
</Value>
<Value name="4">
<Value>MailSender</Value>
</Value>
<Value name="5">
<Value>SMTPServer</Value>
</Value>
<Value name="6">
<Value>WebServer</Value>
</Value>
</Data>
<DataLocation>^KB.ConfigD</DataLocation>
<DefaultData>ConfigDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^KB.ConfigD</IdLocation>
<IndexLocation>^KB.ConfigI</IndexLocation>
<StreamLocation>^KB.ConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
