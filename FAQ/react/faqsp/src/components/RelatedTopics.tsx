import React from 'react';

export const RelatedTopics = (props: any) => {

  const {onClickItem, reftopics} = props;
  const comma: string = ",";

      
  return (
    <>
    <p style={{color: "var(--faq-primary-color)", fontWeight: "normal"}}>関連トピック</p>
    <table style={{width: "100%", borderCollapse: "collapse"}}><tbody>

	  {
        reftopics.map((reftopic: any, index: number) => (
        <tr key={index} className="topic-list-row" style={{backgroundColor: index % 2 === 0 ? "#ffffff" : "#f5f5f5"}}>
        <td style={{padding: "10px 14px", whiteSpace: "nowrap", color: "#000000"}}>{reftopic.split(comma)[0]}</td>
        <td style={{padding: 0, width: "100%"}}><button className="related-topic-btn" onClick={() => onClickItem(reftopic.split(comma)[0])}>{reftopic.split(comma)[1]}</button></td>
        </tr>
        )
    )}
	</tbody></table>
    </>	
  );	
}
export default RelatedTopics;
