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
	// envID(環境ID)：クラウド(本番)環境＝1、jpnfilesrv＝2、クラウド(テスト)環境＝3、Docker(お試し)環境＝3

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
		set auth = "64"
		set separator = "/"
		set cspdir = "/usr/irissys/csp/user"
		set cspurl = "/csp/user"
		set ftpdir = "/usr/irissys/csp/user/downloads"
		set setupdir = "/intersystems/iris"
		set classfiledir = ""
		set globalfilename = "TopicD.xml"
		
	//その他、ローカルに環境を作りたいときなどに使用(上の3つの内容を変更せずにここを利用)
	} else {
		set ns = "FAQ"
		set auth = "64"		
		set separator = "\"
		set cspdir = "c:\InterSystems\Ensemble\CSP\faq"
		set cspurl = "/csp/faq"
		set ftpdir = "c:\InterSystems\Ensemble\CSP\faq\downloads"
		set setupdir = "e:\Work\FAQ"
		set classfiledir = "FAQ"
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
	if '##class(%File).Exists(pSetupDir_"downloads") quit $$$OK
	  
	if dirSep = "\" {
       set copyParam = pSetupDir_"downloads "_ftpDir
       set copyCommand = "xcopy"
       set args(1) = "/e"
       set args(2) = "/y"
       set args(3) = $piece(copyParam," ",1)
       set args(4) = $piece(copyParam," ",2)
       set args = 4
    }
    else  {
       set ftpDir = $piece(ftpDir,dirSep,1,*-1)
       set copyParam = pSetupDir_"downloads "_ftpDir
       set copyCommand = "cp"
       set args(1) = "-R"
       set args(2) = $piece(copyParam," ",1)
       set args(3) = $piece(copyParam," ",2)
       set args = 3
    }
       
    quit $zf(-100,"",copyCommand, .args)
}

ClassMethod copyImages(pSetupDir As %String) As %Status
{
	//参照用イメージファイルをimagesディレクトリーにコピーする
	set dirSep = ##class(KB.Config).getDirectorySeparator()
	//ディレクトリがなければコピーしない
	if '##class(%File).Exists(pSetupDir_"images") quit $$$OK
	  
	if dirSep = "\" {
	   set imagesDir = ##class(KB.Config).getCSPDirectory()_"images"
       set copyParam = pSetupDir_"images "_imagesDir
       set copyCommand = "xcopy"
       set args(1) = "/e"
       set args(2) = "/y"
       set args(3) = $piece(copyParam," ",1)
       set args(4) = $piece(copyParam," ",2)
       set args = 4
    }
    else  {
	   set imagesDir = ##class(KB.Config).getCSPDirectory()
       set copyParam = pSetupDir_"images "_imagesDir
       set copyCommand = "cp"
       set args(1) = "-R"
       set args(2) = $piece(copyParam," ",1)
       set args(3) = $piece(copyParam," ",2)
       set args = 3
    }
       
    quit $zf(-100,"",copyCommand,.args)
}

ClassMethod copyCSSs(pSetupDir As %String) As %Status
{
	//cssファイル等をcspディレクトリーにコピーする
	//$zf(-100)でうまくコピーできないので、１つずつコピーする
	set CSPDir = ##class(KB.Config).getCSPDirectory()
	set dirSep = ##class(KB.Config).getDirectorySeparator()
	//ディレクトリがなければコピーしない
	if '##class(%File).Exists(pSetupDir_"css") quit $$$OK
	
	set sourcedir = pSetupDir_"css"_dirSep
    set boolean = ##class(%File).CopyFile(sourcedir_"FAQ.js",CSPDir_dirSep_"FAQ.js")
    set boolean = ##class(%File).CopyFile(sourcedir_"style.css",CSPDir_dirSep_"style.css")
    set boolean = ##class(%File).CopyFile(sourcedir_"styleedit.css",CSPDir_dirSep_"styleedit.css")
    set boolean = ##class(%File).CopyFile(sourcedir_"stylehowto.css",CSPDir_dirSep_"stylehowto.css")
    
    quit $$$OK
  
}

}
