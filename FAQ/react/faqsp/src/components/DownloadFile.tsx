import React from 'react';

export const DownloadFile = (props: any) => {

const {fileflag, response} = props;
    
  return (
    <>
    {fileflag && <a href={response.DownloadFile} className="faq-btn">添付ファイル<i className="bi bi-download" style={{fontSize: "1.1rem", color: "#ffffff"}}></i></a>}
    </>	
  );	
}
export default DownloadFile;
