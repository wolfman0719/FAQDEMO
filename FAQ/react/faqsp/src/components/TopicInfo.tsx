import React, { useState, useEffect } from 'react';
import axios from "axios";
import { useParams, useNavigate } from "react-router-dom";
import { TopicContent } from './TopicContent';
import { RelatedTopics } from './RelatedTopics';
import { DownloadFile } from './DownloadFile';
import { useWindowSize } from "../hooks/useWindowSize";
import configinfo from '../serverconfig.json';

export const TopicInfo = (props: any) => {

const {topicid} = useParams();

const navigate = useNavigate();

const [isLoading, setIsLoading] = useState(false);
const [isError, setIsError] = useState(false);
const [response, setResponse] = useState<any>("");
const [fileflag, setFileFlag] = useState(false);
const [reftopics, setRefTopics] = useState<any>([]);
const [errortext, setErrorText] = useState<any>("");
  
const ServerAddress = configinfo.ServerAddress;
const ServerPort = configinfo.ServerPort;
const Username = configinfo.Username;
const Password = configinfo.Password;
const ApplicationName = configinfo.ApplicationName;
const Protocol = configinfo.Protocol;

const onClickItem2 = (topicid: any) => {
	setIsLoading(true);
	setIsError(false);
	
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

  useEffect( () => {

	setIsLoading(true);
	setIsError(false);

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
	  // eslint-disable-next-line react-hooks/exhaustive-deps
      .finally(() => setIsLoading(false));}, []);   

	  const [,height] = useWindowSize();
        
  return (
    <div style={{padding: "8px", display: "flex", flexDirection: "column", gap: "8px"}}>
      <button className="faq-btn" onClick={() => {navigate(-1)}} style={{alignSelf: "flex-start"}}>
        <i className="bi bi-caret-left-fill" style={{color: "#ffffff"}}></i>検索に戻る
      </button>
      {isError && <p style={{ color: "red" }}>エラーが発生しました　{`${errortext}`}</p>}
      {isLoading && <p>Laoding...</p>}
      <div style={{background: "#ffffff", borderRadius: "12px", padding: "12px", marginBottom: "8px", display: "flex", alignItems: "center", gap: "12px", overflow: "hidden"}}>
        <img src="../images/Question.gif" alt="Question" style={{width: "32px", height: "32px", flexShrink: 0}} />
        <span style={{fontSize: "1.5rem", color: "#1565c0", flex: 1, whiteSpace: "nowrap", overflow: "hidden", textOverflow: "ellipsis"}}>{response.Title}</span>
        <span style={{fontSize: "1.5rem", color: "#00897b", flexShrink: 0, whiteSpace: "nowrap"}}>{response.VersionRange}</span>
      </div>
      <div className="faq-card" style={{height: `${height*0.55}px`, overflow: "auto"}}>
        <TopicContent response={response} />
      </div>
      <div className="faq-card" style={{overflow: "auto"}}>
        <p style={{margin: 0, color: "var(--faq-primary-color)"}}>該当する製品: <span style={{color: "#000000"}}>{response.ProductText}</span></p>
      </div>
      <div className="faq-card" style={{overflow: "auto"}}>
        <RelatedTopics reftopics={reftopics} onClickItem={onClickItem2} />
      </div>
      {fileflag && <div className="faq-card" style={{overflow: "auto"}}>
        <DownloadFile fileflag={fileflag} response={response} />
      </div>}
    </div>
  );	
}
export default TopicInfo;
