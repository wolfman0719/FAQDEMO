import React from 'react';

export const DownloadFile = (props: any) => {

const {fileflag, response} = props;
    
  return (
    <>
    {fileflag && <a href = {response.DownloadFile}>添付ファイル</a>}
    </>	
  );	
}
export default DownloadFile;
