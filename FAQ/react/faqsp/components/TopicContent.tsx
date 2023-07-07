import React from 'react';

export const TopicContent = (props: any) => {

  const {response} = props; 
        
  return (
    <>
    <div style = {{ width: "100%",height: "15%",overflow: "auto",border: "solid #000000 1px"}}><h4 style = {{ marginLeft: "20px", marginRight: "20px"}}>{response.id}  {response.Title}</h4><h5 style = {{ marginLeft: "90%", marginRight: "20px"}}>{response.VersionRange}</h5></div>
    {(response.DCURL === "") && <div style = {{ marginLeft: "20px", marginRight: "20px"}}><span dangerouslySetInnerHTML={{__html: response.Description}}></span></div>}	
    {(response.DCURL !== "") && (response.DCURL !== undefined ) && <div style = {{ marginLeft: "20px", marginRight: "20px"}}><span><p>最新内容は、デベロッパーコミュニティをご参照ください</p><a href={response.DCURL}  target="_blank" rel="noreferrer">デベロッパーコミュニティの記事</a></span></div>}	
    </>	
  );	
}
export default TopicContent;