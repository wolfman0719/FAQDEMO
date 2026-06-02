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
		  <tr key={index} style={{ backgroundColor: index % 2 === 0 ? "#f5f5f5" : "#ffffff" }}>
		  <td><button style={{ width: "100%", textAlign: "left", color: "#000000" }} className="btn-flat waves-effect topic-item-btn" onClick={() => onClickItem(reftopic.split(comma)[0])}>{`${reftopic.split(comma)[0]}:${reftopic.split(comma)[1]}`}</button></td>
		  </tr>
    	)
    )}
	</tbody></table>
    </>
  );
}
export default RelatedTopics;
