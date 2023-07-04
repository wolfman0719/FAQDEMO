import React from 'react';

export const TopicList = (props: any) => {

const {isLoading, onClickItem, topicList} = props;
    
  return (
    <>
	<table><tbody>
	  {isLoading ? (<p>Data Loading</p>)
		 : (
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
