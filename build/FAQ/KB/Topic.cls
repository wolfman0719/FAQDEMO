Include FAQ

/// ナレッジベースのトピック
Class KB.Topic Extends (%Persistent, %XML.Adaptor) [ Inheritance = right ]
{

/// Topic ID(FAQサイトへの表示ID)
Property TopicID As %String [ Calculated, SqlComputeCode = { Set {TopicID}=##class(KB.Topic).ComputeTopicID({ID})}, SqlComputed ];

/// 一般的質問用のSubID
Property TopicSubID As %String;

/// 製品名 (Caché/Ensemble/一般)
Property Product As KB.Product;

/// カテゴリ
Property Category As KB.Category;

/// 機能区分
Property Facility As KB.Facility;

/// 表題
Property Title As %Text(COLLATION = "SQLUPPER", LANGUAGECLASS = "%TextJapanese", MAXLEN = 1000) [ Required ];

/// 内容
Property Description As %Text(COLLATION = "SQLUPPER", LANGUAGECLASS = "%TextJapanese", MAXLEN = 1000000);

/// 稼動プラットフォーム
Property Platform As KB.Platform;

/// 適用開始バージョン
Property StartVersion As KB.Version;

/// 適用終了バージョン
Property EndVersion As KB.Version;

/// 適用バージョン範囲
Property VersionRange As %String;

/// 添付ファイルフラグ
Property FileFlg As %Boolean [ InitialExpression = 0 ];

/// 関連・参考トピック
Property RefTopic As %String;

/// 特記事項
Property Note As %String(MAXLEN = "", XMLPROJECTION = "NONE");

/// 完成フラグ
Property Completed As %Boolean [ InitialExpression = 0 ];

/// 公開フラグ
Property Visible As %Boolean [ InitialExpression = 0 ];

/// 削除可フラグ
Property DeleteFlg As %Boolean [ InitialExpression = 0 ];

/// Web公開フラグ
Property WebFlg As %String [ InitialExpression = 0 ];

/// 作成日
Property IssueDate As %Date;

/// 作成者
Property Creator As %String(XMLPROJECTION = "NONE");

/// 更新日付
Property UpdateDate As %Date;

/// 更新者
Property Updater As %String(XMLPROJECTION = "NONE");

/// Web公開日
Property OpenDate As %Date;

/// 参照回数・アンケート結果（※別グローバルにするためオブジェクト参照化）
Property UsersVoice As KB.UsersVoice;

/// 更新履歴
Relationship UpdateDetail As KB.UpdateHistory [ Cardinality = children, Inverse = Topic ];

Index IndexIssueDate On IssueDate;

Index IndexTitle On Title;

Parameter XMLDEFAULTREFERENCE = "ID";

Index IndexVisible On Visible [ Type = bitmap ];

Index IndexCompleted On Completed [ Type = bitmap ];

Index TitleIndex1 On (Title) As %iFind.Index.Basic(INDEXOPTION = 0, LANGUAGE = "ja", LOWER = 1);

Index DescriptionIndex1 On (Description) As %iFind.Index.Basic(INDEXOPTION = 0, LANGUAGE = "ja", LOWER = 1);

Index CreatorIndex On Creator;

/// This callback method is invoked by the <METHOD>%Save</METHOD> method to 
/// provide notification that the object is being saved. It is called before 
/// any data is written to disk.
/// 
/// <P><VAR>insert</VAR> will be set to 1 if this object is being saved for the first time.
/// 
/// <P>If this method returns an error then the call to <METHOD>%Save</METHOD> will fail.
Method %OnBeforeSave(pInsert As %Boolean) As %Status [ Private, ServerOnly = 1 ]
{
	
	If pInsert {
		If (..Product.ProductId = $$$General) {
		   Set ..TopicSubID = ..GetCurTopicSubID()
		}
	}
	
	if $Get(%session)'=""{
		if pInsert {
			set ..Creator = $username
			set ..IssueDate = +$h
		}else {
			if $Get(%session.Data("noAudit"))'=1{
				set ..Updater = $username
				set ..UpdateDate = +$h
			}
		}
	}
	
	// 参照トピックリスト内に自分自身が入っていたら取り除く
	set ..RefTopic = ..RemoveRefNoForOwn(..RefTopic, ..%Id())
	// 参照トピックリスト内の重複を取り除く
	set ..RefTopic = ..RemoveDuplicatedRefNo(..RefTopic)
	
	//トピック内の参照イメージのurlを絶対パスから相対パスに変更する
	//データ本番移行の際、namespaceの違いを考慮する必要をなくすため
	
	set namespace = $ZCVT($namespace,"L")
	set apath = "/csp/"_namespace_"/images"
	set rpath = "./images"
	set ..Description = $replace(..Description,apath,rpath)
	
	Quit $$$OK
}

/// This callback method is invoked by the <METHOD>%Save</METHOD> method to 
/// provide notification that the object is being saved. It is called after 
/// the object's data has been successfully written to disk.
/// 
/// <P><VAR>insert</VAR> will be set to 1 if this object is being saved for the first time.
/// 
/// <P>If this method returns an error then the call to <METHOD>%Save</METHOD> will fail.
Method %OnAfterSave(pInsert As %Boolean) As %Status [ Private, ServerOnly = 1 ]
{
	set tSC = $$$OK
		
	Try {
	  if $Get(%session)'=""{
		  if pInsert {
    	      set message = "作成トピック "_..%Id()
			  // tSC = 0 となることがあるが、エラーとしない
        	  set tSC = $system.Security.Audit("FAQ","Create","Topic",message)
			
			  //UsersVoiceの新規セット
   			  set uv=##class(UsersVoice).%New()
			  set ..UsersVoice=uv
			  set uv.TopicId=..%Id()
		  }
		  else {
 			  if %session.Data("noAudit")'=1 {
				  set message = "修正トピック "_..%Id()
				  // tSC = 0 となることがあるが、エラーとしない
    	   		  set tSC = $system.Security.Audit("FAQ","Update","Topic",message)
 			  }
		  }		
	  }
	}
	Catch  tE {
		Set tSC = $$$OK
		Set tSC = tE.AsStatus()
		set tSC2 = ##class(FAQ.Error).StoreErrorInformation(tE)
	}
	
	If (tSC = 0) Set tSC = $$$OK  // tSC = 0はエラー扱いしない
	Quit tSC
}

ClassMethod GetCurTopicSubID() As %String
{
	quit $translate($justify($Increment(^TopicSubID),3)," ","0")
	//以下の方法は、アトミック性を確保できないことが判明
	//&sql(select max(TopicSubID) into :tTopicSubID from KB.Topic )
	//quit $Translate($justify($increment(tTopicSubID),3)," ",0)
}

ClassMethod ResetTopicSubID() As %Status
{
	set tSC = $$$OK
	&sql(select max(TopicSubID) into :tTopicSubID from KB.Topic )
	set ^TopicSubID = tTopicSubID
	quit $$$OK
}

ClassMethod DecrementTopicSubID() As %String
{
	quit $translate($justify($Increment(^TopicSubID,-1),3)," ","0")
}

ClassMethod ComputeTopicID(pId As %Integer) As %String
{
	Try {
	  set tTopic = ##class(KB.Topic).%OpenId(pId,,.tSC)
	  
	  If $IsObject(tTopic) {
		  If tTopic.Product.ProductId = $$$General {
			  set tTopicId = $Translate("G-"_$Justify(tTopic.TopicSubID,3)," ",0)
		  }
		  Else {
			  set tTopicId = $Translate($Justify(tTopic.%Id(),$$$TopicDigitsNo)," ",0)
	      }
	  }
	  Else {
		  $$$ThrowStatus(tSC)
	  }
	}
	catch tE {
		set tSC = ##class(FAQ.Error).StoreErrorInformation(tE)
	}
	quit $Get(tTopicId)
}

ClassMethod RemoveDuplicatedRefNo(pRefNoList As %String) As %String
{
	//関連Topicリスト内の重複Topicを取り除く
	
	if pRefNoList = "" quit ""
	
	for i = 1:1:$length(pRefNoList,",") {
	  set refno = $piece(pRefNoList,",",i)
	  set ref(refno) = ""
	}
	
	set node = "", newref = ""
	
	for {
	  set node = $order(ref(node))
	  if node = "" quit
	  set newref = newref_","_node
	}
	
	quit $extract(newref,2,*)
		
}

ClassMethod RemoveRefNoForOwn(pRefNoList As %String, pTopicId As %Integer) As %String
{
	//関連Topicリスト内の本トピックがある場合取り除く
	
	if pRefNoList = "" quit ""
	
	for i = 1:1:$length(pRefNoList,",") {
	  set refno = $piece(pRefNoList,",",i)
	  if refno '= pTopicId {
	    set ref(refno) = ""
	  }
	}
	
	set node = "", newref = ""
	
	for {
	  set node = $order(ref(node))
	  if node = "" quit
	  set newref = newref_","_node
	}
	
	quit $extract(newref,2,*)
		
}

Method RefCheckLink(pDebug As %Boolean) As %Status
{
	//相互リンクを行う
	
	//リンクをはずすためにtopic番号を削除した場合については考慮していない
	
	set tSC = $$$OK
	
	Try {
		
		  set tId = ..%Id()

		  set tRefTopic = ..RefTopic
		  				
		  if pDebug Write "tRefTopic = "_tRefTopic,!
		  
		  If '$Length(tRefTopic) Quit
		  
		  for i =1:1:$Length(tRefTopic,",") {
			  set tOtherId = $Piece(tRefTopic,",",i)
			  set tOther = ##class(KB.Topic).%OpenId(tOtherId,,.tSC)
			  if '$IsObject(tOther) $$$ThrowStatus(tSC)
			  set tFindFlag = 0
	          set tORefTopic = tOther.RefTopic
			  for j = 1:1:$Length(tORefTopic,",") {
			    if tId = $Piece(tORefTopic,",",j) set tFindFlag = 1
			  }
			  if pDebug Write "tFindFlag = "_tFindFlag,!
			  if 'tFindFlag {
			      if pDebug Write "tOther.RefTopic = "_tOther.RefTopic,!
				  set tOther.RefTopic = tOther.RefTopic_","_tId
			      if pDebug Write "tOther.RefTopic = "_tOther.RefTopic,!
				  if $extract(tOther.RefTopic) = "," Set tOther.RefTopic = $Extract(tOther.RefTopic,2,*)
			      if pDebug Write "tOther.RefTopic = "_tOther.RefTopic,!
				  $$$THROWONERROR(tSC,tOther.%Save())
			  }
		  }
	}
	Catch tE {
		Set tSC = tE.AsStatus()
		set tSC2 = ##class(FAQ.Error).StoreErrorInformation(tE)
	}
	Quit tSC
}

ClassMethod RemoveLink(pId As %Integer, pOldValue As %String, pNewValue As %String) As %Status
{
	//現在設定されているリンク番号を削除する場合、相手Topicからの参照をはずす必要がある
		
	set tSC = $$$OK	
	
	Try {
		
	    If (pOldValue = pNewValue) Quit
	    
	    If '$Length(pOldValue) Quit
	    	     
	    For i = 1:1:$Length(pOldValue,",") {
		    set id = $Piece(pOldValue,",",i)
		    if '(id?.n) $$$ThrowStatus(0)
	    }
	    
	    For i = 1:1:$Length(pNewValue,",") {
		    set id = $Piece(pNewValue,",",i)
		    if '(id?.n) $$$ThrowStatus(0)
	    }

	    For i = 1:1:$Length(pOldValue,",") {
		    Set tTopicId(i) = $Piece(pOldValue,",",i)
		    Set tNoFindFlag = 1
		    
		    //古い値にはあるが新しい値に含まれないidを探す
		    For j = 1:1:$Length(pNewValue,",") {
			    Set tTopicId = $Piece(pNewValue,",",j)
			    If (tTopicId(i) = tTopicId) Set tNoFindFlag = 0
		    }
		    
		    If tNoFindFlag {
			    Set tReferedTopic = ##class(KB.Topic).%OpenId(tTopicId(i))
			    Set tRefTopic = tReferedTopic.RefTopic
			    Set count = 0
			    //新しい値からその削除されたidを取り除く
			    For k = 1:1:$Length(tRefTopic,",") {
				    Set tRefTopic2 = $Piece(tRefTopic,",",k)
				    If (tRefTopic2 '= pId) {
					    Set count = count + 1
					    Set tNoRemovedRefTopic(count) = tRefTopic2
				    }
			    }
			    
			    For l = 1:1:count {
				    Set tNewRefTopic = $Get(tNewRefTopic)_","_tNoRemovedRefTopic(l)
			    }
			    Set tReferedTopic.RefTopic = $extract($Get(tNewRefTopic),2,*)
			    Set tSC = tReferedTopic.%Save()
                Do tReferedTopic.%Reload()
		    }
	    }
	}
	Catch tE {
		Set tSC = tE.AsStatus()
		set tSC2 = ##class(FAQ.Error).StoreErrorInformation(tE)
	}
	Quit tSC
}

/*
Method DescriptionGet() As %Text
{
 set crlf = $char(13,10)
 set gt = "&gt;"
 set lt = "&lt;"
 set Description = i%Description

 set Description = $replace(Description,"<command>",lt_"command"_gt)
 set Description = $replace(Description,"</command>",lt_"/command"_gt)
 set Description = $replace(Description,"<Command>",lt_"Command"_gt)
 set Description = $replace(Description,"</Command>",lt_"/Command"_gt)
 set Description = $replace(Description,"<COMMAND>",lt_"COMMAND"_gt)
 set Description = $replace(Description,"</COMMAND>",lt_"/COMMAND"_gt)

 set Description = $replace(Description,"<url>",lt_"url"_gt)
 set Description = $replace(Description,"</url>",lt_"/url"_gt)
 set Description = $replace(Description,"<Url>",lt_"Url"_gt)
 set Description = $replace(Description,"</Url>",lt_"/Url"_gt)
 set Description = $replace(Description,"<URL>",lt_"URL"_gt)
 set Description = $replace(Description,"</URL>",lt_"/URL"_gt)
 
 quit Description
}
*/

ClassMethod ChangeUrlPathForImages() {
   try {
     //ckeditorで追加したイメージは、絶対パスでhtmlに埋め込まれるため、本番移行、テスト移行等の際、ネームスペースが異なると表示されなくなるので、相対パスに変更する
     //今後は、トピックの保存の際、この変換を行うので、インストールの際には必要なくなる
     set sql = "select %ID,Description from KB.Topic where Description [ '/csp/knowledge/images/'"
     set newnamespace = $zcvt($namespace,"L")
     set statement = ##class(%SQL.Statement).%New()
     set status = statement.%Prepare(sql)
     if 'status $$$ThrowStatus(status)
     set rs = statement.%Execute()
     While rs.%Next() {
       set id = rs.%Get("ID")
       set topic = ##class(KB.Topic).%OpenId(id)
       set desc = topic.Description
       set topic.Description = $replace(desc,"/csp/knowledge/images/","./images/")
       set status = topic.%Save()
       if 'status $$$ThrowStatus(status)
      }
    }
    catch ex {
      set status = ##class(FAQ.Error).StoreErrorInformation(ex)  
    }	
}
    	
ClassMethod UpdatePropertyOfMultipleTopics(pTopicIdPropertyOBJ As %String) As %Status {
   try {
     //TopicId, PropertyペアのArrayを入力とし、該当するTopicのPropertyを更新する
     // Property = [Product,Category,Facility,Completed,Visible,DeleteFlg]
     //
     set status = $$$OK
     set DynamicOBJ = {}
     set DynamicOBJ = DynamicOBJ.%FromJSON(pTopicIdPropertyOBJ)
     set PropertyName = DynamicOBJ.PropertyName
     set DynamicArray = DynamicOBJ.KVArray
     set it = DynamicArray.%GetIterator()
     while it.%GetNext(.i,.do) {
       set topicid = do."topicid"
       set PropertyValue = do."PropertyValue" 
       set topic = ##class(KB.Topic).%OpenId(topicid,,.status)
       if 'status $$$ThrowStatus(status)
       if (PropertyName = "Product") || (PropertyName = "Category") || (PropertyName = "Facility") {
         set classname = "KB."_PropertyName
         set oref = $classmethod(classname,"%OpenId",PropertyValue,,.status)
         if '$isobject(oref) $$$ThrowStatus(status)
         set $Property(topic,PropertyName) = oref
       }
       else {
         set $Property(topic,PropertyName) = $select(PropertyValue=1:1,1:0)
       }
       set status = topic.%Save() 
       if 'status  $$$ThrowStatus(status)             
     }
    }
    catch ex {
      set exstatus = ##class(FAQ.Error).StoreErrorInformation(ex)  
    }	
    
    quit status
}

ClassMethod CopyFromTopics(pTopicIdList As %List, Output pNewTopicIdList As %List) As %Status {
   try {
     //パラメータpTopicIdListで指定されたtopicidのインスタンスをコピーして新しいトピックを生成する
     //新しいtopicidのリストを出力パラメータとして第2パラメータで返す
     //
     set status = $$$OK
     set pNewTopicIdList = ""
     for i = 1:1:$listlength(pTopicIdList) {
       set topicid = $list(pTopicIdList,i)
       set topic = ..%OpenId(topicid)
       if $isobject(topic) {
         set clone = topic.%ConstructClone(0)
         set status = clone.%Save(0)
         if 'status $$$ThrowStatus(status)
         set newid = clone.%Id()
         set $list(pNewTopicIdList,$listlength(pNewTopicIdList)+1) = newid
       }
     }
    }
    catch ex {
      set exstatus = ##class(FAQ.Error).StoreErrorInformation(ex)  
    }	
    
    quit status
}

Storage Default
{
<Data name="TopicDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TopicID</Value>
</Value>
<Value name="3">
<Value>Category</Value>
</Value>
<Value name="4">
<Value>Facility</Value>
</Value>
<Value name="5">
<Value>Title</Value>
</Value>
<Value name="6">
<Value>Description</Value>
</Value>
<Value name="7">
<Value>Platform</Value>
</Value>
<Value name="8">
<Value>Version</Value>
</Value>
<Value name="9">
<Value>FileFlg1</Value>
</Value>
<Value name="10">
<Value>FileLoc1</Value>
</Value>
<Value name="11">
<Value>FileFlg2</Value>
</Value>
<Value name="12">
<Value>FileLoc2</Value>
</Value>
<Value name="13">
<Value>FileFlg3</Value>
</Value>
<Value name="14">
<Value>FileLoc3</Value>
</Value>
<Value name="15">
<Value>Note</Value>
</Value>
<Value name="16">
<Value>Completed</Value>
</Value>
<Value name="17">
<Value>Visible</Value>
</Value>
<Value name="18">
<Value>DeleteFlg</Value>
</Value>
<Value name="19">
<Value>IssueDate</Value>
</Value>
<Value name="20">
<Value>Creator</Value>
</Value>
<Value name="21">
<Value>UpdateDate</Value>
</Value>
<Value name="22">
<Value>Updater</Value>
</Value>
<Value name="23">
<Value>CheckFlg</Value>
</Value>
<Value name="24">
<Value>WebFlg</Value>
</Value>
<Value name="25">
<Value>OldTopicID</Value>
</Value>
<Value name="26">
<Value>URL1</Value>
</Value>
<Value name="27">
<Value>URL2</Value>
</Value>
<Value name="28">
<Value>URL3</Value>
</Value>
<Value name="29">
<Value>StartVersion</Value>
</Value>
<Value name="30">
<Value>EndVersion</Value>
</Value>
<Value name="31">
<Value>EnqYes</Value>
</Value>
<Value name="32">
<Value>EnqNo</Value>
</Value>
<Value name="33">
<Value>RefTopic</Value>
</Value>
<Value name="34">
<Value>RefFreq</Value>
</Value>
<Value name="35">
<Value>RefTopicM</Value>
</Value>
<Value name="36">
<Value>FileFlg</Value>
</Value>
<Value name="37">
<Value>TestVersion</Value>
</Value>
<Value name="38">
<Value>VersionRange</Value>
</Value>
<Value name="39">
<Value>OpenDate</Value>
</Value>
<Value name="40">
<Value>Product</Value>
</Value>
<Value name="41">
<Value>TopicSubID</Value>
</Value>
<Value name="42">
<Value>UsersVoice</Value>
</Value>
</Data>
<DataLocation>^KB.TopicD</DataLocation>
<DefaultData>TopicDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^KB.TopicD</IdLocation>
<IndexLocation>^KB.TopicI</IndexLocation>
<StreamLocation>^KB.TopicS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
