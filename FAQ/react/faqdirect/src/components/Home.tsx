import React from 'react';
import axios from "axios";
import { useState, useEffect } from "react";
import { useParams } from "react-router-dom";
import { Header } from './Header';
import { TopicContent } from './TopicContent';
import { RelatedTopics } from './RelatedTopics';
import { DownloadFile } from './DownloadFile';
import { useWindowSize } from "../hooks/useWindowSize";
import configinfo from '../serverconfig.json';

export const Home = (props: any) => {

  const [topicList, setTopicList] = useState<any>([]);
  const [isLoading, setIsLoading] = useState(false);
  const [isError, setIsError] = useState(false);
  const [response, setResponse] = useState<any>("");
  const [reftopics, setRefTopics] = useState<any>([]);
  const [errortext, setErrorText] = useState<any>("");
  const [fileflag, setFileFlag] = useState(false);
  
  const ServerAddress = configinfo.ServerAddress;
  const ServerPort = configinfo.ServerPort;
  const Username = configinfo.Username;
  const Password = configinfo.Password;
  const ApplicationName = configinfo.ApplicationName;
  
  const {topicid} = useParams();
  
  console.log('topic id = ' + topicid);

  const onClickItem2 = (topicid: any) => {
	setIsLoading(true);
	setIsError(false);
	
	axios
	  .get<any>(`http://${ServerAddress}:${ServerPort}${ApplicationName}/TopicGetById/${topicid}?IRISUsername=${Username}&IRISPassword=${Password}`)
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
		 setErrorText(error.message);
	  })
      .finally(() => setIsLoading(false))
  };
  
  const [,height] = useWindowSize();
  
  useEffect( () => {

	setIsLoading(true);
	setIsError(false);

	axios
	  .get<any>(`http://${ServerAddress}:${ServerPort}${ApplicationName}/TopicGetById/${topicid}?IRISUsername=${Username}&IRISPassword=${Password}`)
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
      
      }, []);
  
  return (
    <>
    <div className="title">
	<Header />
	</div>
	{isError && <p style={{ color: "red" }}>エラーが発生しました　{`${errortext}`}</p>}
    <div id="topiccontent" style = {{ width: "100%",height: `${height*0.50}px`,overflow: "auto",border: "solid #000000 1px"}}>
    <TopicContent response = {response} />
    </div>
    <div id="topiccontent" style = {{ width: "100%",height: `${height*0.05}px`,overflow: "auto",border: "solid #000000 1px"}}>
    <div><p className="text-primary">該当する製品: <span className="text-black">{response.ProductText}</span></p></div>
    </div>
    <div id="relatedtopics" style = {{ width: "100%",height: `${height*0.2}px`,overflow: "auto",border: "solid #000000 1px"}}>
    <RelatedTopics reftopics = {reftopics} onClickItem = {onClickItem2} />
    </div>
    <div id="downloadfile" style = {{ width: "100%",height: `${height*0.06}px`,overflow: "auto",border: "solid #000000 1px"}}>
	<DownloadFile fileflag = {fileflag} response = {response} />
    </div>	
    </>	
  );	
}
export default Home;
