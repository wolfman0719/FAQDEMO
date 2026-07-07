import React from 'react';

export const RelatedTopics = (props: any) => {

  const {onClickItem, reftopics} = props;
  const comma: string = ",";


  return (
    <>
    <p className="blue-text text-darken-2">関連トピック</p>
    <table style={{ width: "100%" }}><tbody>

	  {
        reftopics.map((reftopic: any, index: number) => (
		  <tr key={index} className="topic-row" style={{ backgroundColor: index % 2 === 0 ? "#f5f5f5" : "#ffffff" }}>
		  <td style={{ width: "60px", minWidth: "60px", maxWidth: "60px", padding: "8px", color: "#000000", whiteSpace: "nowrap", verticalAlign: "middle" }}>{reftopic.split(comma)[0]}</td>
		  <td style={{ padding: 0, verticalAlign: "middle" }}><button style={{ width: "100%", textAlign: "left", color: "#000000", padding: "8px 16px", display: "flex", alignItems: "center" }} className="btn-flat waves-effect topic-item-btn" onClick={() => onClickItem(reftopic.split(comma)[0])}>{reftopic.split(comma)[1]}</button></td>
		  </tr>
    	)
    )}
	</tbody></table>
    </>
  );
}
export default RelatedTopics;
