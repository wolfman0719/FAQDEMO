import React from 'react';

export const RelatedTopics = (props: any) => {

  const {onClickItem, reftopics} = props;
  const comma: string = ",";


  return (
    <>
    <p className="blue-text text-darken-2">関連トピック</p>
    <table style={{ width: "100%", tableLayout: "fixed" }}><tbody>

	  {
        reftopics.map((reftopic: any, index: number) => (
		  <tr key={index} className="topic-row" style={{ backgroundColor: index % 2 === 0 ? "#f5f5f5" : "#ffffff" }}>
		  <td style={{ width: "60px", minWidth: "60px", maxWidth: "60px", padding: "8px", color: "#000000", whiteSpace: "nowrap", verticalAlign: "middle" }}>{reftopic.split(comma)[0]}</td>
		  <td style={{ padding: 0, verticalAlign: "middle", overflow: "hidden" }}><div className="topic-item-btn topic-title-btn" style={{ padding: "8px 16px", color: "#000000", cursor: "pointer" }} onClick={() => onClickItem(reftopic.split(comma)[0])}>{reftopic.split(comma)[1]}</div></td>
		  </tr>
    	)
    )}
	</tbody></table>
    </>
  );
}
export default RelatedTopics;
