import React from 'react';
import axios from "axios";
import { BrowserRouter, Route, Link, useParams } from "react-router-dom";
import { useEffect, useState } from "react";
import configinfo from './serverconfig.json';

export const TopicContent = () => {

const {topicid} = useParams();

const [isLoading, setIsLoading] = useState(false);
const [isError, setIsError] = useState(false);
const [response, setResponse] = useState<any>("");
const [reftopics, setRefTopics] = useState<any>([]);
const [errortext, setErrorText] = useState<any>("");
const [fileflag, setFileFlag] = useState(false);
  
const ServerAddress = configinfo.ServerAddress;
const ServerPort = configinfo.ServerPort;

 useEffect( () => {

	setIsLoading(true);
	setIsError(false);

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
      .finally(() => setIsLoading(false));}, []);   
        
  return (
    <>
    <div style = {{ width: "100%",height: "15%",overflow: "auto",border: "solid #000000 1px"}}><h4 style = {{ marginLeft: "20px", marginRight: "20px"}}>{response.id}  {response.Title}</h4><h5 style = {{ marginLeft: "90%", marginRight: "20px"}}>{response.VersionRange}</h5></div>
    {(response.DCURL === "") && <div style = {{ marginLeft: "20px", marginRight: "20px"}}><span dangerouslySetInnerHTML={{__html: response.Description}}></span></div>}	
    {(response.DCURL !== "") && (response.DCURL !== undefined ) && <div style = {{ marginLeft: "20px", marginRight: "20px"}}><span><p>最新内容は、デベロッパーコミュニティをご参照ください</p><a href={response.DCURL}  target="_blank" rel="noreferrer">デベロッパーコミュニティの記事</a></span></div>}	
    </>	
  );	
}
export default TopicContent;
