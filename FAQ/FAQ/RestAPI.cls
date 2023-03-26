Class FAQ.RestAPI Extends %CSP.REST
{

XData UrlMap
{
<Routes>
  <Route Url="/UpdateTopicProperty" Method="POST" Call="UpdateTopicProperty"/>
  <Route Url="/QueryTopicByKeyword/:keyword" Method="GET" Call="QueryTopicByKeyword"/>
  <Route Url="/GetTopic/:id" Method="GET" Call="GetTopic"/>
</Routes>
}

ClassMethod UpdateTopicProperty() As %Status
{
  set status = $$$OK
  set tPropertyArray = %request.Content
  
  set status = ##class(FAQ.Topic).UpdatePropertyOfMultipleTopics(tPropertyArray)
  
  quit status
}

ClassMethod QueryTopicByKeyword(pKeyword As %String) As %Status
{
  set status = $$$OK

	try {
	
      if $data(%request) {
        set %response.ContentType="application/json"
	     set %response.CharSet = "utf-8"
	   }
	  
	  set sql = "select id,title from kb.topic where %ID %FIND search_index(DescriptionIndex1,?,0) "
	  set statemt=##class(%SQL.Statement).%New()
     set status=statemt.%Prepare(sql)
     set rset=statemt.%Execute(pKeyword)
     set return = []
	  while rset.%Next()  {
		  set robj = {}
		  set robj.id = rset.%Get("Id")
		  set robj.title = rset.%Get("Title")
		  do return.%Push(robj)
		    
	   }
	   
	   write return.%ToJSON()
	  	  
	   }
	   catch e {
		
		  set status = e.AsStatus()
		
	   }
  
  quit status
}

ClassMethod GetTopic(pId As %Integer) As %Status
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
