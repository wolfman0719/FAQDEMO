import React from 'react';
import axios from "axios";
import { useEffect, useState } from "react";
import { Link } from 'react-router-dom';
import { useWindowSize } from "../hooks/useWindowSize";
import configinfo from '../serverconfig.json';

export const TopicList = (props: any) => {

// eslint-disable-next-line
let {keyword} = props;

// eslint-disable-next-line
if (keyword === undefined) {let keyword = ''};

const [topicList, setTopicList] = useState<any>([]);
const [isLoading, setIsLoading] = useState(false);
const [isError, setIsError] = useState(false);
const [errortext, setErrorText] = useState<any>("");

const ServerAddress = configinfo.ServerAddress;
const ServerPort = configinfo.ServerPort;
const Username = configinfo.Username;
const Password = configinfo.Password;
const ApplicationName = configinfo.ApplicationName;
const Protocol = configinfo.Protocol;

const [width] = useWindowSize();

 
 useEffect( () => {

	setIsLoading(true);
    setIsError(false);
  
	axios
	  .get<any>(`${Protocol}://${ServerAddress}:${ServerPort}${ApplicationName}/TopicSearchByKeyword/z${keyword}?IRISUsername=${Username}&IRISPassword=${Password}`)
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
        console.log('error = ' + error);
		setErrorText(error.response.data.summary);
	  })
	  // eslint-disable-next-line react-hooks/exhaustive-deps
      .finally(() => setIsLoading(false));}, [keyword]);   

  return (
    <>
	<table style = {{width: "100%"}}><tbody>
	  {isError && <p style={{ color: "red" }}>エラーが発生しました　{`${errortext}`}</p>}
	  {isLoading ? (<p>Data Loading</p>)
		 : (
		 topicList.map((topic: any, index: number) => (
		 
		 <tr key={topic.id} style={{width: "100%", backgroundColor: index % 2 === 0 ? "#ffffff" : "#f5f5f5"}}><td style={{padding: "10px 14px", whiteSpace: "nowrap", color: "#000000"}}>{`${topic.id}`}</td><td style={{padding: "0", width: "100%"}}><Link to={topic.linkto} style={{textDecoration: "none"}}><div className="topic-list-item" style={{display: "flex", alignItems: "center", justifyContent: "space-between", padding: "10px 14px", cursor: "pointer"}}><div style={{whiteSpace: "nowrap", overflow: "hidden", width: width-120, textOverflow: "ellipsis", color: "#000000"}}>{`${topic.title}`}</div><i className="bi bi-chevron-right" style={{color: "#888"}}></i></div></Link></td></tr>
		 )))
	  }
	</tbody></table>
    </>	
  );	
}
export default TopicList;