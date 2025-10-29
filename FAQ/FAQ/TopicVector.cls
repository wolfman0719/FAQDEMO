Class FAQ.TopicVector Extends %Persistent
{

Property TopicId As %Integer;

Property SplittedDescription As %String(MAXLEN = 1000);

Property DescriptionVector As %Vector(DATATYPE = "DOUBLE", LEN = 768);

Index TopicIdIndex On TopicId;

Index HNSWDescriptionIndex On (DescriptionVector) As %SQL.Index.HNSW(Distance = "DotProduct");

ClassMethod GetEmbeddingFlask(sentences) As %String [ Language = python, SqlProc ]
{
    import requests

    url = "http://localhost:10905/embedding"
    headers = {"Content-Type": "application/json; charset=utf-8"}
    data = {"sentence": sentences}
    try:
        response = requests.post(url, headers=headers, json=data)
        embedding = response.json()['embedding']
        return embedding   # 既にカンマ区切り文字列
    except Exception as e:
        return ""
}

/// モデルをキャッシュから取得
/// @return モデルインスタンスまたはNone
ClassMethod GetModelData() [ Language = python ]
{
    import sys
    return getattr(sys.modules[__name__], '_cached_model', None)
}

/// モデルをキャッシュに保存
/// @param model 保存するモデルインスタンス
ClassMethod StoreModelData(model) [ Language = python ]
{
    import sys
    setattr(sys.modules[__name__], '_cached_model', model)
}

ClassMethod RemoveHTMLTag(text) As %String [ Language = python ]
{
  import re

  clean = re.compile('<.*?>')
  return re.sub(clean, '', text)
}

ClassMethod BuildVectorsForDescription(pText As %String, pId As %Integer) As %String [ Language = python ]
{
import iris    
from langchain_text_splitters import RecursiveCharacterTextSplitter
from sentence_transformers import SentenceTransformer as ST

# --- インスタンス生成 ---
text_splitter = RecursiveCharacterTextSplitter(
    # separators=["\n\n", "\n", " ", ""], # チャンクの区切り文字リスト
    chunk_size=200,           # チャンクの最大文字数
    chunk_overlap=20,         # チャンク間の重複する文字数
    length_function=len,      # 文字数で分割
    is_separator_regex=False, # separatorを正規表現として扱う場合はTrue
)

# --- テキスト分割してリストを取得 ---
texts = text_splitter.create_documents([pText])
for document in texts:
  sql = 'insert into faq.topicvector (topicid,descriptionvector,SplittedDescription) values(?,TO_VECTOR(?,DOUBLE,768),?)'
  model = iris.cls('FAQ.TopicVector').GetModelData()
  if model is None:
     # vector =  DOUBLE,768
     model = ST('stsb-xlm-r-multilingual')
     iris.cls('FAQ.TopicVector').StoreModelData(model)
  document.page_content = document.page_content.replace('&quot;','')
  document.page_content = document.page_content.replace('&nbsp;','')
  document.page_content = document.page_content.replace('&gt;','')
  document.page_content = document.page_content.replace('&lt;','')
  embeddings = model.encode(document.page_content,normalize_embeddings=True)
  # convert the embeddings to a string
  embeddings_list = [str(embedding.tolist()) for embedding in embeddings]
  dv = str(embeddings_list).replace('\'','')
  dv.replace('[','')
  dv.replace(']','')
  st =iris.sql.prepare(sql)
  try:
    st.execute(pId,dv,document.page_content)
  except Exception as e:
    print(e)
}

ClassMethod BuildVectorForDescriptions() As %Status
{
  //　全トピックのDescriptionに対してベクター（エンべディング）を生成し、最後にHNSWインデックスを付加する	
  set status = $$$OK
  try {
    set status = ##class(FAQ.TopicVector).%KillExtent()
	set statement = ##class(%SQL.Statement).%New()
	set sql = "select ID,TITLE,DESCRIPTION from kb.topic"
	set status = statement.%Prepare(sql)
	$$$ThrowOnError(status)
	set rs = statement.%Execute()
	while rs.%Next() {
	  set id = rs.%Get("ID")
	  set description = ..RemoveHTMLTag(rs.%Get("DESCRIPTION"))
	  set title = rs.%Get("TITLE")
      set status = ..BuildVectorsForDescription(title_" "_description,id)
	}

    set status =  ..%BuildIndices($listbuild("HNSWDescriptionIndex"))
	$$$ThrowOnError(status)
  }
  Catch e {
	do e.Log()
	Set status = e.AsStatus()
	set status2 = ##class(FAQ.Error).StoreErrorInformation(e)
  }
  quit status
}

Storage Default
{
<Data name="TopicVectorDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TopicId</Value>
</Value>
<Value name="3">
<Value>DescriptionVector</Value>
</Value>
<Value name="4">
<Value>SplittedDescription</Value>
</Value>
</Data>
<DataLocation>^FAQ.TopicVectorD</DataLocation>
<DefaultData>TopicVectorDefaultData</DefaultData>
<IdLocation>^FAQ.TopicVectorD</IdLocation>
<IndexLocation>^FAQ.TopicVectorI</IndexLocation>
<StreamLocation>^FAQ.TopicVectorS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
