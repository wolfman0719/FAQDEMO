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

/// KB.Topicのインスタンスを全件読んで、ID,Facility,Titleをcsv形式でファイルに出力する
/// pFile : 出力するcsvファイル名
ClassMethod topicFacility2CSV(pFile As %String) As %Status
{
  set status = $$$OK

  try {
    set stream = ##class(%Stream.FileCharacter).%New()
    set stream.Filename = pFile
    set stream.TranslateTable = "UTF8"

    do stream.Write($char(65279))
    do stream.WriteLine("ID,Facility,Title")

    set statement = ##class(%SQL.Statement).%New()
    set status = statement.%Prepare("SELECT ID, Facility, Title FROM KB.Topic ORDER BY ID")
    if $$$ISERR(status) quit

    set rs = statement.%Execute()
    while rs.%Next() {
      set line = ..CSVField(rs.%Get("ID"))_","_..CSVField(rs.%Get("Facility"))_","_..CSVField(rs.%Get("Title"))
      do stream.WriteLine(line)
    }

    set status = stream.%Save()
  } catch ex {
    set status = ex.AsStatus()
  }

  quit status
}

/// CSVフィールド用にエスケープする（カンマ、ダブルクォート、改行を含む場合はクォートで囲む）
ClassMethod CSVField(pValue As %String) As %String [ Private ]
{
  set value = $get(pValue)
  if (value [ ",") || (value [ """") || (value [ $char(10)) || (value [ $char(13)) {
    set value = """"_$replace(value,"""","""""")_""""
  }
  quit value
}

/// 指定したcsvファイルを全件読んで、KB.TopicのFacilityを更新する
/// pFile : 入力csvファイル名（先頭行はヘッダー ID,Facility,Title）
ClassMethod topicFacilityUpdate(pFile As %String) As %Status
{
  set status = $$$OK

  try {
    set stream = ##class(%Stream.FileCharacter).%New()
    set status = stream.LinkToFile(pFile)
    if $$$ISERR(status) quit
    set stream.TranslateTable = "UTF8"

    // 先頭行（ヘッダー）を読み捨てる
    if 'stream.AtEnd do stream.ReadLine()

    set statement = ##class(%SQL.Statement).%New()
    set status = statement.%Prepare("UPDATE KB.Topic SET Facility = ? WHERE ID = ?")
    if $$$ISERR(status) quit

    while 'stream.AtEnd {
      set line = stream.ReadLine()
      if line = "" continue

      set id = ..CSVUnquote($piece(line,",",1))
      set facility = ..CSVUnquote($piece(line,",",2))
      if id = "" continue

      set rs = statement.%Execute(facility,id)
      if rs.%SQLCODE < 0 {
        write !,"Topic ID ",id," の更新に失敗しました（SQLCODE=",rs.%SQLCODE,"：",rs.%Message,"）",!
      } elseif rs.%ROWCOUNT = 0 {
        write !,"Topic ID ",id," が見つかりません",!
      }
    }
  } catch ex {
    set status = ex.AsStatus()
  }

  quit status
}

/// CSVフィールドのクォートを除去する（CSVField()の逆変換）
ClassMethod CSVUnquote(pValue As %String) As %String [ Private ]
{
  set value = $get(pValue)
  if ($extract(value,1) = """") && ($extract(value,*) = """") {
    set value = $extract(value,2,*-1)
    set value = $replace(value,"""""","""")
  }
  quit value
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
