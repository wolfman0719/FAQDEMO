import React from 'react';

export const DownloadFile = (props: any) => {

const {fileflag, response} = props;
    
  return (
    <>
    {fileflag && <a href={response.DownloadFile} style={{backgroundColor: "#9e9e9e", color: "#ffffff", borderRadius: "20px", padding: "8px 16px", display: "inline-flex", alignItems: "center", gap: "4px", fontSize: "0.9rem", textDecoration: "none", width: "fit-content"}}>添付ファイル<i className="material-icons" style={{fontSize: "18px"}}>file_download</i></a>}
    </>	
  );	
}
export default DownloadFile;
