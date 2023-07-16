import React from 'react';

export const TopicList = (props: any) => {

const {isLoading, onClickItem, topicList} = props;
    
  return (
    <>
	<table style = {{width: "100%"}}><tbody>
	  {isLoading ? (<p>Data Loading</p>)
		 : (
		 topicList.map((topic: any) => (
		 <tr>
		 <button className = "btn btn-outline-primary" style = {{width: "100%", textAlign: "left"}} onClick={() => onClickItem(topic.id)}>{`${topic.id}:${topic.title}`}</button>
		 </tr>
		 )))
	  }
	</tbody></table>
    </>	
  );	
}
export default TopicList;
