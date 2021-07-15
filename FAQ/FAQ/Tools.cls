Class FAQ.Tools Extends %Library.Base
{

ClassMethod ListURLsInTopics() As %Status
{
    set status = $$$OK
    
	Set query = ##class(%SQL.Statement).%New()
	set status = query.%PrepareClassQuery("KB.Topic","Extent")
	if $$$ISERR(status) { do $system.OBJ.DisplayError(status) Quit} 
	set rs = query.%Execute()
	while rs.%Next() {
	  set id = rs.%Get("ID")
	  set topic = ##class(KB.Topic).%OpenId(id)
	  set status = ##class(KB.Utility).PickupURLs(topic.Description,.URLs)
	  for i = 1:1:URLs {
	    if i = 1 write !,"Topic id = ",id,!!
	    write URLs(i),!!
	  } 
	}
	  
    quit status
  }

ClassMethod URLsExistingTest() As %Status
{
    set status = $$$OK
    
	Set query = ##class(%SQL.Statement).%New()
	set status = query.%PrepareClassQuery("KB.Topic","Extent")
	if $$$ISERR(status) { do $system.OBJ.DisplayError(status) Quit} 
	set rs = query.%Execute()
	while rs.%Next() {
	  set id = rs.%Get("ID")
	  set topic = ##class(KB.Topic).%OpenId(id)
	  set status = ##class(KB.Utility).PickupURLs(topic.Description,.URLs)
	  for i = 1:1:URLs {
	    if i = 1 write !,"Topic id = ",id,!!
	    set status = ..httprequest(URLs(i))
	  }
	  
    }
    quit status
  }
    
ClassMethod ReplaceTextInTopics(pTargetText As %String, pReplaceText As %String) As %Status
{
    set status = $$$OK
    
	Set query = ##class(%SQL.Statement).%New()
	set status = query.%PrepareClassQuery("KB.Topic","Extent")
	if $$$ISERR(status) { do $system.OBJ.DisplayError(status) Quit} 
	set rs = query.%Execute()
	while rs.%Next() {
	  set id = rs.%Get("ID")
	  set topic = ##class(KB.Topic).%OpenId(id)
	  set topic.Description = $replace(topic.Description,pTargetText,pReplaceText)
	  set status = topic.%Save()
	}
	  
    quit status
  }

ClassMethod httprequest(pUrl As %String, pPort As %Integer = 80) As %Status
{
    set status = $$$OK

	set protocol = $piece(pUrl,":")
	set https = $select(protocol="https":1,1:0)
	set server = $piece(pUrl,"/",3)
	set url = $piece(pUrl,"/",4,*)
	set params = $piece(url,"?",2)
	if params'="" {
	  for i = 1:1:$length(params,"&amp;") {
	    set kv= $piece(params,"&amp;",i)
	    set kv(i,"KEY") = $piece(kv,"=",1)
	    set kv(i,"VALUE") = $piece($piece(kv,"=",2),"#",1)
	    set kv = i
	  }
	}
	
	set url = $piece(url,"?",1)
	
	set searchtag = $piece(pUrl,"#",2)

	set httprequest=##class(%Net.HttpRequest).%New()
	
	set httprequest.Server = server
	set httprequest.Port = pPort
	if https set httprequest.Port = 443
	set httprequest.Https = https
	set httprequest.SSLConfiguration = "FAQSSL"
	
	for i = 1:1:$get(kv) {
	  do httprequest.SetParam(kv(i,"KEY"),kv(i,"VALUE"))
	}
	
	set status = httprequest.Get(url)
	set statuscode = httprequest.HttpResponse.StatusCode
	if statuscode > 299 {
	   write !,pUrl,!
	   write "status code = ",statuscode,!
	}
	
	if statuscode = 200 {
	  write !,pUrl,!
	  write "status code = ",statuscode,!
	  set gzip = httprequest.HttpResponse.Data
	  set length = 360000
	  set contents = gzip.Read(.length,.status)
	  if contents [ "Missing or Invalid Document" write "No Section Name",!
	  if searchtag '="" {
	     if contents '[ searchtag write "No Keyword ",searchtag,!
	  }
	}
	
	if (statuscode = 301) || (statuscode = 302) || (statuscode = 303) {
	   write !,pUrl,!
	   write "status code = ",statuscode,!
	   set redirect = httprequest.HttpResponse.GetHeader("LOCATION")
	   set status = ..httprequest(redirect,pPort)
    }
    
    quit status
  }

}