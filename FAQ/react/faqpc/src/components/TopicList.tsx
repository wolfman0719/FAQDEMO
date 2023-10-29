import React from 'react';

export const TopicList = (props: any) => {

const {isLoading, onClickItem, topicList} = props;
    
  return (
    <>
	<table style = {{width: "100%"}}><tbody>
	  {isLoading ? (<tr><td>Data Loading</td></tr>)
		 : (
		 topicList.map((topic: any, index: number) => (
		 <tr key={index}>
		 <td><button className = "btn btn-outline-primary" style = {{width: "100%", textAlign: "left"}} onClick={() => onClickItem(topic.id)}>{`${topic.id}:${topic.title}`}<i className="bi bi-chevron-right float-end"></i></button></td>
		 </tr>
		 )))
	  }
	</tbody></table>
    </>	
  );	
}
export default TopicList;
