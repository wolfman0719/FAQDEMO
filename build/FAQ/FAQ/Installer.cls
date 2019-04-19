Class FAQ.Installer
{

/// マニフェスト定義.
XData FAQManifest [ XMLNamespace = INSTALLER ]
{
<Manifest>

<Namespace Name="${NAMESPACE}" 
           Create="no">
<CSPApplication 
    Url="${CSPUrl}"
    Description=""
    Directory="${CSPDirectory}"
    Resource=""
    Grant="%DB_%DEFAULT"
    Recurse="true"
    LoginClass=""
    CookiePath="${CSPUrl}"
    AuthenticationMethods="${AuthenticationMethods}"
     CustomErrorPage="${CustomErrorPage}"/>
 <If Condition='$L("${ClassFileDir}")>0'>
<Invoke Class="KB.Utility" Method="cspUtf8AddBOM" CheckStatus="0" Return="RetVal"> 
    <Arg Value="${CSPFileDir}"/>
</Invoke>
<Import File="${ClassFileDir}" Flags="ckr" Recurse="1" IgnoreErrors="1"> 
</Import>
<Invoke Class="%SYSTEM.OBJ" Method="Compile" CheckStatus="0" Return="RetVal"> 
    <Arg Value="KB.Topic"/>
    <Arg Value="ck"/>
</Invoke>
</If>
<If Condition='$L("${SetupType}")=1'>
<Invoke Class="KB.Setup" Method="masterSetup" CheckStatus="0" Return="RetVal"> 
</Invoke>
</If>
<If Condition='$L("${GlobalFileName}")>0'>
<Invoke Class="%SYSTEM.OBJ" Method="Load" CheckStatus="0" Return="RetVal"> 
    <Arg Value="${GlobalFileName}"/>
</Invoke>
<Invoke Class="KB.Topic" Method="ChangeUrlPathForImages" CheckStatus="0"> 
</Invoke>
<Invoke Class="KB.Topic" Method="%BuildIndices" CheckStatus="0" Return="RetVal"> 
</Invoke>
</If>
<If Condition='$L("${FTPDirectory}")>0'>
<Invoke Class="KB.Setup" Method="copyDownloadFiles" CheckStatus="0" Return="RetVal"> 
    <Arg Value="${setupdir}"/>
</Invoke>
</If>
<If Condition='$L("${CSPDirectory}")>0'>
<Invoke Class="KB.Setup" Method="copyImages" CheckStatus="0" Return="RetVal"> 
    <Arg Value="${setupdir}"/>
</Invoke>
<Invoke Class="KB.Setup" Method="copyCSPs" CheckStatus="0" Return="RetVal"> 
    <Arg Value="${CSPFileDir}"/>
</Invoke>
</If>
</Namespace>
</Manifest>
}

/// これは XGL により生成されたメソッド・ジェネレーターです。.
ClassMethod setup(ByRef pVars, pLogLevel As %Integer = 3, pInstaller As %Installer.Installer, pLogger As %Installer.AbstractLogger) As %Status [ CodeMode = objectgenerator, Internal ]
{
 #; XGL ドキュメントでこのメソッドのコードを生成する.
 Quit ##class(%Installer.Manifest).%Generate(%compiledclass, %code, "FAQManifest")
}

// envID(環境ID)：クラウド(本番)環境＝1、jpnfilesrv＝2、クラウド(テスト)環境＝3、その他＝4

// setuptype：初期セットアップ＝1、更新＝2

// datestr：セットアップキットのディレクトリ名に使った日付(YYYYMMDD)　※ディレクトリ名が今日の日付の場合は空でOK

ClassMethod runInstaller(datestr As %String) As %Status
{
    set envID = 4
	set setuptype = 1
	do ##class(KB.Setup).setConfigParams(envID)
	set setupdir = ##class(KB.Config).getSetupDirectory()_##class(KB.Config).getDirectorySeparator()_datestr_##class(KB.Config).getDirectorySeparator()
    set vars("setupdir") = setupdir
	set vars("FTPDirectory") = ##class(KB.Config).getFTPDirectory()
	set vars("ClassFileDir") = setupdir_##class(KB.Config).getClassFileDir()
	set vars("GlobalFileName") = setupdir_##class(KB.Config).getGlobalFileName()
				
	set vars("SetupType")			  = setuptype
	set vars("NAMESPACE")			  = ##class(KB.Config).getNamespace()
	set vars("CSPUrl")				  = ##class(KB.Config).getCSPUrl() 
	set vars("CSPDirectory") 		  = ##class(KB.Config).getCSPDirectory() 
	set vars("CustomErrorPage") 	  = ##class(KB.Config).getErrorPage()
	set vars("AuthenticationMethods") = ##class(KB.Config).getAuthenticationMethods()
    
	//以下のディレクトリ構造はGitHubリポジトリーに依存しているため固定
	set vars("CSPFileDir") = setupdir_##class(KB.Config).getClassFileDir()
	set vars("CSPFileDir") = vars("CSPFileDir")_##class(KB.Config).getDirectorySeparator()_"CSP"
	set vars("CSPFileDir") = vars("CSPFileDir")_##class(KB.Config).getDirectorySeparator()_"csp"
	set vars("CSPFileDir") = vars("CSPFileDir")_##class(KB.Config).getDirectorySeparator()_"isj"
        
	do ..setup(.vars,3)

	/*
	write "★実行する対象のenvIDを入力してください。",!,"  [クラウド(本番)環境＝1、jpnfilesrv＝2、クラウド(テスト)環境＝3、Docker(お試し)=4、その他＝5]：",!
	read envID,!
	
	write "★setuptypeを入力してください。[setuptype：初期セットアップ＝1、データとソースの更新＝2、データのみ更新＝3、アプリケーションソースのみ更新＝4]：",!
	read setuptype,!
	
	if envID=1 {
		set envname="クラウド(本番)環境"
	}elseif envID=2 {
		set envname="jpnfilesrv"
	}elseif envID=3 {
		set envname="クラウド(テスト)環境"
	}elseif envID=4 {
		set envname="Docker（お試し）環境"
	}else {
		set envname="その他環境"
	}
	
	if setuptype=1 {
		set setuptypename="初期セットアップ"
	} elseif setuptype=2 {
		set setuptypename="データとソースの更新"
	} elseif setuptype=3 {
		set setuptypename="データのみ更新"
	} elseif setuptype=4 {
		set setuptypename="アプリケーションソースのみ更新"
	}
	
	write envname_" の "_setuptypename_" を実行します。よろしいですか？(Y/N)："
	read answer,!
	
	if $zconvert(answer,"U") = "Y" {
		
		if setuptype=1 {
			do ##class(KB.Setup).setConfigParams(envID)
		}
		
		if $get(datestr)="" {
			set datestr=$zdate($h,8)
		}
		
		set setupdir = ##class(KB.Config).getSetupDirectory()_##class(KB.Config).getDirectorySeparator()_datestr_##class(KB.Config).getDirectorySeparator()
        set vars("setupdir") = setupdir
		set vars("FTPDirectory") = ##class(KB.Config).getFTPDirectory()
		if setuptype=1 {
			set vars("ClassFileDir") = setupdir_##class(KB.Config).getClassFileDir()
			set vars("GlobalFileName") = setupdir_##class(KB.Config).getGlobalFileName()
		}elseif setuptype=2 {
			set vars("ClassFileDir") = setupdir_##class(KB.Config).getClassFileDir()
			set vars("GlobalFileName") = setupdir_##class(KB.Config).getGlobalFileName()
		}elseif setuptype=3 {
			set vars("ClassFileDir") = ""
			set vars("GlobalFileName") = setupdir_##class(KB.Config).getGlobalFileName()
		}elseif setuptype=4 {
			set vars("ClassFileDir") = setupdir_##class(KB.Config).getClassFileDir()
			set vars("GlobalFileName") = ""
		}			
				
		set vars("SetupType")			  = setuptype
		set vars("NAMESPACE")			  = ##class(KB.Config).getNamespace()
		set vars("CSPUrl")				  = ##class(KB.Config).getCSPUrl() 
		set vars("CSPDirectory") 		  = ##class(KB.Config).getCSPDirectory() 
		set vars("CustomErrorPage") 	  = ##class(KB.Config).getErrorPage()
		set vars("AuthenticationMethods") = ##class(KB.Config).getAuthenticationMethods()
    
        if vars("ClassFileDir") = "" {
           set vars("CSPFileDir") = ""
        }
        else {
		  //以下のディレクトリ構造はGitHubリポジトリーに依存しているため固定
		  set vars("CSPFileDir") = setupdir_##class(KB.Config).getClassFileDir()
		  set vars("CSPFileDir") = vars("CSPFileDir")_##class(KB.Config).getDirectorySeparator()_"CSP"
		  set vars("CSPFileDir") = vars("CSPFileDir")_##class(KB.Config).getDirectorySeparator()_"csp"
		  set vars("CSPFileDir") = vars("CSPFileDir")_##class(KB.Config).getDirectorySeparator()_"isj"
        }
        
    	if (vars("ClassFileDir")'="") && (##class(%File).Exists(vars("ClassFileDir"))'=1) {
	    	w vars("ClassFileDir"),"は存在しません。ファイルを確認してください。",!
	    	quit 0
    	}
    	
    	if (vars("CSPFileDir")'="") && (##class(%File).Exists(vars("CSPFileDir"))'=1) {
	    	w vars("CSPFileDir"),"は存在しません。ファイルを確認してください。",!
	    	quit 0
    	}

    	if (vars("GlobalFileName")'="") && (##class(%File).Exists(vars("GlobalFileName"))'= 1) {
    		w vars("GlobalFileName"),"は存在しません。ファイルを確認してください。",!
	    	quit 0
    	}
    
		do ..setup(.vars,3)
		
	}else{
		w !,"Installerの実行を中止しました"
	}
	
	w "Installerの実行が完了しました",!
	*/
}

ClassMethod getVersion() As %String
{
	quit "1.0.022"
}

}
