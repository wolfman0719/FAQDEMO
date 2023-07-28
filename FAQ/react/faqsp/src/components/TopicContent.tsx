import React from 'react';
import axios from "axios";
import { useParams, useNavigate } from "react-router-dom";
import { useEffect, useState } from "react";
import configinfo from '../serverconfig.json';

export const TopicContent = (props: any) => {

const {topicid} = useParams();

const navigate = useNavigate();

const [isLoading, setIsLoading] = useState(false);
const [isError, setIsError] = useState(false);
const [response, setResponse] = useState<any>("");
const [errortext, setErrorText] = useState<any>("");
  
const ServerAddress = configinfo.ServerAddress;
const ServerPort = configinfo.ServerPort;
const Username = configinfo.Username;
const Password = configinfo.Password;

 useEffect( () => {

	setIsLoading(true);
	setIsError(false);

	axios
	  .get<any>(`http://${ServerAddress}:${ServerPort}/faqapi/TopicGetById/${topicid}?IRISUsername=${Username}&IRISPassword=${Password}`)
	  .then((result: any) => {
	    setResponse(result.data);
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
        
  return (
    <>
    <button className = "btn btn-light" onClick={() => {navigate(-1)}}><i className="bi bi-caret-left-fill"></i></button>
    {isLoading && (<p>Data Loading</p>)}
	{isError && <p style={{ color: "red" }}>エラーが発生しました　{`${errortext}`}</p>}
	<div style = {{ width: "100%",height: "15%",overflow: "auto",border: "solid #000000 1px"}}><i className="bi bi-hand-index bg-light fs-2"></i><span className="text-primary fs-4" style = {{ marginLeft: "20px", marginRight: "20px"}}>{response.Title}</span><p className="text-info fs-4" style = {{ float: "right", marginRight: "20px"}}>{response.VersionRange}</p></div>
    {(response.DCURL === "") && <div style = {{ marginLeft: "20px", marginRight: "20px"}}><span dangerouslySetInnerHTML={{__html: response.Description}}></span></div>}	
    {(response.DCURL !== "") && (response.DCURL !== undefined ) && <div style = {{ marginLeft: "20px", marginRight: "20px"}}><span><p>最新内容は、デベロッパーコミュニティをご参照ください</p><a href={response.DCURL}  target="_blank" rel="noreferrer">デベロッパーコミュニティの記事</a></span></div>}	
    </>	
  );	
}
export default TopicContent;
