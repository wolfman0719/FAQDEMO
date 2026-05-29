import React from 'react';

export const RelatedTopics = (props: any) => {

  const {onClickItem, reftopics} = props;
  const comma: string = ",";

      
  return (
    <>
    <p style={{color: "#0d6efd", margin: "0 0 6px"}}>関連トピック</p>
    <table style = {{width: "100%"}}><tbody>
	
	  {	  
        reftopics.map((reftopic: any, index: number) => (
        <tr key={index}>
        <button style={{width: "100%", textAlign: "left"}} className="btn-flat waves-effect black-text" onClick={() => onClickItem(reftopic.split(comma)[0])}>{`${reftopic.split(comma)[0]}:${reftopic.split(comma)[1]}`}</button>
        </tr>
        )        
    )}
	</tbody></table>
    </>	
  );	
}
export default RelatedTopics;
