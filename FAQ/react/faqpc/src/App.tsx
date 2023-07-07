import React from 'react';
import './App.css';
import axios from "axios";
import { useState } from "react";
import { Header } from './components/Header';
import { Query } from './components/Query';
import { TopicList } from './components/TopicList';
import { TopicContent } from './components/TopicContent';
import { RelatedTopics } from './components/RelatedTopics';
import { DownloadFile } from './components/DownloadFile';
import { useWindowSize } from "./hooks/useWindowSize";
import configinfo from './serverconfig.json';

export const App = () => {

  const [topicList, setTopicList] = useState<any>([]);
  const [isLoading, setIsLoading] = useState(false);
  const [isError, setIsError] = useState(false);
  const [response, setResponse] = useState<any>("");
  const [reftopics, setRefTopics] = useState<any>([]);
  const [errortext, setErrorText] = useState<any>("");
  const [fileflag, setFileFlag] = useState(false);
  const [prevtopicid, setPrevTopicId] = useState(0);
  const [prevtopicflag, setPrevTopicFlag] = useState(false);
  
  const ServerAddress = configinfo.ServerAddress;
  const ServerPort = configinfo.ServerPort;
  
  const onClickFetchTopicList = (keyword: any) => {
	
	setIsLoading(true);
    setIsError(false);
  
	axios
	  .get<any>(`http://${ServerAddress}:${ServerPort}/faqapi/TopicSearchByKeyword/z${keyword}`)
	  .then((result: any) => {
	  const topics = result.data.map((topic: any) => ({
		id: topic.id,
		title: topic.title
      }));
      setTopicList(topics);
	  })
      .catch((error: any) => {
        setIsError(true)
		setErrorText(error.response.data.summary);
	  })
      .finally(() => setIsLoading(false));
  };

   const onClickItem = (topicid: any) => {
	setIsLoading(true);
	setIsError(false);
	setPrevTopicFlag(false);
	setPrevTopicId(topicid);

	axios
	  .get<any>(`http://${ServerAddress}:${ServerPort}/faqapi/TopicGetById/${topicid}`)
	  .then((result: any) => {
	    setResponse(result.data);
		if (response.FileFlg) {
			setFileFlag(true);
		}
		else {
			setFileFlag(false);
		}
		setRefTopics(result.data.RefArray);
	  })
      .catch((error: any) => {
	     setIsError(true)
		 setErrorText(error.response.data.summary);
	  })
      .finally(() => setIsLoading(false))
  };

   const onClickItem2 = (topicid: any) => {
	setIsLoading(true);
	setIsError(false);
	setPrevTopicFlag(true);
	
	axios
	  .get<any>(`http://${ServerAddress}:${ServerPort}/faqapi/TopicGetById/${topicid}`)
	  .then((result: any) => {
	    setResponse(result.data);
		if (response.FileFlg) {
			setFileFlag(true);
		}
		else {
			setFileFlag(false);
		}
		setRefTopics(result.data.RefArray);
	  })
      .catch((error: any) => {
	     setIsError(true)
		 setErrorText(error.response.data.summary);
	  })
      .finally(() => setIsLoading(false))
  };
  
  const [width, height] = useWindowSize();
  
  return (
    <>
    <div className="title">
	<Header />
	</div>
    <div className="query">
	<Query onClickItem = {onClickItem} onClickFetchTopicList = {onClickFetchTopicList} />
    {prevtopicflag  ? (<button onClick={() => onClickItem(prevtopicid)}>前のトピックに戻る</button>):
    (<button onClick={() => onClickItem(prevtopicid)} disabled>前のトピックに戻る</button>)}
	{isError && <p style={{ color: "red" }}>エラーが発生しました　{`${errortext}`}</p>}
	</div>
    <div className="topiclist" style = {{ float: "left",width: "40%",height: `${height*0.9}px`,overflow: "auto",border: "solid #000000 1px"}}>	
    <TopicList isLoading = {isLoading} topicList = {topicList} onClickItem = {onClickItem} />
    </div>
    <div id="topiccontent" style = {{ width: "60%",height: `${height*0.55}px`,overflow: "auto",border: "solid #000000 1px"}}>
    <TopicContent response = {response} />
    </div>
    <div id="topiccontent" style = {{ width: "60%",height: `${height*0.05}px`,overflow: "auto",border: "solid #000000 1px"}}>
    <div><p>該当する製品: {response.ProductText}</p></div>
    </div>
    <div id="relatedtopics" style = {{ width: "60%",height: `${height*0.2}px`,overflow: "auto",border: "solid #000000 1px"}}>
    <RelatedTopics reftopics = {reftopics} onClickItem = {onClickItem2} />
    </div>
    <div id="downloadfile" style = {{ width: "60%",height: `${height*0.1}px`,overflow: "auto",border: "solid #000000 1px"}}>
	<DownloadFile fileflag = {fileflag} response = {response} />
    </div>	
    </>	
  );	
}
export default App;
