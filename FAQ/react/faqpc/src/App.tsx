import React from 'react';
import axios from "axios";
import { useState, useEffect, useMemo, useCallback } from "react";
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
  const Username = configinfo.Username;
  const Password = configinfo.Password;
  const ApplicationName = configinfo.ApplicationName;
  const Protocol = configinfo.Protocol;
  
  const onClickFetchTopicList = (keyword: any) => {
	
	setIsLoading(true);
    setIsError(false);
  
	axios
	  .get<any>(`${Protocol}://${ServerAddress}:${ServerPort}${ApplicationName}/TopicSearchByKeyword/z${keyword}?IRISUsername=${Username}&IRISPassword=${Password}`)
	  .then((result: any) => {
	  const topics = result.data.map((topic: any) => ({
		id: topic.id,
		title: topic.title
      }));
      setTopicList(topics);
	  })
      .catch((error: any) => {
        setIsError(true)
		 if (error.response) {			
		   setErrorText(error.response.data.summary);
		 }
		 else if (error.request) {
		   setErrorText(error.toJSON());
		 } 
		 else {
		   setErrorText(error.message);
		 }

	  })
      .finally(() => setIsLoading(false));
  };
  
   const onClickItem = useCallback((topicid: any) => {
	setIsLoading(true);
	setIsError(false);
	setPrevTopicFlag(false);
	setPrevTopicId(topicid);

	axios
	   // eslint-disable-next-line
	  .get<any>(`${Protocol}://${ServerAddress}:${ServerPort}${ApplicationName}/TopicGetById/${topicid}?IRISUsername=${Username}&IRISPassword=${Password}`)
	  .then((result: any) => {
	    setResponse(result.data);
		if (result.data.FileFlg) {
			setFileFlag(true);
		}
		else {
			setFileFlag(false);
		}
		setRefTopics(result.data.RefArray);
	  })
      .catch((error: any) => {
	     setIsError(true)
		 if (error.response) {			
		   setErrorText(error.response.data.summary);
		 }
		 else if (error.request) {
		   setErrorText(error.toJSON());
		 } 
		 else {
		   setErrorText(error.message);
		 }

	  })
      .finally(() => setIsLoading(false))
  // eslint-disable-next-line
  }, []);

   const onClickItem2 = (topicid: any) => {
	setIsLoading(true);
	setIsError(false);
	setPrevTopicFlag(true);
	
	axios
	  .get<any>(`${Protocol}://${ServerAddress}:${ServerPort}${ApplicationName}/TopicGetById/${topicid}?IRISUsername=${Username}&IRISPassword=${Password}`)
	  .then((result: any) => {
	    setResponse(result.data);
		if (result.data.FileFlg) {
			setFileFlag(true);
		}
		else {
			setFileFlag(false);
		}
		setRefTopics(result.data.RefArray);
	  })
      .catch((error: any) => {
	     setIsError(true)
		 if (error.response) {			
		   setErrorText(error.response.data.summary);
		 }
		 else if (error.request) {
		   setErrorText(error.toJSON());
		 } 
		 else {
		   setErrorText(error.message);
		 }

	  })
      .finally(() => setIsLoading(false))
  };
  
  const [,height] = useWindowSize();

  useEffect( () => {

	setIsLoading(true);
    setIsError(false);
  
	axios
	  .get<any>(`${Protocol}://${ServerAddress}:${ServerPort}${ApplicationName}/TopicSearchByNew?IRISUsername=${Username}&IRISPassword=${Password}`)
	  .then((result: any) => {
	  const topics = result.data.map((topic: any) => ({
		id: topic.id,
		title: topic.title
      }));
      setTopicList(topics);
	  })
      .catch((error: any) => {
        setIsError(true)
		setErrorText(error.message + error.toJSON());
	  })
      .finally(() => setIsLoading(false));
      
	  // eslint-disable-next-line
      }, []);
  
    // eslint-disable-next-line
    const TopicListMemo = useMemo(() => <TopicList isLoading = {isLoading} topicList = {topicList} onClickItem = {onClickItem} />, [onClickItem,topicList]);

    return (
    <>
    <div className="title">
	<Header />
	</div>
    <div className="query">
	<Query onClickItem = {onClickItem} onClickFetchTopicList = {onClickFetchTopicList} />
    {prevtopicflag  ? (<button className="btn btn-secondary" onClick={() => onClickItem(prevtopicid)}><i className="bi bi-arrow-left"></i>前のトピックに戻る</button>):
    (<button  className="btn btn-secondary" onClick={() => onClickItem(prevtopicid)} disabled><i className="bi bi-arrow-left"></i>前のトピックに戻る</button>)}
	{isError && <p style={{ color: "red" }}>エラーが発生しました　{`${errortext}`}</p>}
	</div>
    <div className="topiclist" style = {{ float: "left",width: "40%",height: `${height*0.81}px`,overflow: "auto",border: "solid #000000 1px"}}>	
    {TopicListMemo}
    </div>
	<div id="topiccontent" style = {{ width: "60%",height: `${height*0.05}px`,overflow: "auto",border: "solid #000000 1px"}}><span  className="fs-5 text-primary" style = {{ marginLeft: "20px", marginRight: "20px"}}><img src="./images/Question.gif" alt="Question"/> {response.Title}</span><p className="text-info fs-4" style = {{ float: "right", marginRight: "20px"}}>{response.VersionRange}</p>
    </div>
    <div id="topiccontent" style = {{ width: "60%",height: `${height*0.45}px`,overflow: "auto",border: "solid #000000 1px"}}>
    <TopicContent response = {response} />
    </div>
    <div id="topiccontent" style = {{ width: "60%",height: `${height*0.05}px`,overflow: "auto",border: "solid #000000 1px"}}>
    <div><p className="text-primary">該当する製品: <span className="text-black">{response.ProductText}</span></p></div>
    </div>
    <div id="relatedtopics" style = {{ width: "60%",height: `${height*0.2}px`,overflow: "auto",border: "solid #000000 1px"}}>
    <RelatedTopics reftopics = {reftopics} onClickItem = {onClickItem2} />
    </div>
    <div id="downloadfile" style = {{ width: "60%",height: `${height*0.06}px`,overflow: "auto",border: "solid #000000 1px"}}>
	<DownloadFile fileflag = {fileflag} response = {response} />
    </div>	
    </>	
  );	
}
export default App;

