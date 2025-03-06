Class FAQ.RestAPI Extends %CSP.REST
{

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
  <Route Url="/TopicSave" Method="POST" Call="FAQ.RestAPI:TopicSave"/>
  <Route Url="/Login/:username/:password" Method="GET" Call="FAQ.RestAPI:SLogin"/>
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
  
  try  {
	
    if $data(%request) {
      set %response.ContentType="application/json"
      set %response.CharSet = "utf-8"
    }

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
    set sql = "SELECT id,title from kb.topic where Completed=1 and Visible=1 and DeleteFlg!=1 order by id"
  }
  else {
    set sql = "SELECT id,title from kb.topic where (%ID %FIND Search_Index(DescriptionIndex1,(?)) or %ID %FIND Search_Index(TitleIndex1,(?))) and Completed=1 and Visible=1 and DeleteFlg!=1 order by id"
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
	  
    set sql = "SELECT id,title from kb.topic where Completed=1 and Visible=1 and DeleteFlg!=1 order by issuedate desc"
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
	
    if $data(%request) {
      set %response.ContentType="application/json"
      set %response.CharSet = "utf-8"
    }
    set pId=$translate(pId,$zzenkaku("0123456789"),"0123456789")
    set topic = ##class(KB.Topic).%OpenId(pId,,.status)	
    $$$ThrowOnError(status)  
    set return = {}
    set return.id = pId
    set return.Title = topic.Title
    set description = topic.Description
    set webserver = ##class(KB.Config).getWebServerAddress()
    set webserverport = ##class(KB.Config).getWebServerPort()
    set cspurl = ##class(KB.Config).getCSPUrl()
    set protocol = ##class(KB.Config).getWebServerProtocol()
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
          set fileUrl = protocol_"://"_webserver_":"_webserverport_cspurl_"/faq/images/"_filename_"."_fileext
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

    }
    else {

      set Id=$translate(json.Id,$zzenkaku("0123456789"),"0123456789")
      set topic = ##class(KB.Topic).%OpenId(Id,,.status)	
      $$$ThrowOnError(status)  

    }

    set topic.Title =json.Title
    set topic.Description =json.Description
    if (+json.ProductId > 0) {
      set product = ##class(KB.Product).%OpenId(json.ProductId)
      set topic.Product = product
    }
    set topic.Facility = json.Facility
    set topic.Platform = json.Platform
    set topic.StartVersion = json.StartVersion
    set topic.EndVersion = json.EndVersion
    set topic.RefTopic = json.RefTopic
    set topic.Completed = json.Completed
    set topic.DeleteFlg = json.DeleteFlg
    set topic.Visible = json.Visible
    set topic.DCURL = json.DCURL
    set topic.Note = json.Note

  }
  catch e {
		
    set status = e.AsStatus()
    do ##class(FAQ.Error).StoreErrorInformation(e)
		
  }
  
  quit status
}

ClassMethod TopicGetForEdit(pId As %Integer) As %Status
{
  set status = $$$OK

  try {
	
    if $data(%request) {
      set %response.ContentType="application/json"
      set %response.CharSet = "utf-8"
    }
    set pId=$translate(pId,$zzenkaku("0123456789"),"0123456789")
    set topic = ##class(KB.Topic).%OpenId(pId,,.status)	
    $$$ThrowOnError(status)  
    set return = {}
    set return.id = pId
    set return.Title = topic.Title
    set description = topic.Description
    set webserver = ##class(KB.Config).getWebServerAddress()
    set webserverport = ##class(KB.Config).getWebServerPort()
    set cspurl = ##class(KB.Config).getCSPUrl()
    set protocol = ##class(KB.Config).getWebServerProtocol()
    set replacetext = protocol_"://"_webserver_":"_webserverport_cspurl_"/images"
    set description = $replace(description,"./images",replacetext)
    set return.Description = description
    set reftopics = topic.RefTopic
    set filename = ##class(KB.Config).getAttachedFileName()_pId_".zip"
    set dir = ##class(KB.Config).getFTPDirectory()
    set sep = ##class(KB.Config).getDirectorySeparator()
    set filepath = dir_sep_filename
    set fileexists = ##class(%File).Exists(filepath)    
    set return.FileFlg = fileexists
    set return.FilePath = filepath
    set return.DownloadFile =  protocol_"://"_webserver_":"_webserverport_cspurl_"/downloads/"_##class(KB.Config).getAttachedFileName()_pId_".zip"
    set return.DCURL = topic.DCURL
    if $isobject(topic.Product) {
      set return.ProductId = topic.Product.ProductId
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
      set return.StartVersionid = topic.StartVersion.%Id()	   
      set return.StartVersion = topic.StartVersion.ExternalVersion
    }
    if $isobject(topic.EndVersion) {
      set return.EndVersionid = topic.EndVersion.%Id()	   
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
    set return.updatehistory = updatehistory
    write return.%ToJSON()
	  	  
  }
  catch e {
		
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
	  
    set sql = "SELECT productid,productname from kb.product"
    set statemt=##class(%SQL.Statement).%New()
    set status=statemt.%Prepare(sql)
    set rset=statemt.%Execute()
    set return = []
    while rset.%Next()  {
      set robj = {}
      set robj.productid = rset.%Get("productid")
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

ClassMethod SLogin(pUsername As %String, pPassword As %String) As %Status
{
  set status = $$$OK

  try {
	
    if $data(%request) {
      set %response.ContentType="application/json"
      set %response.CharSet = "utf-8"
    }

    set success = $SYSTEM.Security.Login(pUsername,pPassword)

    set return = {}
    set return.edit = success

    write return.%ToJSON()
	  	  
  }
  catch e {
		
    set status = e.AsStatus()
    do ##class(FAQ.Error).StoreErrorInformation(e)
		
  }
  
  quit status
}

Parameter HandleCorsRequest = 1;

}
