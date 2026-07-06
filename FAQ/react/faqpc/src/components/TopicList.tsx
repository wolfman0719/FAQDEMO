import React from 'react';

export const TopicList = (props: any) => {

const {isLoading, onClickItem, topicList} = props;

  return (
    <>
    <table style={{ width: "100%" }}><tbody>
      {isLoading ? (<tr><td>Data Loading</td></tr>)
         : (
         topicList.map((topic: any, index: number) => (
         <tr key={index} style={{ backgroundColor: index % 2 === 0 ? "#f5f5f5" : "#ffffff" }}>
         <td style={{ width: "60px", minWidth: "60px", maxWidth: "60px", padding: "8px", color: "#000000", whiteSpace: "nowrap", verticalAlign: "middle" }}>{topic.id}</td>
         <td style={{ padding: 0, verticalAlign: "middle" }}><button className="btn-flat waves-effect topic-item-btn" style={{ width: "100%", textAlign: "left", color: "#000000", textTransform: "none", padding: "8px 16px", display: "block" }} onClick={() => onClickItem(topic.id)}>{topic.title}</button></td>
         </tr>
         )))
      }
    </tbody></table>
    </>
  );
}
export default TopicList;
