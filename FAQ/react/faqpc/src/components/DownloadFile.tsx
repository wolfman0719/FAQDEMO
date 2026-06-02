import React, { useState } from 'react';

export const DownloadFile = (props: any) => {

const {fileflag, response} = props;
const [hovered, setHovered] = useState(false);

  return (
    <>
    {fileflag && <a
      className="btn white-text waves-effect waves-light"
      style={{ borderRadius: "24px", backgroundColor: hovered ? "#757575" : "#bdbdbd" }}
      href={response.DownloadFile}
      onMouseEnter={() => setHovered(true)}
      onMouseLeave={() => setHovered(false)}
    >添付ファイル<i className="material-icons right">get_app</i></a>}
    </>
  );
}
export default DownloadFile;
