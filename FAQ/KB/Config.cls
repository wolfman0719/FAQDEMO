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

ClassMethod setAttachedFileName(afile As %String) As %String
{
	set ^Techinfo("AttachedFileName") = afile
}

ClassMethod setAuthenticationMethods(auth As %String) As %String
{
	set ^Techinfo("AuthenticationMethods") = auth
}

ClassMethod setClassFileDir(cfile As %String) As %String
{
	set ^Techinfo("ClassFileDir") = cfile
}

ClassMethod setCSPDirectory(cspdir As %String) As %String
{
	set ^Techinfo("CSPDirectory") = cspdir
}

ClassMethod setCSPUrl(url As %String) As %String
{
	set ^Techinfo("CSPUrl") = url
}

ClassMethod setDirectorySeparator(separator As %String) As %String
{
	set ^Techinfo("DirectorySeparator") = separator
}

ClassMethod setErrorPage(errorpage As %String) As %String
{
	set ^Techinfo("ErrorPage") = errorpage
}

ClassMethod setFTPDirectory(ftpdir As %String) As %String
{
	set ^Techinfo("FTPDirectory") = ftpdir
}

ClassMethod setGlobalFileName(gfile As %String) As %String
{
	set ^Techinfo("GlobalFileName") = gfile
}

ClassMethod setKatakanaWordsFileName(katakanafile As %String) As %String
{
	set ^Techinfo("KatakanaWordsFileName") = katakanafile
}

ClassMethod setMailSender(mailsender As %String) As %String
{
	set ^Techinfo("MailSender") = mailsender
}

ClassMethod setNamespace(ns As %String) As %String
{
	set ^Techinfo("Namespace") = ns
}

ClassMethod setSMTPServer(smtp As %String) As %String
{
	set ^Techinfo("SMTPServer") = smtp
}

ClassMethod setStartYear(syear As %String) As %String
{
	set ^Techinfo("StartYear") = syear
}

ClassMethod setXMLExportDirectory(xmldir As %String) As %String
{
	set ^Techinfo("XMLExportDirectory") = xmldir
}

ClassMethod setSetupDirectory(setupdir As %String) As %String
{
	set ^Techinfo("SetupDirectory") = setupdir
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
<Type>%Library.CacheStorage</Type>
}

}
