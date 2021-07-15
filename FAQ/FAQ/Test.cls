Class FAQ.Test Extends %Base
{

/// UnitTest用クラス
ClassMethod ExceptionError() As %Status
{
	Set tSC = $$$OK
	Try {
		set a = 10/0
	}
	Catch tE {
		set tSC = ##class(FAQ.Error).StoreErrorInformation(tE)
	}
	Quit tSC
}

ClassMethod CurrentTopicSubId() As %String
{
	Set tSC = $$$OK
	set tSubID = ##class(KB.Topic).GetCurTopicSubID()
	set tD = ##class(KB.Topic).DecrementTopicSubID()
    Quit +tSubID
}

ClassMethod TopicId(pId As %Integer) As %String
{
	Set tSC = $$$OK
    Quit ##class(KB.Topic).ComputeTopicID(pId)
}

ClassMethod Reflink2(pId1 As %Integer, pId2 As %Integer) As %String
{
	Set tSC = $$$OK
	set tTopic1 = ##class(KB.Topic).%OpenId(pId1)
	set tTopic1.RefTopic = pId2
	set status = tTopic1.%Save()
	set tSC =tTopic1.RefCheckLink(0)
    set tRefTopic1 = tTopic1.RefTopic
	set tTopic2 = ##class(KB.Topic).%OpenId(pId2)
	set tRefTopic2 = tTopic2.RefTopic
    Quit tRefTopic1_";"_tRefTopic2
}

ClassMethod Reflink3(pId1 As %Integer, pId2 As %Integer, pId3 As %Integer) As %String
{
	Set tSC = $$$OK
	set tTopic1 = ##class(KB.Topic).%OpenId(pId1)
	set tTopic1.RefTopic = pId2_","_pId3
	set status = tTopic1.%Save()
	set tSC =tTopic1.RefCheckLink(0)
    set tRefTopic1 = tTopic1.RefTopic
	set tTopic2 = ##class(KB.Topic).%OpenId(pId2)
	set tRefTopic2 = tTopic2.RefTopic
	set tTopic3 = ##class(KB.Topic).%OpenId(pId3)
	set tRefTopic3 = tTopic3.RefTopic
    Quit tRefTopic1_";"_tRefTopic2_";"_tRefTopic3
}

}
