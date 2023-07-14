import React from 'react';
import axios from "axios";
import { useEffect, useState } from "react";
import { BrowserRouter, Route, Link } from 'react-router-dom';
import configinfo from './serverconfig.json';

export const TopicList = (props: any) => {

const {keyword} = props;

const [topicList, setTopicList] = useState<any>([]);
const [isLoading, setIsLoading] = useState(false);
const [isError, setIsError] = useState(false);
const [response, setResponse] = useState<any>("");
const [reftopics, setRefTopics] = useState<any>([]);
const [errortext, setErrorText] = useState<any>("");

const ServerAddress = configinfo.ServerAddress;
const ServerPort = configinfo.ServerPort;

 
 useEffect( () => {

	setIsLoading(true);
    setIsError(false);
  
	axios
	  .get<any>(`http://${ServerAddress}:${ServerPort}/faqapi/TopicSearchByKeyword/z${keyword}`)
	  .then((result: any) => {
	  const topics = result.data.map((topic: any) => ({
		id: topic.id,
		title: topic.title
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
		 <Link to="/Content/${topic.id}">{`${topic.id}:${topic.title}`}</Link>
		 </tr>
		 )))
	  }
	</tbody></table>
    </>	
  );	
}
export default TopicList;
