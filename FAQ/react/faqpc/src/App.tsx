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
  const [backBtnHovered, setBackBtnHovered] = useState(false);
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
		   setErrorText(error.request);
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
		   setErrorText(error.request);
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
		   setErrorText(error.request);
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
		setErrorText(error.message);
	  })
      .finally(() => setIsLoading(false));
      
	  // eslint-disable-next-line
      }, []);
  
    // eslint-disable-next-line
    const TopicListMemo = useMemo(() => <TopicList isLoading = {isLoading} topicList = {topicList} onClickItem = {onClickItem} />, [onClickItem,topicList]);

    const cardStyle: React.CSSProperties = { backgroundColor: "white", borderRadius: "12px" };

    return (
    <>
    <div className="title" style={{ ...cardStyle, padding: "12px 16px", marginBottom: "8px" }}>
      <Header />
    </div>
    <div className="query" style={{ ...cardStyle, padding: "12px 16px", marginBottom: "8px" }}>
      <Query onClickItem = {onClickItem} onClickFetchTopicList = {onClickFetchTopicList} />
      {prevtopicflag  ? (<button className="btn white-text waves-effect waves-light" style={{ borderRadius: "24px", backgroundColor: backBtnHovered ? "#757575" : "#bdbdbd" }} onClick={() => onClickItem(prevtopicid)} onMouseEnter={() => setBackBtnHovered(true)} onMouseLeave={() => setBackBtnHovered(false)}><i className="material-icons left">arrow_back</i>前のトピックに戻る</button>):
      (<button  className="btn grey lighten-1 white-text waves-effect waves-light disabled" style={{ borderRadius: "24px" }} onClick={() => onClickItem(prevtopicid)} disabled><i className="material-icons left">arrow_back</i>前のトピックに戻る</button>)}
      {isError && <p style={{ color: "red" }} dangerouslySetInnerHTML={{ __html: `エラーが発生しました　${errortext}` }} />}
    </div>
    <div className="topiclist" style={{ ...cardStyle, float: "left", width: "calc(40% - 4px)", height: `${height*0.81}px`, overflowY: "auto", overflowX: "hidden", marginRight: "8px" }}>
      {TopicListMemo}
    </div>
    <div style={{ width: "calc(60% - 4px)", height: `${height*0.81}px`, display: "flex", flexDirection: "column", gap: "8px" }}>
      <div id="topiccontent" style={{ ...cardStyle, flex: 5, overflowX: "hidden", overflowY: "auto", display: "flex", alignItems: "center" }}>
        <span className="blue-text text-darken-2" style={{ flex: 1, minWidth: 0, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap", marginLeft: "20px", fontSize: "2.0rem" }}><img src="./images/Question.gif" alt="Question"/> {response.Title}</span>
        <p className="teal-text" style={{ flexShrink: 0, marginLeft: "8px", marginRight: "20px", fontSize: "1.5rem" }}>{response.VersionRange}</p>
      </div>
      <div id="topiccontent" style={{ ...cardStyle, flex: 45, overflow: "auto" }}>
        <TopicContent response = {response} />
      </div>
      <div id="topiccontent" style={{ ...cardStyle, flex: 5, overflow: "auto" }}>
        <p className="blue-text text-darken-2" style={{ margin: "4px 0" }}>該当する製品: <span className="black-text">{response.ProductText}</span></p>
      </div>
      <div id="relatedtopics" style={{ ...cardStyle, flex: 20, overflow: "auto" }}>
        <RelatedTopics reftopics = {reftopics} onClickItem = {onClickItem2} />
      </div>
      <div id="downloadfile" style={{ ...cardStyle, flex: 6, overflow: "auto" }}>
        <DownloadFile fileflag = {fileflag} response = {response} />
      </div>
    </div>
    </>
  );	
}
export default App;
