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
Property Note As %String(MAXLEN = 1000, XMLPROJECTION = "NONE");

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

/// 同じ内容のDC(Developer Community)記事URL
Property DCURL As %String(MAXLEN = 100, XMLPROJECTION = "NONE");

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
    // Codesnippetの言語名を表示するための処理
	set crlf = $char(13,10)
	//二重に<div>を付加するのを防ぐ　ckeditorが自動的に<div>の後ろにcrlfを付加することを想定
	set ..Description = $replace(..Description,"<div class=""hljs-wrap"">"_crlf_"<pre>","<pre>")
	set ..Description = $replace(..Description,"</pre>"_crlf_"</div>","</pre>")
	set ..Description = $replace(..Description,"<pre>","<div class=""hljs-wrap""><pre>")
	set ..Description = $replace(..Description,"</pre>","</pre></div>")
	
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

ClassMethod ChangeUrlPathForImages()
{
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

ClassMethod UpdatePropertyOfMultipleTopics(pTopicIdPropertyOBJ As %String) As %Status
{
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

ClassMethod CopyFromTopics(pTopicIdList As %List, Output pNewTopicIdList As %List) As %Status
{
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
<Value name="43">
<Value>DCURL</Value>
</Value>
</Data>
<DataLocation>^KB.TopicD</DataLocation>
<DefaultData>TopicDefaultData</DefaultData>
<ExtentSize>537</ExtentSize>
<IdLocation>^KB.TopicD</IdLocation>
<IndexLocation>^KB.TopicI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,16,$lb("-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000"),$lb(21,21,21,21,21,21,21,21,21,21,21,21,21,21,21),$lb(758198320,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,758198320))</Histogram>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>3.48</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,0,$lb(12,16,75,147,199,234,244,251,259,276,319,325,337,429,436,502),$lb(1,0,0,1,0,1,1,2,1,0,1,1,0,1,0),$lb(825360384,838860800,905969664,825622528,926220288,926220288,825505536,876019712,960036864,825833728,842216448,859045888,875823104,875823104,892403712,822083584,956301312,892928000,926285824,842479104,858863872,825819136,842334208,842334208,859242496,858994432,875706624,842596352,859176960,875771392,892350976,892350976))</Histogram>
<Selectivity>1</Selectivity>
</Property>
<Property name="Category">
<AverageFieldSize>2.62</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,6,$lb("-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","1","1","1","1","1","1","1","5","5","5"),$lb(21,21,21,21,21,0,1,1,1,1,1,1,0,1,1),$lb(758198320,0,0,0,0,0,0,0,0,0,0,758198320,822083584,0,0,0,0,0,0,0,0,0,0,0,0,822083584,889192448,0,0,0,0,889192448))</Histogram>
<Selectivity>22.1574%</Selectivity>
</Property>
<Property name="Completed">
<AverageFieldSize>2.93</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1),$lb(1,0,1,1,1,1,1,1,1,1,1,1,1,1,1),$lb(805306368,0,0,805306368,822083584,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,822083584))</Histogram>
<OutlierSelectivity>.929577:1</OutlierSelectivity>
<Selectivity>7.0423%</Selectivity>
</Property>
<Property name="Creator">
<AverageFieldSize>6.68</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" "," "," "," "," "," FURUZONO"," KAKECHI"," KAKECHI"," SATO"," SATO"," YAMAMOTO"," YAMAMOTO"," 中橋"," 岩本、堀田"," 田中 歩"," 皆本,三浦"),$lb(2,2,2,2,1,1,9,1,6,1,10,1,1,1,1),$lb(536870912,0,0,0,0,0,0,0,0,0,1179996757,1179996757,1262570309,0,0,1262570309,1396790351,0,0,1396790351,1497451841,0,0,1497451841,3837308390,3837308390,3853691366,3853691366,3885281508,3885281508,3885663974,552049286))</Histogram>
<OutlierSelectivity>.323944:</OutlierSelectivity>
<Selectivity>3.7528%</Selectivity>
</Property>
<Property name="DeleteFlg">
<AverageFieldSize>2.2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1),$lb(1,1,1,1,1,1,1,1,1,1,1,0,1,1,1),$lb(805306368,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,805306368,822083584,0,0,0,0,0,0,822083584))</Histogram>
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="Description">
<AverageFieldSize>1954.28</AverageFieldSize>
<Histogram>
<![CDATA[$lb(.06666666666666666667,0,0,$lb(" "," <P>&NBSP;</P><P>シャドウイング関連の情報を取得するAPIが用意されています。<BR /><BR />ソースサーバ側の情報取得<BR /><BR />SYS.SHADOWING.DATASOURCE:CONNECTIONSク"," <P>CACH&EACUTE;ターミナルで文字化けが発生するのは、サーバ側の文字コードとクライアント(ターミナル)側の文字コード設定が異なる場合です。<BR /><BR />サーバ側の文字コードは、ターミナルで接続して $$GETIO^%"," <P>INTERSYSTEMS製品では、永続データは後で高速にランダムアクセスできるように、ある一定の規則に沿ってキー順にソートされて格納されます。<BR /><BR />新しいノードが追加された場合、ノードが削除された場合、データの長さ"," <P>JIS X5070は、ISO/IEC 15408と同一規格で、コンピュータセキュリティの国際規格です。<BR /><A HREF=""HTTPS://WWW.METI.GO.JP/POLICY/NETSECURITY/CC.HTML"""," <P>VISMクライアントを利用したアプリケーションにおいて、サーバ側スクリプト(CACH&EACUTE; OBJECTSCRIPT)で、スクリプトレベルのエラーが発生した場合、既定では、以下の動作となります。</P><UL>"_$c(9)_"<LI>ク"," <P>ZENレポートでAPACHE FOPを使用してPDFファイルを生成する際に、日本語フォントを使用するためには、CACH&EACUTE;のバージョンによっては、環境に応じた設定が必要です。<BR /><BR />【CACH&EACUT"," <P>はい、INTERSYSTEMSは製品に同梱する形でODBCドライバーを提供しています。</P><P>また、お客様のご要望に応じてODBCドライバー単体でも提供しています。</P><P>また、同様にJDBCタイプ４ドライバーも提供して"," <P>イベントビューアに以下のようなアプリケーションが出力された場合、これは内容的には「エラー」というより「情報」に近く、動作に問題はありません。<BR />----------------------------------------"," <P>クラス定義内、プロパティのデータタイプをSTREAM型で定義することで、イメージ情報を格納することができます。<BR /><BR />VB経由でアクセスする方法は、以下の通りです。<BR /><BR />CACH&EACUTE;にア"," <P>テーブルチューニングを行った際に、フィールドに値がほとんど登録されていない（NULL）場合や、特定の値がほとんどを占める場合、その値を [外れ値] として除外して選択性計算を行います。<BR /><BR />また、外れ値が全レコード"," <P>ユーザーが作成したクラス定義は、クラス定義クラスの中に格納されます。<BR /><BR />クラス定義一覧をプログラムから取得する方法として、「クラス定義クラス」を利用することができます。<BR />（クラス定義クラスとは、%DIC"," <P>何らかの理由でサーバー移行が必要になった際に、移行前の環境から移行後の環境に設定情報をコピーすることで設定作業を軽減できます。<BR /><BR />以下の設定情報を移行できます。</P><UL>"_$c(9)_"<LI>CACHE.CPF</LI"," <P>次のような CACHE.SERVICE ファイルを SYSTEMD/SYSTEM 以下におき、SYSTEMCTL ENABLE CACHE.SERVICE コマンドでサービス登録を行います。</P><P>/USR/LIB/SYSTE"," <P>詳細は、以下ドキュメントをご参照ください。<BR /><A HREF=""HTTPS://WWW.INTERSYSTEMS.COM/WP-CONTENT/UPLOADS/SITES/6/HIGH_AVAILABILITY_STRATE"," <UL>"_$c(9)_"<LI>ルーチン（*.MAC）の場合</LI></UL><P><BR />ルーチンの場合は、コンパイル後に生成される *.OBJ のみをエクスポート／インポートすることで、ソースの隠蔽化を実現できます。<BR /><BR />コ"),$lb(1,4,4,4,4,4,4,4,4,4,4,4,4,4,2),$lb(536870912,0,1011891750,642662995,1128350536,1128350536,1229870149,1229870149,1246319392,1246319392,1447646029,1447646029,1514491619,1514491619,3816927203,3816927203,3816989923,3816989923,3816992739,3816992739,3817047779,3817047779,3817055971,3817055971,3837629923,3837629923,3870073315,3870073315,3903435751,1346300073,1431059977,540824908))]]></Histogram>
<Selectivity>0.1862%</Selectivity>
</Property>
<Property name="EndVersion">
<AverageFieldSize>2.11</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,14,$lb("-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","6","13"),$lb(21,21,21,21,21,21,21,21,21,21,21,21,21,0,0),$lb(758198320,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,758198320,905969664,905969664,825425920,825425920))</Histogram>
<OutlierSelectivity>.901408:</OutlierSelectivity>
<Selectivity>3.5832%</Selectivity>
</Property>
<Property name="Facility">
<AverageFieldSize>3.54</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,0,$lb("1","1","1","3","4","4","7","11","11","11","11","11","11",12,"19","19"),$lb(1,1,0,0,1,0,0,2,2,2,2,2,1,1,2),$lb(822083584,0,0,0,0,822083584,855638016,855638016,872415232,0,0,872415232,922746880,922746880,825294848,0,0,0,0,0,0,0,0,0,0,822083584,838860800,838860800,956301312,0,0,825819136))</Histogram>
<OutlierSelectivity>.394366:11</OutlierSelectivity>
<Selectivity>6.0010%</Selectivity>
</Property>
<Property name="FileFlg">
<AverageFieldSize>2.07</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),$lb(1,1,1,1,1,1,1,1,1,1,1,1,1,0,1),$lb(805306368,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,805306368,822083584,0,0,822083584))</Histogram>
<OutlierSelectivity>.929577:0</OutlierSelectivity>
<Selectivity>7.0423%</Selectivity>
</Property>
<Property name="IssueDate">
<AverageFieldSize>4</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(59591,59596,59598,61124,61334,61607,61782,62329,62424,62528,62915,63012,63379,64462,64623,65387),$lb(4,4,0,2,2,2,1,2,2,2,1,2,1,2,1),$lb(892941625,822083584,905969664,905969664,939524096,892941625,909193522,825373696,858993664,858993664,909129472,909129472,926429696,825702450,842215993,858929408,875705344,875705344,892483584,892483584,959526144,842608949,858796338,808530432,859257088,858994489,875836978,875966976,909259520,875967027,892549175,909456184))</Histogram>
<Selectivity>1.7865%</Selectivity>
</Property>
<Property name="Note">
<AverageFieldSize>161.01</AverageFieldSize>
<Histogram>
<![CDATA[$lb(.06666666666666666667,0,0,$lb(" "," "," "," "," "," "," "," "," 2011/12/20 飯島　語尾を少し修正（丁寧から通常に）"_$c(13,10)_"2012.04.24(FAQADMIN/古薗)：タイトルに「。」"_$c(13,10)_"2013/4/10　飯島　ドキュメントのポイントが20101Jを敢えて指定します。（2010.2からCAC"," 2011/2/24 飯島　<URL>追加"," 2012/12/26　飯島新規追加"," 2019/2 IRIS用トピック：456　追加"_$c(13,10)_"CSPGATEWAYのインストールディレクトリが、バージョンにより異なっている為、"_$c(13,10)_"そのディレクトリを変数 CSPGTWDIR に定義するようにしました。"_$c(13,10)_"2011/12/28(古薗)"," VB6+CACHE5.0.5で動作確認"_$c(13,10)_"2011/2/23　<COMMAND>で例文をくくりました。"," 内容不十分"_$c(13,10)_"2011/8/22　飯島　追記したのはいいけど、長い・・"_$c(13,10)_"その後、2011.1対応佐藤さんチェック通過。"_$c(13,10)_"2011/9/29 完成済にチェックつけました。（飯島）"," 編集日付　2012/3/29"_$c(13,10)_"編集者名 三浦昌仁"_$c(13,10)_"編集内容"_$c(13,10)_"　変更前"_$c(13,10)_"　マシン名を変更した後再起動する際には、"_$c(13,10)_"　変更後"_$c(13,10)_"　マシン名を変更した後OSの再起動する際には、"_$c(13,10,13,10)_"2012.04.24(FAQADMIN/古薗)：タ"," ＊参考トピック＊"_$c(13,10)_"ID231：CACHÉのOSサポートバージョンについて教えてください"_$c(13,10)_"HTTP://WWW.INTERSYSTEMS.CO.JP/SUPPORT/FAQ/SYSTEM/INDEX.HTML#ID231"_$c(13,10,13,10)_"ID23"),$lb(2,2,2,2,2,2,2,1,6,4,4,1,1,1,1),$lb(536870912,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,842019121,825372466,841953844,825176623,841953586,841953586,959394336,842019129,1447179819,1447179819,3850798565,3850798565,3887573225,3887573225,4022110949,552582282))]]></Histogram>
<OutlierSelectivity>.521127:</OutlierSelectivity>
<Selectivity>0.1862%</Selectivity>
</Property>
<Property name="OpenDate">
<AverageFieldSize>2.79</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,9,$lb("-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000",62390,62390,62390,62390,62390,62390,62390),$lb(21,21,21,21,21,21,21,21,0,5,5,5,5,5,5),$lb(758198320,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,758198320,909259577,0,0,0,0,0,0,0,0,0,0,0,0,909259577))</Histogram>
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="Platform">
<AverageFieldSize>2.21</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,12,$lb("-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","1","9","9","9"),$lb(21,21,21,21,21,21,21,21,21,21,21,0,0,1,1),$lb(758198320,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,758198320,822083584,822083584,956301312,0,0,0,0,956301312))</Histogram>
<OutlierSelectivity>.788732:</OutlierSelectivity>
<Selectivity>7.0423%</Selectivity>
</Property>
<Property name="Product">
<AverageFieldSize>3.51</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,0,$lb("1","1","2","2","2","9","9","9","16","16","16","16","16","16","16","16"),$lb(1,0,1,1,0,1,1,0,2,2,2,2,2,2,2),$lb(822083584,0,0,822083584,838860800,0,0,0,0,838860800,956301312,0,0,0,0,956301312,825622528,0,0,0,0,0,0,0,0,0,0,0,0,0,0,825622528))</Histogram>
<Selectivity>17.6875%</Selectivity>
</Property>
<Property name="RefTopic">
<AverageFieldSize>4.63</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" "," "," "," "," "," "," "," "," "," 118,321,366"," 231,232"," 258"," 277,412"," 382"," 440"," 65,152,229,341,375,401,482"),$lb(2,2,2,2,2,2,2,2,1,1,2,2,1,1,1),$lb(536870912,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,825309228,825309228,842215724,858860594,892862464,892862464,926362676,842479404,859320832,859320832,875835392,875835392,909454385,540423468))</Histogram>
<OutlierSelectivity>.619718:</OutlierSelectivity>
<Selectivity>0.1862%</Selectivity>
</Property>
<Property name="StartVersion">
<AverageFieldSize>2.23</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,13,$lb("-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","6","11","20"),$lb(21,21,21,21,21,21,21,21,21,21,21,21,0,0,0),$lb(758198320,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,758198320,905969664,905969664,825294848,825294848,842006528,842006528))</Histogram>
<OutlierSelectivity>.84507:</OutlierSelectivity>
<Selectivity>0.5598%</Selectivity>
</Property>
<Property name="Title">
<AverageFieldSize>70.39</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb("  IEで管理ポータルが英語表記になります。日本語にするにはどうすれば良いですか？"," CACHÉとの運用実績のあるクラスタリングソフトウェアは何ですか？"," CACHÉはクラウド環境をサポートしますか？"," INTERSYSTEMSの製品の中身はMUMPS（M言語）だと聞いたのですが。"," LINUXでシステム開始/停止時に、インターシステムズ製品を自動起動/停止することはできますか？"," VB.NETでCACHEOBJECT.SETPICTURE()メソッドを使用して画像を保存する方法を教えてください。"," WINDOWSでCACHÉをアンインストールするときの注意点を教えてください。"," アップグレード後、管理ポータルを開こうとするとERROR #5001となり、開くことができません。"," コンソールログに ""FAILED TO ALLOCATE XXXMB SHARED MEMORY USING LARGE PAGES..."" のエラーメッセージがあります"," ジャーナルのON／OFFについて、コマンドで操作する方法を教えてください。"," データの登録／削除が行われている間でも、インデックスの再構築はできますか？"," バージョンの異なるインスタンス間で、ライセンスを共有することはできますか？"," マッピングしたグローバルがエクスポートできません"," 古いバージョンの購入はできますか？"," 未使用"," 選択性の数値とは何ですか？"),$lb(1,6,1,1,1,1,1,1,1,1,1,1,1,1,1),$lb(538986821,541672931,1128350536,3816925411,3816927203,1128350536,1229870149,1229870149,1279872597,1279872597,1447177806,1447177806,1464421956,1464421956,3816989411,3816989411,3816993763,3816993763,3816995043,3816995043,3817048035,3817048035,3817050339,3817050339,3817053923,3817053923,3851396323,3851396323,3869027044,3869027044,3917592806,552174008))</Histogram>
<Selectivity>0.1862%</Selectivity>
</Property>
<Property name="TopicID">
<AverageFieldSize>7</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" 00012"," 00016"," 00075"," 00147"," 00199"," 00234"," 00244"," 00251"," 00259"," 00276"," 00319"," 00325"," 00337"," 00429"," 00436"," 00502"),$lb(5,4,3,4,3,4,4,5,4,3,4,4,3,4,3),$lb(540028976,838860800,905969664,825622528,926220288,808924416,825505536,876019712,960036864,825833728,842216448,859045888,875823104,875823104,892403712,822083584,956301312,892928000,926285824,842479104,858863872,825819136,842334208,842334208,859242496,858994432,875706624,842596352,859176960,875771392,892350976,540028981))</Histogram>
<Selectivity>0.1862%</Selectivity>
</Property>
<Property name="TopicSubID">
<AverageFieldSize>2.51</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" "," "," "," "," "," "," "," "," "," "," "," "," "," 018"," 033"," 044"),$lb(2,2,2,2,2,2,2,2,2,2,2,2,1,2,2),$lb(536870912,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,808531968,825753600,858980352,858980352,875823104,540030004))</Histogram>
<OutlierSelectivity>.830986:</OutlierSelectivity>
<Selectivity>0.4254%</Selectivity>
</Property>
<Property name="UpdateDate">
<AverageFieldSize>4</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(64733,64890,64931,64989,64989,64989,64989,64992,65077,65091,65105,65286,65343,65344,65350,65387),$lb(2,2,3,5,5,5,3,1,3,2,2,2,4,3,3),$lb(909391667,926102272,943271936,943271936,959656192,858849280,943259648,0,0,0,0,0,0,943259648,959578112,876165426,892352311,926351360,959512576,809054464,825242880,825242880,842544640,842544640,859058944,855638016,872415232,875823104,892338176,892338176,943128576,909456184))</Histogram>
<OutlierSelectivity>.28169:64989</OutlierSelectivity>
<Selectivity>2.1038%</Selectivity>
</Property>
<Property name="Updater">
<AverageFieldSize>7.07</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" FURUZONO"," KAKECHI"," KAKECHI"," KAKECHI"," SATO"," SATO"," SATO"," SATO"," SATO"," SATO"," SATO"," SATO"," SATO"," SATO"," YAMAMOTO"," YAMAMOTO"),$lb(1,9,9,1,6,6,6,6,6,6,6,6,6,1,10),$lb(541480274,1179996757,1262570309,0,0,0,0,1262570309,1396790351,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1396790351,1497451841,0,0,542720333))</Histogram>
<OutlierSelectivity>.647887:"sato"</OutlierSelectivity>
<Selectivity>8.8028%</Selectivity>
</Property>
<Property name="UsersVoice">
<AverageFieldSize>4.83</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,0,$lb("12","16","75","147","199","234","244","251","259","276","319","325","337","429","436","501"),$lb(1,0,0,1,0,1,1,2,1,0,1,1,0,1,0),$lb(825360384,838860800,905969664,825622528,926220288,926220288,825505536,876019712,960036864,825833728,842216448,859045888,875823104,875823104,892403712,822083584,956301312,892928000,926285824,842479104,858863872,825819136,842334208,842334208,859242496,858994432,875706624,842596352,859176960,875771392,892350720,892350720))</Histogram>
<Selectivity>0.1862%</Selectivity>
</Property>
<Property name="VersionRange">
<AverageFieldSize>4.58</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" "," "," "," "," "," "," "," "," "," "," "," ","  ～ 2010.1.X"," 2011.1.X ～"," 5.0.X"," 5.0.X"),$lb(2,2,2,2,2,2,2,2,2,2,2,1,1,1,7),$lb(536870912,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,552582558,552582558,842019121,842019121,892219438,0,0,540356144))</Histogram>
<OutlierSelectivity>.816901:</OutlierSelectivity>
<Selectivity>0.4258%</Selectivity>
</Property>
<Property name="Visible">
<AverageFieldSize>2.87</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1),$lb(1,0,1,1,1,1,1,1,1,1,1,1,1,1,1),$lb(805306368,0,0,805306368,822083584,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,822083584))</Histogram>
<OutlierSelectivity>.873239:1</OutlierSelectivity>
<Selectivity>12.6761%</Selectivity>
</Property>
<Property name="WebFlg">
<AverageFieldSize>2.42</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" "," "," "," "," 0"," 0"," 0"," 0"," 0"," 1"," 1"," 1"," 1"," 1"," 1"," 1"),$lb(2,2,2,1,3,3,3,3,1,3,3,3,3,3,3),$lb(536870912,0,0,0,0,0,0,0,805306368,0,0,0,0,0,0,0,0,805306368,822083584,0,0,0,0,0,0,0,0,0,0,0,0,540082176))</Histogram>
<Selectivity>33.3333%</Selectivity>
</Property>
<SQLMap name="$Topic">
<BlockCount>-4</BlockCount>
</SQLMap>
<SQLMap name="CreatorIndex">
<BlockCount>-4</BlockCount>
</SQLMap>
<SQLMap name="IDKEY">
<BlockCount>-901</BlockCount>
</SQLMap>
<SQLMap name="IndexCompleted">
<BlockCount>-4</BlockCount>
</SQLMap>
<SQLMap name="IndexIssueDate">
<BlockCount>-4</BlockCount>
</SQLMap>
<SQLMap name="IndexTitle">
<BlockCount>-24</BlockCount>
</SQLMap>
<SQLMap name="IndexVisible">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^KB.TopicS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
