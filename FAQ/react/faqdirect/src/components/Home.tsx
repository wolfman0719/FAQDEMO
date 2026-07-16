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
  const Protocol = configinfo.Protocol;
  
  const {topicid} = useParams();

  const onClickItem2 = (topicid: any) => {
	setIsLoading(true);
	setIsError(false);
	
	axios
	  .get<any>(`${Protocol}://${ServerAddress}:${ServerPort}${ApplicationName}/TopicGetById/${topicid}?IRISUsername=${Username}&IRISPassword=${Password}`)
	  .then((result: any) => {
	    setResponse(result.data);
		setFileFlag(!!result.data.FileFlg);
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
	  .get<any>(`${Protocol}://${ServerAddress}:${ServerPort}${ApplicationName}/TopicGetById/${topicid}?IRISUsername=${Username}&IRISPassword=${Password}`)
	  .then((result: any) => {
	    setResponse(result.data);
		setFileFlag(!!result.data.FileFlg);
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
      // eslint-disable-next-line react-hooks/exhaustive-deps     
      }, []);
  
  const cardStyle: React.CSSProperties = {
    backgroundColor: "#ffffff",
    borderRadius: "12px",
    border: "solid #000000 1px",
    overflow: "auto",
    marginBottom: "8px",
    width: "100%",
  };

  return (
    <div style={{ padding: "16px" }}>
    <div className="title" style={{ ...cardStyle, padding: "12px" }}>
	<Header />
	</div>
	{isError && <p style={{ color: "red" }} dangerouslySetInnerHTML={{ __html: `エラーが発生しました　${errortext}` }} />}
	{isLoading && <p>Loading...</p>}
	<div id="topiccontent" style={{ ...cardStyle, height: `${height*0.05}px` }}><span  className="blue-text" style={{ marginLeft: "20px", marginRight: "20px", fontSize: "1.65rem" }}><img src="../images/Question.gif" alt="Question"/> {response.Title}</span><p className="cyan-text" style={{ float: "right", marginRight: "20px", fontSize: "1.3rem" }}>{response.VersionRange}</p></div>
	<div id="topiccontent" style={{ ...cardStyle, height: `${height*0.45}px` }}>
    <TopicContent response = {response} />
    </div>
    <div id="topiccontent" style={{ ...cardStyle, height: `${height*0.05}px` }}>
    <div><p className="blue-text">該当する製品: <span className="black-text">{response.ProductText}</span></p></div>
    </div>
    <div id="relatedtopics" style={{ ...cardStyle, height: `${height*0.2}px` }}>
    <RelatedTopics reftopics = {reftopics} onClickItem = {onClickItem2} />
    </div>
    <div id="downloadfile" style={{ ...cardStyle, height: `${height*0.06}px` }}>
	<DownloadFile fileflag = {fileflag} response = {response} />
    </div>
    </div>
  );	
}
export default Home;
