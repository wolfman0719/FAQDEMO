import React from 'react';

export const TopicContent = (props: any) => {

  const {response} = props; 
        
  return (
    <>
    {(response.VersionRange !== "") && <div style = {{ width: "100%",height: "6%",overflow: "auto"}}><span   className="fs-6 text-info" style = {{ float: "right", marginRight: "20px"}}>該当バージョン: {response.VersionRange}</span></div>}
    <div style = {{ width: "100%",height: "10%",overflow: "auto",border: "solid #000000 1px"}}><span  className="fs-4 text-primary" style = {{ marginLeft: "20px", marginRight: "20px"}}><i className="bi bi-question-square-fill text-info bg-white"></i> {response.Title}</span></div>
    {(response.DCURL === "") && <div style = {{ marginLeft: "20px", marginRight: "20px"}}><span dangerouslySetInnerHTML={{__html: response.Description}}></span></div>}	
    {(response.DCURL !== "") && (response.DCURL !== undefined ) && <div style = {{ marginLeft: "20px", marginRight: "20px"}}><span><p>最新内容は、デベロッパーコミュニティをご参照ください</p><a href={response.DCURL}  target="_blank" rel="noreferrer">デベロッパーコミュニティの記事</a></span></div>}	
    </>	
  );	
}
export default TopicContent;
