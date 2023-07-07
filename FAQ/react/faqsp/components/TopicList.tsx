import React from 'react';
import { useEffect, useState } from "react";
import { BrowserRouter, Route } from 'react-router-dom';
import configinfo from './serverconfig.json';

export const TopicList = (props: any) => {

const {keyword} = props;

const [topicList, setTopicList] = useState<any>([]);
const [isLoading, setIsLoading] = useState(false);
const [isError, setIsError] = useState(false);
const [response, setResponse] = useState<any>("");
const [reftopics, setRefTopics] = useState<any>([]);
const [errortext, setErrorText] = useState<any>("");
 
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
      .finally(() => setIsLoading(false));
  };

})
}, []);   

  return (
    <>
	<table style = {{width: "100%"}}><tbody>
	  {isLoading ? (<p>Data Loading</p>)
		 : (
		 {isError && <p style={{ color: "red" }}>エラーが発生しました　{`${errortext}`}</p>}
		 topicList.map((topic: any) => (
		 <tr>
		 <button style = {{width: "100%", textAlign: "left"}} className="topictitle" onClick={() => onClickItem(topic.id)}>{`${topic.id}:${topic.title}`}</button>
		 </tr>
		 )))
	  }
	</tbody></table>
    </>	
  );	
}
export default TopicList;
