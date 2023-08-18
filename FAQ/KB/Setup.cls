Class KB.Setup
{

ClassMethod createAccentTable()
{
	kill ^KB.accent
	set ^KB.accent("é") = "&eacute;"
	set ^KB.accent("à") = "&agrave;"
	set ^KB.accent("è") = "&egrave;"
	set ^KB.accent("ù") = "&ugrave;"
	set ^KB.accent("â") = "&acirc;"
	set ^KB.accent("ê") = "&ecirc;"
	set ^KB.accent("î") = "&icirc;"
	set ^KB.accent("ô") = "&ocirc;"
	set ^KB.accent("û") = "&ucirc;"
	set ^KB.accent("ë") = "&euml;"
	set ^KB.accent("ï") = "&iuml;"
	set ^KB.accent("ü") = "&uuml;"
	set ^KB.accent("ç") = "&ccedil;"
	set ^KB.accent("œ") = "&oelig;"
	set ^KB.accent("æ") = "&aelig;"
	set ^KB.accent("É") = "&Eacute;"
	set ^KB.accent("À") = "&Agrave;"
	set ^KB.accent("È") = "&Egrave;"
	set ^KB.accent("Ù") = "&Ugrave;"
	set ^KB.accent("Â") = "&Acirc;"
	set ^KB.accent("Ê") = "&Ecirc;"
	set ^KB.accent("Î") = "&Icirc;"
	set ^KB.accent("Ô") = "&Ocirc;"
	set ^KB.accent("Û") = "&Ucirc;"
	set ^KB.accent("Ë") = "&Euml;"
	set ^KB.accent("Ï") = "&Iuml;"
	set ^KB.accent("Ü") = "&Uuml;"
	set ^KB.accent("Ç") = "&Ccedil;"
	set ^KB.accent("Œ") = "&OElig;"
	set ^KB.accent("Æ") = "&AElig;"
}

ClassMethod setConfigParams(envID As %Integer) As %Status
{
	//運用パラメータ設定
	// envID(環境ID)：クラウド(本番)環境＝1、jpnfilesrv＝2、クラウド(テスト)環境＝3

	//クラウド(本番)環境
	if envID=1 {
		set ns = "FAQ"
		set auth = "64"		//認証なし
		set separator = "/"
		set cspdir = "/intersystems/cache/csp/faq"
		set cspurl = "/csp/faq"
		set ftpdir = "/intersystems/cache/csp/faq/downloads"
		set setupdir = "/usr/FAQsetup"
		set classfiledir = "FAQ"
		set globalfilename = "TopicD.xml"
		
	//jpnfilesrv
	} elseif envID=2 {
		set ns = "Knowledge"
		set auth = "32"		//パスワード認証
		set separator = "\"
		set cspdir = "D:\InterSystems\Ensemble\CSP\knowledge"
		set cspurl = "/csp/knowledge"
		set ftpdir = "D:\InterSystems\Ensemble\CSP\knowledge\downloads"
		set setupdir = "P:\Public\Tech\FAQ\NewKB\FAQsetup"
		set classfiledir = "FAQ"
		set globalfilename = "TopicD.xml"
		
	//クラウド(テスト)環境
	} elseif envID=3 {
		set ns = "FAQ"
		set auth = "64"
		set separator = "/"
		set cspdir = "/intersystems/cache/csp/user"
		set cspurl = "/csp/user"
		set ftpdir = "/intersystems/cache/csp/user/downloads"
		set setupdir = "/usr/FAQsetup"
		set classfiledir = "FAQ"
		set globalfilename = "TopicD.xml"
		
		//Docker(お試し)環境
	} elseif envID=4 {
		set ns = "USER"
		set auth = "96"
		set separator = "/"
		set cspdir = "/usr/irissys/csp/user"
		set cspurl = "/csp/user"
		set ftpdir = "/usr/irissys/csp/user/downloads"
		set setupdir = "/intersystems/iris"
		set classfiledir = ""
		set globalfilename = "TopicD.xml"
		
	//その他、ローカルに環境を作りたいときなどに使用(上の3つの内容を変更せずにここを利用) for Windows
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
		set setupdir = "/Users/hiroshisato/git/FAQDEMO"
		set classfiledir = ""
		set globalfilename = "TopicD.xml"
	}
	
	do ##class(KB.Config).setAttachedFileName("Attached")
	do ##class(KB.Config).setMailSender("jpnsup@intersystems.com")
	do ##class(KB.Config).setSMTPServer("xxx.intersystems.com")
	do ##class(KB.Config).setStartYear("2003")
	do ##class(KB.Config).setNamespace(ns)
	do ##class(KB.Config).setAuthenticationMethods(auth)
	do ##class(KB.Config).setDirectorySeparator(separator)
	do ##class(KB.Config).setCSPDirectory(cspdir)
	do ##class(KB.Config).setCSPUrl(cspurl)
	do ##class(KB.Config).setErrorPage(cspurl_"/FAQ.FAQError.cls")
	do ##class(KB.Config).setFTPDirectory(ftpdir)
	do ##class(KB.Config).setSetupDirectory(setupdir)
	do ##class(KB.Config).setClassFileDir(classfiledir)
	do ##class(KB.Config).setGlobalFileName(globalfilename)
	do ##class(KB.Config).setWebServer()


	quit $$$OK
}

ClassMethod masterSetup() As %Status
{
	//マスタ初期化
	do ##class(KB.Facility).Init()
	do ##class(KB.Version).Init()
	do ##class(KB.Platform).Init()
	do ##class(KB.Category).Init()
	do ##class(KB.Product).Init()
	quit $$$OK
}

ClassMethod copyDownloadFiles(pSetupDir As %String) As %Status
{
	//ダウンロードファイルをFTPディレクトリーにコピーする
	set ftpDir = ##class(KB.Config).getFTPDirectory()
	set dirSep = ##class(KB.Config).getDirectorySeparator()
	//ディレクトリがなければコピーしない
	if '##class(%File).Exists(pSetupDir_dirSep_"downloads") quit $$$OK
	
	set sourcedir = pSetupDir_dirSep_"downloads"
	set dest = ftpDir
	set overlay = 1
	set boolean = ##class(%File).CopyDir(sourcedir,dest,overlay)
	quit $$$OK
}

ClassMethod copyImages(pSetupDir As %String) As %Status
{
	//参照用イメージファイルをimagesディレクトリーにコピーする
	set dirSep = ##class(KB.Config).getDirectorySeparator()
	//ディレクトリがなければコピーしない
	if '##class(%File).Exists(pSetupDir_dirSep_"images") quit $$$OK
	  
	set sourcedir = pSetupDir_dirSep_"images"
	set dest = ##class(KB.Config).getCSPDirectory()_dirSep_"images"
	set overlay = 1
	set boolean = ##class(%File).CopyDir(sourcedir,dest,overlay)  

	set sourcedir = pSetupDir_dirSep_"images"_dirSep_"background"
	set dest = ##class(KB.Config).getCSPDirectory()_dirSep_"images"_dirSep_"background"
	set overlay = 1
	set boolean = ##class(%File).CopyDir(sourcedir,dest,overlay)  

	set sourcedir = pSetupDir_dirSep_"images"_dirSep_"button"
	set dest = ##class(KB.Config).getCSPDirectory()_dirSep_"images"_dirSep_"button"
	set overlay = 1
	set boolean = ##class(%File).CopyDir(sourcedir,dest,overlay)  

	set sourcedir = pSetupDir_dirSep_"images"_dirSep_"logo"
	set dest = ##class(KB.Config).getCSPDirectory()_dirSep_"images"_dirSep_"logo"
	set overlay = 1
	set boolean = ##class(%File).CopyDir(sourcedir,dest,overlay)  

	set sourcedir = pSetupDir_dirSep_"images"_dirSep_"others"
	set dest = ##class(KB.Config).getCSPDirectory()_dirSep_"images"_dirSep_"others"
	set overlay = 1
	set boolean = ##class(%File).CopyDir(sourcedir,dest,overlay)
	
	quit $$$OK
}

ClassMethod copyCSSs(pCSPFileDir As %String) As %Status
{
	//cssファイルをcspディレクトリーにコピーする
	set CSPDir = ##class(KB.Config).getCSPDirectory()
	set dirSep = ##class(KB.Config).getDirectorySeparator()
	//ディレクトリがなければコピーしない
	if '##class(%File).Exists(pCSPFileDir) quit $$$OK
	
	set from = pCSPFileDir_dirSep_"style.css"
	set to = CSPDir_dirSep  
	set status = ##class(%File).CopyFile(from,to)
       
	set from = pCSPFileDir_dirSep_"styleedit.css"
	set to = CSPDir_dirSep  
	set status = ##class(%File).CopyFile(from,to)
    
	set from = pCSPFileDir_dirSep_"stylehowto.css"
	set to = CSPDir_dirSep  
	set status = ##class(%File).CopyFile(from,to)

    quit $$$OK
}

ClassMethod SetupLocal(pDir As %String) As %Status
{
  // GitHubからclone
  // FAQ.Installer.runInstallerでenvID=5に設定(Windows)
  // FAQ.Installer.runInstallerでenvID=6に設定(MacOS)
  // Windowsの場合, c:\git\FAQDEMO
  // MacOSの場合, /Users/hiroshisato/git/FAQDEMO
  // setupディレクトリ等を変更したい場合は、setConfigParamsの処理を書き換える

  set namespace = $namespace
  set $namespace = "%SYS"
  set sec = ##class("Security.Applications").%New()
  set sec.Name = "/api/faq"
  set sec.NameSpace = namespace
  set sec.DispatchClass ="FAQ.RestAPI"
  set sec.AutheEnabled = 96
  set status = sec.%Save()
  set $namespace = namespace
  
  if ($system.Version.GetOS() = "UNIX") {
    Do $system.OBJ.Load(pDir_"/FAQ/Installer.cls","ck")
    Do $system.OBJ.Load(pDir_"/KB/Config.cls","ck")
    Do $system.OBJ.Load(pDir_"/KB/Utility.cls","ck")
    do ##class(FAQ.Installer).runInstaller("FAQ",6)
  }
  else {
    Do $system.OBJ.Load(pDir_"\FAQ\Installer.cls","ck")
    Do $system.OBJ.Load(pDir_"\KB\Config.cls","ck")
    Do $system.OBJ.Load(pDir_"\KB\Utility.cls","ck")
    do ##class(FAQ.Installer).runInstaller("FAQ",5)
  }

  quit $$$OK
}

}
