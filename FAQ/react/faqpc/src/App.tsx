import React from 'react';
import logo from './logo.svg';
import './App.css';
import axios from "axios";
import { ChangeEvent, useState } from "react";
import configinfo from './serverconfig.json';

export const App = () => {

  const [topicList, setTopicList] = useState<any>([]);
  const [isLoading, setIsLoading] = useState(false);
  const [isError, setIsError] = useState(false);
  const [inputtext, setInputText] = useState<any>("");
  const [response, setResponse] = useState<any>("");
  const [reftopics, setRefTopics] = useState<any>([]);
  const [refno, setRefno] = useState<any>("");
  const [reftitle, setRefTitle] = useState<any>("");
  const [errortext, setErrorText] = useState<any>("");
  const [fileflag, setFileFlag] = useState(false);
  
  const comma: string = ",";
  const ServerAddress = configinfo.ServerAddress;
  const ServerPort = configinfo.ServerPort;
  
  const onClickFetchTopicList = () => {
	
	setIsLoading(true);
    setIsError(false);
  
  	if (isNaN(inputtext) || inputtext == "") {
	  
	  axios
	    .get<any>(`http://${ServerAddress}:${ServerPort}/faqapi/TopicSearchByKeyword/z${inputtext}`)
	    .then((result: any) => {
	      const topics = result.data.map((topic: any) => ({
		    id: topic.id,
		    title: topic.title
          }));
          setTopicList(topics);
	    })
        .catch((error: any) => {
         setIsError(true)
		 setErrorText(error.message);
		 })
        .finally(() => setIsLoading(false));
   }
   else {	
	  axios
	    .get<any>(`http://${ServerAddress}:${ServerPort}/faqapi/TopicGetById/${inputtext}`)
	    .then((result: any) => {
	      setResponse(result.data);
		  if (response.FileFlg) setFileFlag(true);
		  setRefTopics(result.data.RefArray);
	    })
        .catch((error: any) => {
	       setIsError(true)
		   setErrorText(error.message);
	    })
        .finally(() => setIsLoading(false))
    }
  };

   const onClickItem = (topicid: any) => {
	setIsLoading(true);
	setIsError(false);
	
	axios
	  .get<any>(`http://${ServerAddress}:${ServerPort}/faqapi/TopicGetById/${topicid}`)
	  .then((result: any) => {
	    setResponse(result.data);
		if (response.FileFlg) setFileFlag(true);
		setRefTopics(result.data.RefArray);
	  })
      .catch((error: any) => {
	     setIsError(true)
		 setErrorText(error.message);
	  })
      .finally(() => setIsLoading(false))
  };

  const onChangeText = (e: ChangeEvent<HTMLInputElement>) => setInputText(e.target.value);
    
  return (
    <>
    <div className="title">
    <a href="https://www.intersystems.co.jp" ><img src="https://www.intersystems.com/assets/intersystems-logo.png" style = {{width: "200",height: "50",border: "0"}}/></a>
	<h1> FAQ検索　</h1>
	</div>
    <div className="query">
	  <label>検索キーワード: </label>
	  <input type="text" value = {inputtext} onChange={onChangeText} />
	  <button onClick={onClickFetchTopicList}>トピック検索</button>
		  {isError && <p style={{ color: "red" }}>エラーが発生しました　{`${errortext}`}</p>}
	</div>
    <div className="topiclist" style = {{ float: "left",height: "700px",overflow: "auto",border: "solid #000000 1px"}}>	
	<table><tbody>
	  {isLoading ? (<p>Data Loading</p>)
		 : (
		 topicList.map((topic: any) => (
		 <tr>
		 <button style = {{width: "800px",textAlign: "left"}} className="topictitle" onClick={() => onClickItem(topic.id)}>{`${topic.id}:${topic.title}`}</button>
		 </tr>
		 )))
	  }
	</tbody></table>
    </div>
    <div style = {{ float: "left"}}>
    <div style = {{ width: "800px",height: "90px",overflow: "scroll",border: "solid #000000 1px"}}><h4 style = {{ marginLeft: "20px", marginRight: "20px"}}>{response.Title}</h4></div>
    <div id="topiccontent" style = {{ width: "800px",height: "410px",overflow: "auto",border: "solid #000000 1px"}}>
    {(response.DCURL == "") && <div style = {{ marginLeft: "20px", marginRight: "20px"}}><span dangerouslySetInnerHTML={{__html: response.Description}}></span></div>}	
    {(response.DCURL !== "") && (response.DCURL != undefined ) && <div style = {{ marginLeft: "20px", marginRight: "20px"}}><span><p>最新内容は、デベロッパーコミュニティをご参照ください</p><a href={response.DCURL}  target="_blank">デベロッパーコミュニティの記事</a></span></div>}	
    </div>
    <div id="relatedtopics" style = {{ width: "800px",height: "100px",overflow: "auto",border: "solid #000000 1px"}}>
    <p>関連トピック</p>
    <table><tbody>
	
	  {
	  
        reftopics.map((reftopic: any) => (
		  <tr>
		  <button style = {{width: "800px",textAlign: "left"}} className="topictitle" onClick={() => onClickItem(reftopic.split(comma)[0])}>{`${reftopic.split(comma)[0]}:${reftopic.split(comma)[1]}`}</button>
		  </tr>
    	)
    )}
	</tbody></table>
    </div>
    <div id="downloadfile" style = {{ width: "800px",height: "100px",overflow: "auto",border: "solid #000000 1px"}}>
    {fileflag && <a href = {response.DownloadFile}>添付ファイル</a>}
    </div>
    </div>	
    </>	
  );	
}
export default App;
