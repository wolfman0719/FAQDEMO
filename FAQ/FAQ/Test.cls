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

ClassMethod BigJSONTest(pfilename As %String) As %Status
{
  set status = $$$OK

  try  {
		  
    set status = $$$OK
    
	set response = ##class(%Stream.FileCharacter).%New()
	set response.TranslateTable = "BIN"
	set status = response.LinkToFile(pfilename)

    set stream = ##class(%Stream.TmpCharacter).%New()
    while 'response.AtEnd {
      set data = response.Read()
      set data2 = $zcvt(data,"I","UTF8")
	  write "data2 = ",data2,!
      do stream.Write(data2)
    }
    set res={}.%FromJSON(stream)
    write res.%ToJSON()	  	  
  }
  catch e {
		
    set status = e.AsStatus()
		
  }
  
  quit status
}

ClassMethod TopicVectorSearch(pQueryText As %String) As %Status
{
  set status = $$$OK
  
  try  {
	
      set QueryEmbedding =$tr(##class(FAQ.TopicVector).GetEmbeddingFlask(pQueryText)," '[]")
      write QueryEmbedding

      set sql = "SELECT top 100 id,topicid,splitteddescription, vector_cosine(DescriptionVector, TO_VECTOR(?, DOUBLE, 768)) as vdp from faq.topicvector order by vector_cosine(DescriptionVector, TO_VECTOR(?, DOUBLE, 768)) desc"
      set sql = "SELECT top 100 id,topicid,splitteddescription, vector_dot_product(DescriptionVector, TO_VECTOR(?, DOUBLE, 768)) as vdp from faq.topicvector order by vector_dot_product(DescriptionVector, TO_VECTOR(?, DOUBLE, 768)) desc"
    
      set statemt=##class(%SQL.Statement).%New()
      set status=statemt.%Prepare(sql)
      set rset=statemt.%Execute(QueryEmbedding, QueryEmbedding)

      while rset.%Next()  {
        set id = rset.%Get("id")
		    set topicid = rset.%Get("topicid")
        set splitteddescription = rset.%Get("splitteddescription")
        set vdp = rset.%Get("vdp")
        write id," ",vdp, " ",topicid," ",splitteddescription,!
		    
      }
 	  
  }
  catch e {
		
    set status = e.AsStatus()
		
  }
  
  quit status
}

ClassMethod EnbeddingTest(sentence1 As %String, sentence2 As %String) As %Status [ Language = python ]
{
  from sentence_transformers import SentenceTransformer, util

  model = SentenceTransformer('stsb-xlm-r-multilingual')
  embeddings1 = model.encode(sentence1, convert_to_tensor=True)
  embeddings2 = model.encode(sentence2, convert_to_tensor=True)
  cosine_score = util.pytorch_cos_sim(embeddings1, embeddings2)[0][0]
  print(f"stsb-xlm-r-multilingual 文章1と文章2の類似度: {cosine_score}")
  return 1
}

ClassMethod EmbeddingTest2(sentence1 As %String) As %Status [ Language = python ]
{
  import iris
  from sentence_transformers import SentenceTransformer, util

  print('sentence1 = ' + sentence1)
  model = SentenceTransformer('stsb-xlm-r-multilingual')
  embeddings1 = model.encode(sentence1, normalize_embeddings=True)
  embedding1 = str(embeddings1.tolist()).replace('[', '').replace(']', '')

  # sql = iris.sql.prepare("Select top 100 splitteddescription,topicid from faq.topicvector order by vector_dot_product(DescriptionVector, TO_VECTOR(?, DOUBLE, 768)) desc")
  sql = iris.sql.prepare("SELECT top 100 tv.splitteddescription, tv.topicid from faq.topicvector as tv inner join kb.topic as t on tv.topicid = t.id order by vector_dot_product(tv.DescriptionVector, TO_VECTOR(?, DOUBLE, 768)) desc")
  itemline = sql.execute(embedding1).dataframe()
  
  for index,row in itemline.iterrows():
      rowline = list(row)
      sentence2 = rowline[0]
      topicid = rowline[1]
      if sentence2 is not None:
        embeddings2 = model.encode(sentence2, normalize_embeddings=True)
        cosine_score = util.pytorch_cos_sim(embeddings1, embeddings2)[0][0]
        print(f"topicid = {topicid}")
        print('sentence2 = ' + sentence2)
        print(f"stsb-xlm-r-multilingual 文章1と文章2の類似度: {cosine_score}")
  return 1
}

}
