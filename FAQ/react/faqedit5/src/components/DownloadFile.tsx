import React from 'react';

export const DownloadFile = (props: any) => {

const {fileflag, response} = props;
    
  return (
    <>
    {fileflag && <a href={response.DownloadFile} className="gray-action-btn">添付ファイル<i className="material-icons" style={{fontSize: "18px"}}>file_download</i></a>}
    </>	
  );	
}
export default DownloadFile;
