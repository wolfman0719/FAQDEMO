import React from 'react';
import axios from "axios";
import { useEffect, useState } from "react";
import { Link } from 'react-router-dom';
import { useWindowSize } from "../hooks/useWindowSize";
import configinfo from '../serverconfig.json';

export const TopicList = (props: any) => {

const {keyword} = props;

const [topicList, setTopicList] = useState<any>([]);
const [isLoading, setIsLoading] = useState(false);
const [isError, setIsError] = useState(false);
const [errortext, setErrorText] = useState<any>("");

const ServerAddress = configinfo.ServerAddress;
const ServerPort = configinfo.ServerPort;
const Username = configinfo.Username;
const Password = configinfo.Password;

const [width,height] = useWindowSize();

 
 useEffect( () => {

	setIsLoading(true);
    setIsError(false);
  
	axios
	  .get<any>(`http://${ServerAddress}:${ServerPort}/faqapi/TopicSearchByKeyword/z${keyword}?IRISUsername=${Username}&IRISPassword=${Password}`)
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
		setErrorText(error.response.data.summary);
	  })
      .finally(() => setIsLoading(false));}, [keyword]);   

  return (
    <>
	<table style = {{width: "100%"}}><tbody>
	  {isLoading ? (<p>Data Loading</p>)
		 : (
		 topicList.map((topic: any) => (
		 <tr>
		 <Link to={topic.linkto}><button className = "btn btn-outline-primary" style = {{width: "100%",textAlign: "left"}}><div style = {{whiteSpace: "nowrap",overflow: "hidden", width: width-10,textOverflow: "ellipsis"}}>{`${topic.title}`}</div></button></Link>
		 </tr>
		 )))
	  }
	</tbody></table>
    </>	
  );	
}
export default TopicList;