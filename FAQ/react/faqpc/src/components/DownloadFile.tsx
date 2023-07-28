import React from 'react';

export const DownloadFile = (props: any) => {

const {fileflag, response} = props;
    
  return (
    <>
    {fileflag && <a className="btn btn-secondary" href = {response.DownloadFile}>添付ファイル<i className="bi bi-download fs-4"></i></a>}
    </>	
  );	
}
export default DownloadFile;
