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
		   setErrorText(error.toJSON());
		 } 
		 else {
		   setErrorText(error.message + error.toJSON());
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
		   setErrorText(error.toJSON());
		 } 
		 else {
		   setErrorText(error.message + error.toJSON());
		 }
	  })
	  // eslint-disable-next-line react-hooks/exhaustive-deps
      .finally(() => setIsLoading(false));}, []);   

	  const [,height] = useWindowSize();
        
  return (
    <>
    <button className = "btn btn-light" onClick={() => {navigate(-1)}}><i className="bi bi-caret-left-fill"></i></button>
    {isError && <p style={{ color: "red" }}>エラーが発生しました　{`${errortext}`}</p>}
    {isLoading && <p>Laoding...</p>}
    <div style = {{ width: "100%",height: "15%",overflow: "auto",border: "solid #000000 1px"}}><img src="./images/Question.gif" alt="Question" /><span className="text-primary fs-4" style = {{ marginLeft: "20px", marginRight: "20px"}}>{response.Title}</span><p className="text-info fs-4" style = {{ float: "right", marginRight: "20px"}}>{response.VersionRange}</p></div>
    <div id="topiccontent" style = {{ width: "100%",height: `${height*0.60}px`,overflow: "auto",border: "solid #000000 1px"}}>
    <TopicContent response = {response} />
    </div>
    <div id="topiccontent" style = {{ width: "1000%",height: `${height*0.05}px`,overflow: "auto",border: "solid #000000 1px"}}>
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
export default TopicInfo;

