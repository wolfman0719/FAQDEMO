import React, { useState, useEffect } from 'react';
import axios from "axios";
import { useParams, useNavigate } from "react-router-dom";
import { useEffect, useState } from "react";
import configinfo from '../serverconfig.json';

import hljs from 'highlight.js/lib/core';
import 'highlight.js/styles/panda-syntax-light.css';
import xml from 'highlight.js/lib/languages/xml';
import python from 'highlight.js/lib/languages/python';
import javascript from 'highlight.js/lib/languages/javascript';
import cos from 'highlight.js/lib/languages/cos';
import sql from 'highlight.js/lib/languages/sql';
import json from 'highlight.js/lib/languages/json';
import yaml from 'highlight.js/lib/languages/yaml';
import dockerfile from 'highlight.js/lib/languages/dockerfile';
import java from 'highlight.js/lib/languages/java';
import css from 'highlight.js/lib/languages/css';
import csharp from 'highlight.js/lib/languages/csharp';


hljs.registerLanguage('xml', xml);
hljs.registerLanguage('python', python);
hljs.registerLanguage('javascript', javascript);
hljs.registerLanguage('cos', cos);
hljs.registerLanguage('sql', sql);
hljs.registerLanguage('json', json);
hljs.registerLanguage('yaml', yaml);
hljs.registerLanguage('dockerfile', dockerfile);
hljs.registerLanguage('java', java);
hljs.registerLanguage('css', css);
hljs.registerLanguage('csharp', csharp);

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
const ApplicationName = configinfo.ApplicationName;
const Protocol = configinfo.Protocol;

 useEffect( () => {

    hljs.initHighlighting();
	setIsLoading(true);
	setIsError(false);

	axios
	  .get<any>(`${Protocol}://${ServerAddress}:${ServerPort}${ApplicationName}/TopicGetById/${topicid}?IRISUsername=${Username}&IRISPassword=${Password}`)
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
