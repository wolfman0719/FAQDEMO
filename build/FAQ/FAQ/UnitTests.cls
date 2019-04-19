Class FAQ.UnitTests Extends %UnitTest.TestCase
{

Method TestExceptionError()
{
 set tCurErrId = $get(^FAQ.ErrorD)	
 do $$$AssertStatusOK(##class(FAQ.Test).ExceptionError(), "Genarating Exception error")
 do $$$AssertEquals($get(^FAQ.ErrorD),tCurErrId+1, "Comfirming a FAQ.Error object has been produced")
}

Method TestCurrentTopicSubId()
{
 set tTopicSubId = $Get(^TopicSubID) + 1	
 do $$$AssertEquals(##class(FAQ.Test).CurrentTopicSubId(),tTopicSubId, "Getting ^TopicSubID + 1")
}

Method TestTopicId()
{
 set tTopicId = "00100"	
 do $$$AssertEquals(##class(FAQ.Test).TopicId(100),tTopicId, "Getting a TopicId in as is format")
}

Method TestReflink()
{
 set tTopic1 = ##class(KB.Topic).%OpenId(1)
 set tTopic2 = ##class(KB.Topic).%OpenId(2)
 set tTopic1.RefTopic = ""
 set tTopic2.RefTopic = ""
 set tSC = tTopic1.%Save()
 set tSC = tTopic2.%Save()
 set tResult = "2;1"	
 do $$$AssertEquals(##class(FAQ.Test).Reflink2(1,2),tResult, "Linking RefTopic 1 & 2")
 do $$$AssertEquals(##class(FAQ.Test).Reflink2(1,2),tResult, "Linking RefTopic 1 & 2 (already linked)")
 set tTopic1 = ##class(KB.Topic).%OpenId(1)
 set tTopic2 = ##class(KB.Topic).%OpenId(2)
 set tTopic3 = ##class(KB.Topic).%OpenId(3)
 set tTopic1.RefTopic = ""
 set tTopic2.RefTopic = ""
 set tTopic3.RefTopic = ""
 set tSC = tTopic1.%Save()
 set tSC = tTopic2.%Save()
 set tSC = tTopic3.%Save()
 set tResult = "2,3;1;1"	
 do $$$AssertEquals(##class(FAQ.Test).Reflink3(1,2,3),tResult, "Linking RefTopic 1 & 2 & 3")
 do $$$AssertEquals(##class(FAQ.Test).Reflink3(1,2,3),tResult, "Linking RefTopic 1 & 2 & 3 (aleady linked")
 set tTopic1 = ##class(KB.Topic).%OpenId(1)
 set tTopic2 = ##class(KB.Topic).%OpenId(2)
 set tTopic3 = ##class(KB.Topic).%OpenId(3)
 set tTopic1.RefTopic = ""
 set tTopic2.RefTopic = ""
 set tTopic3.RefTopic = ""
 set tSC = tTopic1.%Save()
 set tSC = tTopic2.%Save()
 set tSC = tTopic3.%Save()
 set tResult1 = "3;2"
 set tResult2 = "2;1,3"
 do $$$AssertEquals(##class(FAQ.Test).Reflink2(2,3),tResult1, "Linking RefTopic 2 & 3")
 do $$$AssertEquals(##class(FAQ.Test).Reflink2(1,2),tResult2, "Linking RefTopic 1 & 2 2 has already a link")
 do $$$AssertEquals(##class(FAQ.Test).Reflink2(1,2),tResult2, "Linking RefTopic 1 & 2 (aleady linked)")
 set tTopic1 = ##class(KB.Topic).%OpenId(1)
 set tTopic2 = ##class(KB.Topic).%OpenId(2)
 set tTopic3 = ##class(KB.Topic).%OpenId(3)
 set tTopic1.RefTopic = ""
 set tTopic2.RefTopic = ""
 set tTopic3.RefTopic = ""
 set tSC = tTopic1.%Save()
 set tSC = tTopic2.%Save()
 set tSC = tTopic3.%Save()
}

Method TestRemoveLink()
{

 set tTopic1 = ##class(KB.Topic).%OpenId(1)
 set tTopic1.RefTopic = "2,3"
 set tSC = tTopic1.%Save()
 do tTopic1.RefCheckLink(0)
 Set tSC = ##class(KB.Topic).RemoveLink(1,"2,3","3")
 Set tTopic2 = ##class(KB.Topic).%OpenId(2)
 Set tResult = tTopic2.RefTopic
 do $$$AssertEquals("",tResult, "Remove id 2 of the id 1")
 set tTopic1 = ##class(KB.Topic).%OpenId(1)
 set tTopic2 = ##class(KB.Topic).%OpenId(2)
 set tTopic3 = ##class(KB.Topic).%OpenId(3)
 set tTopic1.RefTopic = ""
 set tTopic2.RefTopic = ""
 set tTopic3.RefTopic = ""
 set tSC = tTopic1.%Save()
 set tSC = tTopic2.%Save()
 set tSC = tTopic3.%Save()
 set tTopic1 = ##class(KB.Topic).%OpenId(1)
 set tTopic1.RefTopic = "3,2"
 set tSC = tTopic1.%Save()
 do tTopic1.RefCheckLink(0)
 Set tSC = ##class(KB.Topic).RemoveLink(1,"3,2","3")
 Set tTopic2 = ##class(KB.Topic).%OpenId(2)
 Set tResult = tTopic2.RefTopic
 do $$$AssertEquals("",tResult, "Remove id 2 of the id 1")

 set tTopic1 = ##class(KB.Topic).%OpenId(1)
 set tTopic2 = ##class(KB.Topic).%OpenId(2)
 set tTopic3 = ##class(KB.Topic).%OpenId(3)
 set tTopic1.RefTopic = ""
 set tTopic2.RefTopic = ""
 set tTopic3.RefTopic = ""
 set tSC = tTopic1.%Save()
 set tSC = tTopic2.%Save()
 set tSC = tTopic3.%Save()
 set tTopic1 = ##class(KB.Topic).%OpenId(1)
 set tTopic1.RefTopic = "3,2"
 set tSC = tTopic1.%Save()
 do tTopic1.RefCheckLink(0)
 Set tSC = ##class(KB.Topic).RemoveLink(1,"3,2","3,2")
 Set tTopic2 = ##class(KB.Topic).%OpenId(2)
 Set tResult = tTopic2.RefTopic
 do $$$AssertEquals("1",tResult, "No Change")

 set tTopic1 = ##class(KB.Topic).%OpenId(1)
 set tTopic2 = ##class(KB.Topic).%OpenId(2)
 set tTopic3 = ##class(KB.Topic).%OpenId(3)
 set tTopic1.RefTopic = ""
 set tTopic2.RefTopic = ""
 set tTopic3.RefTopic = ""
 set tSC = tTopic1.%Save()
 set tSC = tTopic2.%Save()
 set tSC = tTopic3.%Save()
 set tTopic1 = ##class(KB.Topic).%OpenId(1)
 set tTopic1.RefTopic = "3,2"
 set tSC = tTopic1.%Save()
 do tTopic1.RefCheckLink(0)
 Set tSC = ##class(KB.Topic).RemoveLink(1,"3,2","")
 Set tTopic2 = ##class(KB.Topic).%OpenId(2)
 Set tResult = tTopic2.RefTopic
 do $$$AssertEquals("",tResult, "Remove id 2 of the id 1")
 Set tTopic3 = ##class(KB.Topic).%OpenId(2)
 Set tResult = tTopic3.RefTopic
 do $$$AssertEquals("",tResult, "Remove id 3 of the id 1")

 set tTopic1 = ##class(KB.Topic).%OpenId(1)
 set tTopic2 = ##class(KB.Topic).%OpenId(2)
 set tTopic3 = ##class(KB.Topic).%OpenId(3)
 set tTopic1.RefTopic = ""
 set tTopic2.RefTopic = ""
 set tTopic3.RefTopic = ""
 set tSC = tTopic1.%Save()
 set tSC = tTopic2.%Save()
 set tSC = tTopic3.%Save()
 set tTopic1 = ##class(KB.Topic).%OpenId(1)
 set tTopic1.RefTopic = "3,2"
 set tSC = tTopic1.%Save()
 do tTopic1.RefCheckLink(0)
 Set tSC = ##class(KB.Topic).RemoveLink(1,"3,2","3;2")
 do $$$AssertStatusNotOK(tSC, "Format Error")
}

Method TestUpdateProductInTopics()

{
  set do = {}
  set do."PropertyName" = "Product"
  set da = []
  set do2 = {}
  set do2.topicid = 1
  set do2.PropertyValue = 2
  set da."0" = do2
  set do3 = {}
  set do3.topicid = 2
  set do3.PropertyValue = 4
  set da."1" = do3
  set do.KVArray = da
  set status = ##class(KB.Topic).UpdatePropertyOfMultipleTopics(do.%ToJSON())
  do $$$AssertStatusOK(status, "Changes have been made")
  set topic = ##class(KB.Topic).%OpenId(1)
  do $$$AssertEquals(2,topic.Product.%Id(), "Topic 1 The Property "_do."PropertyName"_" was updated correctly")
  set topic = ##class(KB.Topic).%OpenId(2)
  do $$$AssertEquals(4,topic.Product.%Id(), "Topic 2 The Property "_do."PropertyName"_" was updated correctly")

  set do2.topicid = 1
  set do2.PropertyValue = 100
  set da."0" = do2
  set do3.topicid = 2
  set do3.PropertyValue = 200
  set da."1" = do3
  set status = ##class(KB.Topic).UpdatePropertyOfMultipleTopics(do.%ToJSON())
  do $$$AssertStatusNotOK(status, "Changes have not been made")
  set topic = ##class(KB.Topic).%OpenId(1)
  do $$$AssertNotEquals(100,topic.Product.%Id(), "Topic 1 The Property "_do."PropertyName"_" was not updated")
  set topic = ##class(KB.Topic).%OpenId(2)
  do $$$AssertNotEquals(200,topic.Product.%Id(), "Topic 2 The Property "_do."PropertyName"_" was not updated")
}

Method TestUpdateCategoryInTopics()

{
  set do = {}
  set do."PropertyName" = "Category"
  set da = []
  set do2 = {}
  set do2.topicid = 3
  set do2.PropertyValue = 2
  set da."0" = do2
  set do3 = {}
  set do3.topicid = 4
  set do3.PropertyValue = 4
  set da."1" = do3
  set do.KVArray = da
  set status = ##class(KB.Topic).UpdatePropertyOfMultipleTopics(do.%ToJSON())
  do $$$AssertStatusOK(status, "Changes have been made")
  set topic = ##class(KB.Topic).%OpenId(3)
  do $$$AssertEquals(2,topic.Category.%Id(), "Topic 3 The Property "_do."PropertyName"_" was updated correctly")
  set topic = ##class(KB.Topic).%OpenId(4)
  do $$$AssertEquals(4,topic.Category.%Id(), "Topic 4 The Property "_do."PropertyName"_" was updated correctly")

  set do2.topicid = 3
  set do2.PropertyValue = 100
  set da."0" = do2
  set do3.topicid = 4
  set do3.PropertyValue = 200
  set da."1" = do3
  set status = ##class(KB.Topic).UpdatePropertyOfMultipleTopics(do.%ToJSON())
  do $$$AssertStatusNotOK(status, "Changes have not been made")
  set topic = ##class(KB.Topic).%OpenId(3)
  do $$$AssertNotEquals(100,topic.Category.%Id(), "Topic 3 The Property "_do."PropertyName"_" was not updated")
  set topic = ##class(KB.Topic).%OpenId(4)
  do $$$AssertNotEquals(200,topic.Category.%Id(), "Topic 4 The Property "_do."PropertyName"_" was not updated")
}

Method TestUpdateFacilityInTopics()

{
  set do = {}
  set do."PropertyName" = "Facility"
  set da = []
  set do2 = {}
  set do2.topicid = 5
  set do2.PropertyValue = 2
  set da."0" = do2
  set do3 = {}
  set do3.topicid = 6
  set do3.PropertyValue = 3
  set da."1" = do3
  set do.KVArray = da
  set status = ##class(KB.Topic).UpdatePropertyOfMultipleTopics(do.%ToJSON())
  do $$$AssertStatusOK(status, "Changes have been made")
  set topic = ##class(KB.Topic).%OpenId(5)
  do $$$AssertEquals(2,topic.Facility.%Id(), "Topic 1 The Property "_do."PropertyName"_" was updated correctly")
  set topic = ##class(KB.Topic).%OpenId(6)
  do $$$AssertEquals(3,topic.Facility.%Id(), "Topic 2 The Property "_do."PropertyName"_" was updated correctly")

  set do2.topicid = 5
  set do2.PropertyValue = 100
  set da."0" = do2
  set do3.topicid = 6
  set do3.PropertyValue = 200
  set da."1" = do3
  set status = ##class(KB.Topic).UpdatePropertyOfMultipleTopics(do.%ToJSON())
  do $$$AssertStatusNotOK(status, "Changes have not been made")
  set topic = ##class(KB.Topic).%OpenId(5)
  do $$$AssertNotEquals(100,topic.Facility.%Id(), "Topic 5 The Property "_do."PropertyName"_" was not updated")
  set topic = ##class(KB.Topic).%OpenId(6)
  do $$$AssertNotEquals(200,topic.Facility.%Id(), "Topic 6 The Property "_do."PropertyName"_" was not updated")
}


Method TestUpdateCompletedInTopics()

{
  set do = {}
  set do."PropertyName" = "Completed"
  set da = []
  set do2 = {}
  set do2.topicid = 7
  set do2.PropertyValue = 0
  set da."0" = do2
  set do3 = {}
  set do3.topicid = 8
  set do3.PropertyValue = 1
  set da."1" = do3
  set do.KVArray = da
  set status = ##class(KB.Topic).UpdatePropertyOfMultipleTopics(do.%ToJSON())
  do $$$AssertStatusOK(status, "Changes have been made")
  set topic = ##class(KB.Topic).%OpenId(7)
  do $$$AssertEquals(0,topic.Completed, "Topic 7 The Property "_do."PropertyName"_" was updated correctly")
  set topic = ##class(KB.Topic).%OpenId(8)
  do $$$AssertEquals(1,topic.Completed, "Topic 8 The Property "_do."PropertyName"_" was updated correctly")

  set do2.topicid = 7
  set do2.PropertyValue = 100
  set da."0" = do2
  set do3.topicid = 8
  set do3.PropertyValue = 200
  set da."1" = do3
  set status = ##class(KB.Topic).UpdatePropertyOfMultipleTopics(do.%ToJSON())
  do $$$AssertStatusOK(status, "Changes have been made")
  set topic = ##class(KB.Topic).%OpenId(7)
  do $$$AssertEquals(0,topic.Completed, "Topic 7 The Property "_do."PropertyName"_" was updated correctly")
  set topic = ##class(KB.Topic).%OpenId(8)
  do $$$AssertEquals(0,topic.Completed, "Topic 8 The Property "_do."PropertyName"_" was updated correctly")
}

Method TestUpdateVisibleInTopics()

{
  set do = {}
  set do."PropertyName" = "Visible"
  set da = []
  set do2 = {}
  set do2.topicid = 9
  set do2.PropertyValue = 0
  set da."0" = do2
  set do3 = {}
  set do3.topicid = 10
  set do3.PropertyValue = 1
  set da."1" = do3
  set do.KVArray = da
  set status = ##class(KB.Topic).UpdatePropertyOfMultipleTopics(do.%ToJSON())
  do $$$AssertStatusOK(status, "Changes have been made")
  set topic = ##class(KB.Topic).%OpenId(9)
  do $$$AssertEquals(0,topic.Visible, "Topic 9 The Property "_do."PropertyName"_" was updated correctly")
  set topic = ##class(KB.Topic).%OpenId(10)
  do $$$AssertEquals(1,topic.Visible, "Topic 10 The Property "_do."PropertyName"_" was updated correctly")

  set do2.topicid = 9
  set do2.PropertyValue = 100
  set da."0" = do2
  set do3.topicid = 10
  set do3.PropertyValue = 200
  set da."1" = do3
  set status = ##class(KB.Topic).UpdatePropertyOfMultipleTopics(do.%ToJSON())
  do $$$AssertStatusOK(status, "Changes have been made")
  set topic = ##class(KB.Topic).%OpenId(9)
  do $$$AssertEquals(0,topic.Visible, "Topic 9 The Property "_do."PropertyName"_" was updated correctly")
  set topic = ##class(KB.Topic).%OpenId(10)
  do $$$AssertEquals(0,topic.Visible, "Topic 10 The Property "_do."PropertyName"_" was updated correctly")
}

Method TestUpdateDeleteFlgInTopics()

{
  set do = {}
  set do."PropertyName" = "DeleteFlg"
  set da = []
  set do2 = {}
  set do2.topicid = 11
  set do2.PropertyValue = 0
  set da."0" = do2
  set do3 = {}
  set do3.topicid = 12
  set do3.PropertyValue = 1
  set da."1" = do3
  set do.KVArray = da
  set status = ##class(KB.Topic).UpdatePropertyOfMultipleTopics(do.%ToJSON())
  do $$$AssertStatusOK(status, "Changes have been made")
  set topic = ##class(KB.Topic).%OpenId(11)
  do $$$AssertEquals(0,topic.DeleteFlg, "Topic 11 The Property "_do."PropertyName"_" was updated correctly")
  set topic = ##class(KB.Topic).%OpenId(12)
  do $$$AssertEquals(1,topic.DeleteFlg, "Topic 12 The Property "_do."PropertyName"_" was updated correctly")

  set do2.topicid = 11
  set do2.PropertyValue = 100
  set da."0" = do2
  set do3.topicid = 12
  set do3.PropertyValue = 200
  set da."1" = do3
  set status = ##class(KB.Topic).UpdatePropertyOfMultipleTopics(do.%ToJSON())
  do $$$AssertStatusOK(status, "Changes have been made")
  set topic = ##class(KB.Topic).%OpenId(11)
  do $$$AssertEquals(0,topic.DeleteFlg, "Topic 11 The Property "_do."PropertyName"_" was updated correctly")
  set topic = ##class(KB.Topic).%OpenId(12)
  do $$$AssertEquals(0,topic.DeleteFlg, "Topic 12 The Property "_do."PropertyName"_" was updated correctly")
}

}
