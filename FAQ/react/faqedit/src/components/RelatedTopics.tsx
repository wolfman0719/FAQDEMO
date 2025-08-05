import React from 'react';

export const RelatedTopics = (props: any) => {

  const {onClickItem, reftopics} = props;
  const comma: string = ",";

      
  return (
    <>
    <p className = "text-primary">関連トピック</p>
    <table style = {{width: "100%"}}><tbody>
	
	  {	  
        reftopics.map((reftopic: any, index: number) => (
        <tr key={index}>
        <button style = {{width: "100%",textAlign: "left"}} className = "btn btn-outline-primary" onClick={() => onClickItem(reftopic.split(comma)[0])}>{`${reftopic.split(comma)[0]}:${reftopic.split(comma)[1]}`}</button>
        </tr>
        )        
    )}
	</tbody></table>
    </>	
  );	
}
export default RelatedTopics;
