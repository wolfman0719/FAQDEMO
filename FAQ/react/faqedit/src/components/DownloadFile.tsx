import React from 'react';

export const DownloadFile = (props: any) => {

const {fileflag, response} = props;
    
  return (
    <>
    {fileflag && <a className="btn grey lighten-1 white-text waves-effect waves-light" style={{ borderRadius: "24px" }} href={response.DownloadFile}>添付ファイル<i className="material-icons right">get_app</i></a>}
    </>	
  );	
}
export default DownloadFile;
