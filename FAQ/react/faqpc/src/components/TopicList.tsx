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
         <td><button className="btn-flat waves-effect topic-item-btn" style={{ width: "100%", textAlign: "left", color: "#000000", textTransform: "none" }} onClick={() => onClickItem(topic.id)}>{`${topic.id}:${topic.title}`}</button></td>
         </tr>
         )))
      }
    </tbody></table>
    </>
  );
}
export default TopicList;
