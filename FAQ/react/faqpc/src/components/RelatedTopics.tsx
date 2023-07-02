import React from 'react';

export const RelatedTopics = (props: any) => {

  const {onClickItem, reftopics} = props;
  const comma: string = ",";

      
  return (
    <>
    <p>関連トピック</p>
    <table><tbody>
	
	  {	  
        reftopics.map((reftopic: any) => (
		  <tr>
		  <button style = {{width: "800px",textAlign: "left"}} className="topictitle" onClick={() => onClickItem(reftopic.split(comma)[0])}>{`${reftopic.split(comma)[0]}:${reftopic.split(comma)[1]}`}</button>
		  </tr>
    	)
    )}
	</tbody></table>
    </>	
  );	
}
export default RelatedTopics;
