import React from 'react';

export const TopicList = (props: any) => {

const {isLoading, onClickItem, topicList} = props;

  return (
    <>
    <table style={{ width: "100%", tableLayout: "fixed" }}><tbody>
      {isLoading ? (<tr><td>Data Loading</td></tr>)
         : (
         topicList.map((topic: any, index: number) => (
         <tr key={index} className="topic-row" style={{ backgroundColor: index % 2 === 0 ? "#f5f5f5" : "#ffffff" }}>
         <td style={{ width: "60px", minWidth: "60px", maxWidth: "60px", padding: "8px", color: "#000000", whiteSpace: "nowrap", verticalAlign: "middle" }}>{topic.id}</td>
         <td style={{ padding: 0, verticalAlign: "middle" }}><div className="topic-item-btn topic-title-btn" style={{ padding: "8px 16px", color: "#000000", cursor: "pointer" }} onClick={() => onClickItem(topic.id)}>{topic.title}</div></td>
         </tr>
         )))
      }
    </tbody></table>
    </>
  );
}
export default TopicList;
