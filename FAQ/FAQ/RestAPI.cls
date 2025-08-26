Class FAQ.RestAPI Extends %CSP.REST
{

// POSTデータに日本語(UTF8)が含まれるためこのパラネータ設定が必要

Parameter CONVERTINPUTSTREAM = 1;

XData UrlMap
{
<Routes>
  <Route Url="/UpdateTopicProperty" Method="POST" Call="UpdateTopicProperty"/>
  <Route Url="/TopicSearchByKeyword/:keyword" Method="GET" Call="FAQ.RestAPI:TopicSearchByKeyword"/>
  <Route Url="/TopicGetById/:id" Method="GET" Call="FAQ.RestAPI:TopicGetById"/>
  <Route Url="/TopicSearchByNew" Method="GET" Call="FAQ.RestAPI:TopicSearchByNew"/>
  <Route Url="/ImageUpload" Method="POST" Call="FAQ.RestAPI:ImageUpload"/>
  <Route Url="/TopicGetForEdit/:id" Method="GET" Call="FAQ.RestAPI:TopicGetForEdit"/>
  <Route Url="/ProductGet" Method="GET" Call="FAQ.RestAPI:ProductGet"/>
  <Route Url="/FacilityGet" Method="GET" Call="FAQ.RestAPI:FacilityGet"/>
  <Route Url="/PlatformGet" Method="GET" Call="FAQ.RestAPI:PlatformGet"/>
  <Route Url="/VersionGet" Method="GET" Call="FAQ.RestAPI:VersionGet"/>
  <Route Url="/UpdateHistoryGet" Method="GET" Call="FAQ.RestAPI:UpdateHistryGet"/>
  <Route Url="/TopicSave" Method="POST" Call="FAQ.RestAPI:TopicSave"/>
  <Route Url="/Login/:username/:password" Method="GET" Call="FAQ.RestAPI:SLogin"/>
  <Route Url="/AttachedUpload/:id" Method="POST" Call="FAQ.RestAPI:AttachedUpload"/>
  <Route Url="/DeleteAttached/:id" Method="GET" Call="FAQ.RestAPI:DeleteAttached"/>
  <Route Url="/TopicVectorSearch" Method="POST" Call="FAQ.RestAPI:TopicVectorSearch"/>
</Routes>
}

ClassMethod UpdateTopicProperty() As %Status
{
  set status = $$$OK
  set tPropertyArray = %request.Content
  
  set status = ##class(KB.Topic).UpdatePropertyOfMultipleTopics(tPropertyArray)
  
  quit status
}

ClassMethod TopicSearchByKeyword(pKeyword As %String) As %Status
{
  set status = $$$OK
  // 検索キーワードが未入力の場合、nullという文字列で渡ってくる
  if pKeyword = "znull" set pKeyword = "z"

  if ($roles [ "FAQAdministrator") || ($roles [ "FAQEditor") {
    set editor = 1
  } 
  else {
    set editor = 0
  }
  
  try  {
	
    if $data(%request) {
      set %response.ContentType="application/json"
      set %response.CharSet = "utf-8"
    }

    //RESTインタフェースの制約で入力なしでも先頭にzをつけることで回避
    set pKeyword = $extract(pKeyword,2,*)

    // キーワードが(または)で終わる場合、検索エラーとなる問題に対処する
    set pKeyword = $replace($replace(pKeyword,"("," "),")"," ")
 
    // 検索文字列にNOT, AND, ORが含まれるときには¥を前置してエスケープする
    for i = 1:1:$length(pKeyword, " ") {
      set key(i) = $piece(pKeyword," ",i)
      if ($zcvt(key(i),"U") = "NOT") || ($zcvt(key(i),"U") = "AND") || ($zcvt(key(i),"U") = "OR") {
      set key(i) = "¥"_key(i)
    }  
  }

  for j = 1:1:i {
    set ifindkey = $get(ifindkey)_" "_key(j)
  }

  if pKeyword = "" {
    if editor {
      set sql = "SELECT id,title from kb.topic order by id"  
    }	
    else {
      set sql = "SELECT id,title from kb.topic where Completed=1 and Visible=1 and DeleteFlg!=1 order by id"
    }  
  }
  else {
    if editor {
      set sql = "SELECT id,title from kb.topic where (%ID %FIND Search_Index(DescriptionIndex1,(?)) or %ID %FIND Search_Index(TitleIndex1,(?))) order by id"
    }
    else {
      set sql = "SELECT id,title from kb.topic where (%ID %FIND Search_Index(DescriptionIndex1,(?)) or %ID %FIND Search_Index(TitleIndex1,(?))) and Completed=1 and Visible=1 and DeleteFlg!=1 order by id"
    }
    
  }

  set statemt=##class(%SQL.Statement).%New()
  set status=statemt.%Prepare(sql)
  if sql [ "?" {
    set rset=statemt.%Execute(ifindkey,ifindkey)
  }
  else {
    set rset=statemt.%Execute()
  }
  set return = []
  while rset.%Next()  {
    set robj = {}
    set robj.id = rset.%Get("Id")
    set robj.title = rset.%Get("title")
    do return.%Push(robj)
		    
  }
	   
  write return.%ToJSON()
	  	  
  }
  catch e {
		
    set status = e.AsStatus()
		
  }
  
  quit status
}

ClassMethod TopicSearchAll() As %Status
{
  set status = $$$OK
  
  try  {
	
    if $data(%request) {
      set %response.ContentType="application/json"
      set %response.CharSet = "utf-8"
    }
	  
    set sql = "SELECT id,title from kb.topic"
    set statemt=##class(%SQL.Statement).%New()
    set status=statemt.%Prepare(sql)
    set rset=statemt.%Execute()
    set return = []
    while rset.%Next()  {
      set robj = {}
      set robj.id = rset.%Get("Id")
      set robj.title = rset.%Get("title")
      do return.%Push(robj)
		    
     }
	   
     write return.%ToJSON()
	  	  
  }
  catch e {
		
    set status = e.AsStatus()
		
  }
  
  quit status
}

ClassMethod TopicSearchByNew() As %Status
{
  set status = $$$OK
  
  try  {
	
    if $data(%request) {
      set %response.ContentType="application/json"
      set %response.CharSet = "utf-8"
    }
	  
    set sql = "SELECT id,title from kb.topic where Completed=1 and Visible=1 and DeleteFlg!=1 order by id desc"
    set statemt=##class(%SQL.Statement).%New()
    set status=statemt.%Prepare(sql)
    set rset=statemt.%Execute()
    set return = []
    while rset.%Next()  {
      set robj = {}
      set robj.id = rset.%Get("Id")
      set robj.title = rset.%Get("title")
      do return.%Push(robj)
		    
     }
	   
     write return.%ToJSON()
	  	  
  }
  catch e {
		
    set status = e.AsStatus()
		
  }
  
  quit status
}

ClassMethod TopicGetById(pId As %Integer) As %Status
{
  set status = $$$OK

  try {
	
    set webserver = ##class(KB.Config).getWebServerAddress()
    set webserverport = ##class(KB.Config).getWebServerPort()
    set cspurl = ##class(KB.Config).getCSPUrl()
    set protocol = ##class(KB.Config).getWebServerProtocol()

    if $data(%request) {
      set %response.ContentType="application/json"
      set %response.CharSet = "utf-8"
      set webserver = %request.CgiEnvs("SERVER_NAME")
      set webserverport = %request.CgiEnvs("SERVER_PORT")
      if %request.CgiEnvs("SERVER_PORT_SECURE") {
        set protocol = "https"
      }
      else {
        set protocol = "http"
      }
    }

    set pId=$translate(pId,$zzenkaku("0123456789"),"0123456789")
    set topic = ##class(KB.Topic).%OpenId(pId,,.status)	
    $$$ThrowOnError(status)  
    set return = {}
    set return.id = pId
    set return.Title = topic.Title
    set description = topic.Description
    set replacetext = protocol_"://"_webserver_":"_webserverport_cspurl_"/images"
    set description = $replace(description,"./images",replacetext)
    set return.Description = description
    set reftopics = topic.RefTopic
    set refarray = []
    for i = 1:1:$length(reftopics,",") {
      set refno = $piece(reftopics,",",i)
      if refno = "" quit
      set reftopic = ##class(KB.Topic).%OpenId(refno)
      do refarray.%Push(refno_","_reftopic.Title)
    }
    set return.RefArray = refarray
    set filename = ##class(KB.Config).getAttachedFileName()_pId_".zip"
    set dir = ##class(KB.Config).getFTPDirectory()
    set sep = ##class(KB.Config).getDirectorySeparator()
    set filepath = dir_sep_filename
    set fileexists = ##class(%File).Exists(filepath)    
    set return.FileFlg = fileexists
    set return.DownloadFile =  protocol_"://"_webserver_":"_webserverport_cspurl_"/downloads/"_##class(KB.Config).getAttachedFileName()_pId_".zip"
    set return.DCURL = topic.DCURL
    set return.ProductText = ##class(%CSP.Page).UnescapeHTML(##class(KB.Utility).ProductText(topic.Product.ProductId))
    set return.VersionRange = topic.VersionRange	   
    write return.%ToJSON()
	  	  
  }
  catch e {
		do e.Log()
    set status = e.AsStatus()
    do ##class(FAQ.Error).StoreErrorInformation(e)
		
  }
  
  quit status
}

ClassMethod ImageUpload() As %Status
{
	set sts=$$$OK

    try {

      set webserver = ##class(KB.Config).getWebServerAddress()
      set webserverport = ##class(KB.Config).getWebServerPort()
      set cspurl = ##class(KB.Config).getCSPUrl()
      set protocol = ##class(KB.Config).getWebServerProtocol()
      set upload = $get(%request.MimeData("upload",1))

      if upload'="" {
	      set fileext = $piece(upload.FileName,".",2)
	      set filename = $translate($translate($zdatetime($zts,8)," ",""),":","")
	      set filepath = ##class(KB.Config).getCSPDirectory()_##class(KB.Config).getDirectorySeparator()_"images"_##class(KB.Config).getDirectorySeparator()_filename_"."_fileext
        set stream=##class(%Stream.FileBinary).%New()
        do stream.FilenameSet(filepath)
	      set st = stream.CopyFrom(upload)
	      set st = stream.%Save()
	
	      if st=$$$OK {
          set fileUrl = protocol_"://"_webserver_":"_webserverport_cspurl_"/images/"_filename_"."_fileext
          set funcNum = %request.Get("CKEditorFuncNum",1)
          set message = "ファイルがアップロードされました。"
          write "<script language=javascript>"
          &javascript<window.parent.CKEDITOR.tools.callFunction(#(funcNum)#,'#(fileUrl)#','#(message)#');>
          write "</script>"
	      } 
        else {

          $$$ThrowOnError(st)
		
	      }
      }

    } 
    catch ex {
      set sts=ex.AsStatus()
    }
    quit sts
}

ClassMethod TopicSave() As %Status
{
  set status = $$$OK
  try {
	
    if $data(%request) {
      set %response.ContentType="application/json"
      set %response.CharSet = "utf-8"
    }

    set len = 1000000
		set jsontext = %request.Content.Read(.len,.status)
		set json = {}.%FromJSON(jsontext)
    set new = json.New

    if new {

      set topic = ##class(KB.Topic).%New()
      set topic.IssueDate = +$h
      set topic.Creator=$username

    }
    else {

      //全角数字の入力もOKにする
      set Id=$translate(json.Id,$zzenkaku("0123456789"),"0123456789")
      set topic = ##class(KB.Topic).%OpenId(Id,,.status)	
      $$$ThrowOnError(status)
      set topic.UpdateDate = +$h
      set topic.Updater=$username

    }

    set topic.Title =json.Title
    set topic.Description =json.Description
    if (+json.ProductId > 0) {
      set product = ##class(KB.Product).%OpenId(json.ProductId)
      set topic.Product = product
    }
    if (+json.FacilityId > 0) {
      set facility = ##class(KB.Facility).%OpenId(json.FacilityId)
      set topic.Facility = facility
    }
    else {
      set topic.Facility = ""
    }
    if (+json.PlatformId > 0) {
      set platform = ##class(KB.Platform).%OpenId(json.PlatformId)
      set topic.Platform = platform
    }
    else {
      set topic.Platform = ""
    }
    if (+json.StartVersionId > 0) {
      set version = ##class(KB.Version).%OpenId(json.StartVersionId)
      set topic.StartVersion = version
    }
    else {
      set topic.StartVersion = ""
    }
    if (+json.EndVersionId > 0) {
      set version = ##class(KB.Version).%OpenId(json.EndVersionId)
      set topic.EndVersion = version
    }
    else {
      set topic.EndVersion = ""
    }
    set topic.RefTopic = json.RefTopic
    set topic.Completed = json.Completed
    set topic.DeleteFlg = json.DeleteFlg
    set topic.Visible = json.Visible
    set topic.DCURL = json.DCURL
    set topic.Note = json.Note

    if 'new {
      set uhistory=##class(KB.UpdateHistory).%New()
      set uhistory.Description=json.UpdateDescription
      set uhistory.UpdateDate=$zdatetime($h,3,2)
      set uhistory.Updater=$username
      set uhistory.Topic=topic
      set st=uhistory.%Save()
      $$$ThrowOnError(st)
    }

    set st = topic.%Save()
    $$$ThrowOnError(st)

  }
  catch e {
    do e.Log()
    set status = e.AsStatus()
    do ##class(FAQ.Error).StoreErrorInformation(e)
		
  }
  
  quit status
}

ClassMethod TopicGetForEdit(pId As %Integer) As %Status
{
  set status = $$$OK

  try {
	
    set webserver = ##class(KB.Config).getWebServerAddress()
    set webserverport = ##class(KB.Config).getWebServerPort()
    set cspurl = ##class(KB.Config).getCSPUrl()
    set protocol = ##class(KB.Config).getWebServerProtocol()

  if $data(%request) {
      set %response.ContentType="application/json"
      set %response.CharSet = "utf-8"
      set webserver = %request.CgiEnvs("SERVER_NAME")
      set webserverport = %request.CgiEnvs("SERVER_PORT")
      if %request.CgiEnvs("SERVER_PORT_SECURE") {
        set protocol = "https"
      }
      else {
        set protocol = "http"
      }
    }
    //全角数字の入力もOKにする
    set pId=$translate(pId,$zzenkaku("0123456789"),"0123456789")
    set topic = ##class(KB.Topic).%OpenId(pId,,.status)	
    $$$ThrowOnError(status)  
    set return = {}
    set return.id = pId
    set return.Title = topic.Title
    set description = topic.Description
    set replacetext = protocol_"://"_webserver_":"_webserverport_cspurl_"/images"
    set description = $replace(description,"./images",replacetext)
    set return.Description = description
    set reftopics = topic.RefTopic
    set return.RefTopics = reftopics
    set return.FileName = ""
    set filename = ##class(KB.Config).getAttachedFileName()_pId_".zip"
    set dir = ##class(KB.Config).getFTPDirectory()
    set sep = ##class(KB.Config).getDirectorySeparator()
    set filepath = dir_sep_filename
    set fileexists = ##class(%File).Exists(filepath)
    if fileexists set return.FileName = filename        
    set return.FileFlg = fileexists
    set return.FilePath = filepath
    set return.DownloadFile =  protocol_"://"_webserver_":"_webserverport_cspurl_"/downloads/"_##class(KB.Config).getAttachedFileName()_pId_".zip"
    set return.DCURL = topic.DCURL
    if $isobject(topic.Product) {
      set return.ProductId = topic.Product.%Id()
      set return.ProductName = topic.Product.ProductName
    }
    if $isobject(topic.Facility) {
      set return.FacilityId = topic.Facility.%Id()
      set return.FacilityName = topic.Facility.Description
    }
    if $isobject(topic.Platform) {
      set return.PlatformId = topic.Platform.%Id()
      set return.PlatformName = topic.Platform.Name
    }
    if $isobject(topic.StartVersion) {
      set return.StartVersionId = topic.StartVersion.%Id()	   
      set return.StartVersion = topic.StartVersion.ExternalVersion
    }
    if $isobject(topic.EndVersion) {
      set return.EndVersionId = topic.EndVersion.%Id()	   
      set return.EndVersion = topic.EndVersion.ExternalVersion
    }

    set return.Note = topic.Note
    set return.Completed = topic.Completed
    set return.DeleteFlg = topic.DeleteFlg
    set return.Visible = topic.Visible
    set updatehistory = []
    for i = 1:1:topic.UpdateDetail.Count() {
      set line = {}
      set line.UpdateDate = topic.UpdateDetail.GetAt(i).UpdateDate
      set line.Updater = topic.UpdateDetail.GetAt(i).Updater
      set line.Description = topic.UpdateDetail.GetAt(i).Description
      do updatehistory.%Push(line)
    }
    set return.UpdateHistory = updatehistory
    set return.NewUpdateDate = $zdatetime($h,3,2)
    set return.NewUpdater = $username
    set return.Admin = 0
    set return.Creator = topic.Creator
    if $roles [ "FAQAdministrator" set return.Admin = 1
    write return.%ToJSON()
	  	  
  }
  catch e {
		
    do e.Log()
    set status = e.AsStatus()
    do ##class(FAQ.Error).StoreErrorInformation(e)
		
  }
  
  quit status
}

ClassMethod ProductGet() As %Status
{
  set status = $$$OK
  
  try  {
	
    if $data(%request) {
      set %response.ContentType="application/json"
      set %response.CharSet = "utf-8"
    }
	  
    set sql = "SELECT id,productname from kb.product"
    set statemt=##class(%SQL.Statement).%New()
    set status=statemt.%Prepare(sql)
    set rset=statemt.%Execute()
    set return = []
    set robj = {}
    set robj.productid = ""
    set robj.productname = ""
    do return.%Push(robj)
    while rset.%Next()  {
      set robj = {}
      set robj.productid = rset.%Get("id")
      set robj.productname = rset.%Get("productname")
      do return.%Push(robj)
		    
     }
	   
     write return.%ToJSON()
	  	  
  }
  catch e {
		
    set status = e.AsStatus()
		
  }
  
  quit status
}

ClassMethod FacilityGet() As %Status
{
  set status = $$$OK
  
  try  {
	
    if $data(%request) {
      set %response.ContentType="application/json"
      set %response.CharSet = "utf-8"
    }
	  
    set sql = "SELECT id,description from kb.facility"
    set statemt=##class(%SQL.Statement).%New()
    set status=statemt.%Prepare(sql)
    set rset=statemt.%Execute()
    set return = []
    set robj = {}
    set robj.id = ""
    set robj.description = ""
    do return.%Push(robj)
    while rset.%Next()  {
      set robj = {}
      set robj.id = rset.%Get("id")
      set robj.description = rset.%Get("description")
      do return.%Push(robj)
		    
     }
	   
     write return.%ToJSON()
	  	  
  }
  catch e {
		
    set status = e.AsStatus()
		
  }
  
  quit status
}

ClassMethod PlatformGet() As %Status
{
  set status = $$$OK
  
  try  {
	
    if $data(%request) {
      set %response.ContentType="application/json"
      set %response.CharSet = "utf-8"
    }
	  
    set sql = "SELECT id,name from kb.platform"
    set statemt=##class(%SQL.Statement).%New()
    set status=statemt.%Prepare(sql)
    set rset=statemt.%Execute()
    set return = []
    set robj = {}
    set robj.id = ""
    set robj.name = ""
    do return.%Push(robj)
    while rset.%Next()  {
      set robj = {}
      set robj.id = rset.%Get("id")
      set robj.name = rset.%Get("name")
      do return.%Push(robj)
		    
     }
	   
     write return.%ToJSON()
	  	  
  }
  catch e {
		
    set status = e.AsStatus()
		
  }
  
  quit status
}

ClassMethod VersionGet() As %Status
{
  set status = $$$OK
  
  try  {
	
    if $data(%request) {
      set %response.ContentType="application/json"
      set %response.CharSet = "utf-8"
    }
	  
    set sql = "SELECT id,externalversion from kb.version"
    set statemt=##class(%SQL.Statement).%New()
    set status=statemt.%Prepare(sql)
    set rset=statemt.%Execute()
    set return = []
    set robj = {}
    set robj.id = ""
    set robj.version = ""
    do return.%Push(robj)
    while rset.%Next()  {
      set robj = {}
      set robj.id = rset.%Get("id")
      set robj.version = rset.%Get("externalversion")
      do return.%Push(robj)
		    
     }
	   
     write return.%ToJSON()
	  	  
  }
  catch e {
		
    set status = e.AsStatus()
		
  }
  
  quit status
}

ClassMethod UpdateHistoryGet(pId As %Integer) As %Status
{
  set status = $$$OK
  
  try  {
	
    if $data(%request) {
      set %response.ContentType="application/json"
      set %response.CharSet = "utf-8"
    }
	  
    set sql = "SELECT UpdateDate,Updater,Description FROM KB.UpdateHistory WHERE Topic = ?"
    set statemt=##class(%SQL.Statement).%New()
    set status=statemt.%Prepare(sql)
    set rset=statemt.%Execute(pId)
    set return = []
    while rset.%Next()  {
      set robj = {}
      set robj.updatedate = rset.%Get("UpdateDate")
      set robj.updater = rset.%Get("Updater")
      set robj.description = rset.%Get("Description")
      do return.%Push(robj)
		    
     }
	   
     write return.%ToJSON()
	  	  
  }
  catch e {
		
    set status = e.AsStatus()
		
  }
  
  quit status
}

ClassMethod SLogin(pUsername As %String, pPassword As %String) As %Status
{
  set status = $$$OK

  try {
	
    if $data(%request) {
      set %response.ContentType="application/json"
      set %response.CharSet = "utf-8"
    }

    set success = %session.Login(pUsername,pPassword)

    if ($roles [ "FAQAdministrator") || ($roles [ "FAQEditor") set edit = 1

    set return = {}
    set return.login = success
    set return.edit = $get(edit,0)

    write return.%ToJSON()
	  	  
  }
  catch e {
		
    set status = e.AsStatus()
    do ##class(FAQ.Error).StoreErrorInformation(e)
		
  }
  
  quit status
}

ClassMethod AttachedUpload(pId As %Integer) As %Status
{
	set sts=$$$OK

    try {

      if $data(%request) {

        set file = %request.NextMimeData("")
        set upload = %request.MimeData(file,1)

        if upload'="" {
          set filename=##class(KB.Config).getAttachedFileName()_pId_".zip"
	        set dir=##class(KB.Config).getFTPDirectory()
	        set sep=##class(KB.Config).getDirectorySeparator()
	        set filepath=dir_sep_filename
          set stream=##class(%Stream.FileBinary).%New()
          do stream.FilenameSet(filepath)
	        set st = stream.CopyFrom(upload)
	        set st = stream.%Save()
	
	        if $$$ERROR(st) {
            $$$ThrowOnError(st)
	        } 
        }

      }

    } 
    catch ex {
      do ex.Log()
      set sts=ex.AsStatus()
      do ##class(FAQ.Error).StoreErrorInformation(ex)
    }
    quit sts
}

ClassMethod DeleteAttached(pId As %Integer) As %Status
{
	set sts=$$$OK

    try {

        set filename=##class(KB.Config).getAttachedFileName()_pId_".zip"
	      set dir=##class(KB.Config).getFTPDirectory()
	      set sep=##class(KB.Config).getDirectorySeparator()
	      set filepath=dir_sep_filename
        set st=##class(%File).Delete(filepath)
	
	      if st=$$$OK {
	      } 
        else {

          $$$ThrowOnError(st)
		
	      }

    set return = {}
    set return.result = 1

    write return.%ToJSON()

    } 
    catch ex {
      do ex.Log()
      set sts=ex.AsStatus()
      do ##class(FAQ.Error).StoreErrorInformation(ex)
    }
    quit sts
}

ClassMethod TopicVectorSearch(pQueryText As %String) As %Status
{
  set status = $$$OK

  if ($roles [ "FAQAdministrator") || ($roles [ "FAQEditor") {
    set editor = 1
  } 
  else {
    set editor = 0
  }
  
  try  {
	
    if $data(%request) {
      set %response.ContentType="application/json"
      set %response.CharSet = "utf-8"
    }

    set len = 1000000
		set jsontext = %request.Content.Read(.len,.status)
		set json = {}.%FromJSON(jsontext)
    
    set queryText = json.queryText

    // 検索キーワードが未入力の場合、null,undefinedという文字列で渡ってくる
    if queryText = "null" set queryText = ""
    if queryText = "undefined" set queryText = ""
 
    set return = []

    if queryText = "" {
      write return.%ToJSON()
    }
    else {
      set QueryEmbedding =$tr(##class(KB.Topic).GetEmbedding(queryText)," '[]")

      if editor {
        set sql = "SELECT top 10 id,title from kb.topic order by vector_dot_product(DescriptionVector, TO_VECTOR(?, DOUBLE, 768)) desc"
      }
      else {
        set sql = "SELECT top 10 id,title from kb.topic where (Completed=1 and Visible=1 and DeleteFlg!=1) order by vector_dot_product(DescriptionVector, TO_VECTOR(?, DOUBLE, 768)) desc"
      }
    
      set statemt=##class(%SQL.Statement).%New()
      set status=statemt.%Prepare(sql)
      set rset=statemt.%Execute(QueryEmbedding)

      while rset.%Next()  {
        set robj = {}
        set robj.id = rset.%Get("Id")
        set robj.title = rset.%Get("title")
        do return.%Push(robj)
		    
      }
	   
      write return.%ToJSON()
    }  	  
  }
  catch e {
		
    set status = e.AsStatus()
		
  }
  
  quit status
}

Parameter HandleCorsRequest = 1;

}
