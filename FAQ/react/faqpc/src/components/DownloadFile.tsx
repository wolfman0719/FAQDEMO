import React from 'react';

export const DownloadFile = (props: any) => {

const {fileflag, response} = props;
    
  return (
    <>
    {fileflag && <a href = {response.DownloadFile}>添付ファイル<i className="bi bi-download fs-4 text-info bg-white p-2"></i></a>}
    </>	
  );	
}
export default DownloadFile;
