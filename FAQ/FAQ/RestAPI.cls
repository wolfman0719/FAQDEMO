Class FAQ.RestAPI Extends %CSP.REST
{

XData UrlMap
{
<Routes>
  <Route Url="/UpdateTopicProperty" Method="POST" Call="UpdateTopicProperty"/>
  <Route Url="/TopicSearchByKeyword/:keyword" Method="GET" Call="FAQ.RestAPI:TopicSearchByKeyword"/>
  <Route Url="/TopicSearchAll" Method="GET" Call="FAQ.RestAPI:TopicSearchAll"/>
  <Route Url="/TopicGetById/:id" Method="GET" Call="FAQ.RestAPI:TopicGetById"/>
</Routes>
}

ClassMethod UpdateTopicProperty() As %Status
{
  set status = $$$OK
  set tPropertyArray = %request.Content
  
  set status = ##class(FAQ.Topic).UpdatePropertyOfMultipleTopics(tPropertyArray)
  
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
	  
    set sql = "SELECT id,title from kb.topic where %ID %FIND Search_Index(DescriptionIndex1,(?)) or %ID %FIND Search_Index(TitleIndex1,(?)) "
    set statemt=##class(%SQL.Statement).%New()
    set status=statemt.%Prepare(sql)
    set rset=statemt.%Execute(pKeyword,pKeyword)
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

ClassMethod TopicGetById(pId As %Integer) As %Status
{
  set status = $$$OK

  try {
	
    if $data(%request) {
      set %response.ContentType="application/json"
      set %response.CharSet = "utf-8"
    }

    set topic = ##class(KB.Topic).%OpenId(pId)	  
    set return = {}
    set return.id = pId
    set return.Title = topic.Title
    set return.Description = topic.Description
	   
    write return.%ToJSON()
	  	  
  }
  catch e {
		
    set status = e.AsStatus()
		
  }
  
  quit status
}

}
