import React from 'react';
import axios from "axios";
import { useEffect, useState } from "react";
import { Link } from 'react-router-dom';
import { useWindowSize } from "../hooks/useWindowSize";
import configinfo from '../serverconfig.json';

export const TopicList = (props: any) => {

// eslint-disable-next-line
const {keyword} = props;

const [topicList, setTopicList] = useState<any>([]);
const [isLoading, setIsLoading] = useState(false);
const [isError, setIsError] = useState(false);
const [errortext, setErrorText] = useState<any>("");

const ServerAddress = configinfo.ServerAddress;
const ServerPort = configinfo.ServerPort;
const ApplicationName = configinfo.ApplicationName;
const Protocol = configinfo.Protocol;

const {username, password} = props;

const [width] = useWindowSize();

 
 useEffect( () => {

	setIsLoading(true);
    setIsError(false);
  
	axios
	  .get<any>(`${Protocol}://${ServerAddress}:${ServerPort}${ApplicationName}/TopicSearchByKeyword/z${keyword}?IRISUsername=${username}&IRISPassword=${password}`)
	  .then((result: any) => {
	  const topics = result.data.map((topic: any) => ({
		id: topic.id,
		title: topic.title,
		linkto: "/Content/" + topic.id
      }));
      setTopicList(topics);
	  })
      .catch((error: any) => {
	     setIsError(true)
		 if (error.response) {			
		   setErrorText('再ログインが必要です');
		 }
		 else if (error.request) {
		   setErrorText(error.request);
		 } 
		 else {
		   setErrorText(error.message);
		 }
	  })
	  // eslint-disable-next-line react-hooks/exhaustive-deps
      .finally(() => setIsLoading(false));}, [keyword]);   

  return (
    <>
	<table style = {{width: "100%"}}><tbody>
	  {isError && <tr><td><p className="text-danger fs-3"><span dangerouslySetInnerHTML={{__html: errortext}}></span></p></td></tr>}
	  {isLoading ? (<tr><td><p>Data Loading</p></td></tr>)
		 : (
		 topicList.map((topic: any) => (
		 
		 <tr key={topic.id} style = {{width: "100%"}}><td><Link to={topic.linkto}><button className = "btn btn-outline-primary" style = {{textAlign: "left"}}><table><tbody><tr><td><div style = {{whiteSpace: "nowrap",overflow: "hidden", width: width-40,textOverflow: "ellipsis"}}>{`${topic.title}`}</div></td><td><i className="bi bi-chevron-right float-end"></i></td></tr></tbody></table></button></Link></td></tr>
		 )))
	  }
	</tbody></table>
    </>	
  );	
}
export default TopicList;