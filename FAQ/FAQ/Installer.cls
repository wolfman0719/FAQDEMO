Class FAQ.Installer
{

/// マニフェスト定義.
XData FAQManifest [ XMLNamespace = INSTALLER ]
{
<Manifest>

<Log Text="Setting up namespace ${Namespace}" Level="0"/>
<Namespace Name="${Namespace}" Create="no"> 
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
<Import File="${FAQClassFileDir}" Flags="ckr" Recurse="1" IgnoreErrors="1"> 
</Import>
<Import File="${KBClassFileDir}" Flags="ckr" Recurse="1" IgnoreErrors="1"> 
</Import>
<Import File="${CSPClassFileDir}" Flags="ckr" Recurse="1" IgnoreErrors="1"> 
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
<Invoke Class="KB.Setup" Method="copyCSSs" CheckStatus="0" Return="RetVal"> 
    <Arg Value="${CSPFileDir}"/>
</Invoke>
<Invoke Class="KB.Setup" Method="copyFlask" CheckStatus="0" Return="RetVal"> 
    <Arg Value="${FlaskFileDir}"/>
</Invoke>
<Invoke Class="KB.Setup" Method="copyReact" CheckStatus="0" Return="RetVal"> 
    <Arg Value="${ReactFileDir}"/>
    <Arg Value="${ReactAppName}"/>
</Invoke>
<If Condition='${VectorSearch}'>
<Invoke Class="FAQ.Installer" Method="BuildVectorForDescriptions" CheckStatus="0" Return="RetVal">
</Invoke>
</If>
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

ClassMethod runInstaller(datestr As %String, envID As %Integer = 4) As %Status
{
    set setuptype = 1
    do ##class(KB.Setup).setConfigParams(envID)
    set setupdir = ##class(KB.Config).getSetupDirectory()_##class(KB.Config).getDirectorySeparator()_datestr_##class(KB.Config).getDirectorySeparator()
    set vars("setupdir") = setupdir
    set vars("FTPDirectory") = ##class(KB.Config).getFTPDirectory()
    set vars("ClassFileDir") = setupdir_##class(KB.Config).getClassFileDir()
    set vars("FAQClassFileDir") = setupdir_##class(KB.Config).getClassFileDir()_##class(KB.Config).getDirectorySeparator()_"FAQ"
    set vars("KBClassFileDir") = setupdir_##class(KB.Config).getClassFileDir()_##class(KB.Config).getDirectorySeparator()_"KB"
    set vars("CSPClassFileDir") = setupdir_##class(KB.Config).getClassFileDir()_##class(KB.Config).getDirectorySeparator()_"CSP"
    set vars("GlobalFileName") = setupdir_##class(KB.Config).getGlobalFileName()
				
    set vars("SetupType") = setuptype
    set vars("Namespace") = ##class(KB.Config).getNamespace()
    set vars("CSPUrl") = ##class(KB.Config).getCSPUrl() 
    set vars("CSPDirectory") = ##class(KB.Config).getCSPDirectory() 
    set vars("CustomErrorPage") = ##class(KB.Config).getErrorPage()
    set vars("AuthenticationMethods") = ##class(KB.Config).getAuthenticationMethods()

    set sep = ##class(KB.Config).getDirectorySeparator()
    set vars("CSPFileDir") = setupdir_##class(KB.Config).getClassFileDir()
    
    //以下のディレクトリ構造はGitHubリポジトリーに依存しているため固定
    set vars("CSPFileDir") = vars("CSPFileDir")_##class(KB.Config).getDirectorySeparator()_"CSP"
    set vars("CSPFileDir") = vars("CSPFileDir")_##class(KB.Config).getDirectorySeparator()_"csp"
    set vars("CSPFileDir") = vars("CSPFileDir")_##class(KB.Config).getDirectorySeparator()_"isj"

    set vars("CSPFileDir") = $replace(vars("CSPFileDir"),sep_sep,sep)

    set vars("FlaskFileDir") = setupdir_##class(KB.Config).getClassFileDir()
    set vars("FlaskFileDir") = vars("FlaskFileDir")_##class(KB.Config).getDirectorySeparator()_"flask"

    set vars("FlaskFileDir") = $replace(vars("FlaskFileDir"),sep_sep,sep)
    
    set vars("ReactFileDir") = setupdir_##class(KB.Config).getClassFileDir()

    set vars("ReactAppName") = "faqedit"

    set vars("VectorSearch") = ##class(KB.Config).getVectorSearch()

    do ..setup(.vars,3)
}

ClassMethod getVersion() As %String
{
	quit "1.0.027"
}

}
