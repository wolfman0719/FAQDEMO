import React, { useState, useEffect } from 'react';
import axios from "axios";
import { useParams, useNavigate } from "react-router-dom";
import { TopicContent } from './TopicContent';
import { RelatedTopics } from './RelatedTopics';
import { DownloadFile } from './DownloadFile';
import { useWindowSize } from "../hooks/useWindowSize";
import configinfo from '../serverconfig.json';

export const TopicInfo = (props: any) => {

let topicid: any = useParams().topicid;

if ((localStorage.getItem('topicid') !== null) && (localStorage.getItem('topicid') !== undefined)) {
  topicid = localStorage.getItem('topicid');	
}

const {direct} = props;

const navigate = useNavigate();

const [isLoading, setIsLoading] = useState(false);
const [isError, setIsError] = useState(false);
const [response, setResponse] = useState<any>("");
const [fileflag, setFileFlag] = useState(false);
const [reftopics, setRefTopics] = useState<any>([]);
const [errortext, setErrorText] = useState<any>("");
  
const ServerAddress = configinfo.ServerAddress;
const ServerPort = configinfo.ServerPort;
const ApplicationName = configinfo.ApplicationName;
const Protocol = configinfo.Protocol;

const Username = localStorage.getItem('username');
const Password = localStorage.getItem('password');
const Edit = localStorage.getItem('edit');

const onClickItem2 = (topicid: any) => {
	setIsLoading(true);
	setIsError(false);
	
	axios
	  .get<any>(`${Protocol}://${ServerAddress}:${ServerPort}${ApplicationName}/TopicGetById/${topicid}?IRISUsername=${Username}&IRISPassword=${Password}`)
	  .then((result: any) => {

		setResponse(result.data);
		localStorage.setItem('topicid',topicid);

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
      .finally(() => setIsLoading(false));}, [topicid]);   

	  const [,height] = useWindowSize();
        
  return (
    <>
	{isError && <p className="text-danger fs-3"><span dangerouslySetInnerHTML={{__html: errortext}}></span></p>}
	{(direct === false) &&
	<table>	
	<tr><td><button className = "btn btn-outline-primary" onClick={() => {navigate('/Home',{ state: {username: Username, password: Password, edit: Edit}})}}>検索に戻る<i className="bi bi-search"></i></button></td></tr>
    </table>
	}
	{isLoading && <p>Laoding...</p>}
	<div style = {{ width: "100%",height: "15%",overflow: "auto",border: "solid #000000 1px"}}><img src="../images/Question.gif" alt=''/><span className="text-primary fs-4" style = {{ marginLeft: "20px", marginRight: "20px"}}>{response.Title}</span><p className="text-info fs-4" style = {{ float: "right", marginRight: "20px"}}>{response.VersionRange}</p></div>
    <div id="topiccontent" style = {{ width: "100%",height: `${height*0.65}px`,overflow: "auto",border: "solid #000000 1px"}}>
    <TopicContent response = {response} />
    </div>
    <div id="topiccontent" style = {{ width: "100%",height: `${height*0.05}px`,overflow: "auto",border: "solid #000000 1px"}}>
    <div><p className="text-primary">該当する製品: <span className="text-black">{response.ProductText}</span></p></div>
    </div>
    <div id="relatedtopics" style = {{ width: "100%",height: `${height*0.1}px`,overflow: "auto",border: "solid #000000 1px"}}>
    <RelatedTopics reftopics = {reftopics} onClickItem = {onClickItem2} />
    </div>
    <div id="downloadfile" style = {{ width: "100%",height: `${height*0.05}px`,overflow: "auto",border: "solid #000000 1px"}}>
	<DownloadFile fileflag = {fileflag} response = {response} />
    </div>	
    {(Edit) && <div id="edit" style = {{ width: "100%",height: `${height*0.05}px`,overflow: "auto",border: "solid #000000 1px"}}>
	<table><tr><td><button className = "btn btn-outline-primary" onClick={() => {navigate('/Edit/' + topicid)}}>編集<i className="bi bi-pencil-square"></i></button></td></tr></table>
    </div>}	
    </>	
  );	
}
export default TopicInfo;
