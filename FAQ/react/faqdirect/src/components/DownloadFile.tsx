import React, { useState } from 'react';

export const DownloadFile = (props: any) => {

const {fileflag, response} = props;
const [hovered, setHovered] = useState(false);

const btnStyle: React.CSSProperties = {
  backgroundColor: hovered ? "#78909c" : "#b0bec5",
  color: "#ffffff",
  borderRadius: "24px",
  border: "none",
  padding: "8px 20px",
  cursor: "pointer",
  display: "inline-flex",
  alignItems: "center",
  gap: "6px",
  textDecoration: "none",
  transition: "background-color 0.2s",
  fontSize: "1rem",
};

  return (
    <>
    {fileflag && (
      <a
        style={btnStyle}
        href={response.DownloadFile}
        onMouseEnter={() => setHovered(true)}
        onMouseLeave={() => setHovered(false)}
      >
        <i className="material-icons" style={{fontSize: "1.2rem"}}>download</i>
        添付ファイル
      </a>
    )}
    </>
  );
}
export default DownloadFile;
