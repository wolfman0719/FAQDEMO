import React from 'react';
import { ChangeEvent, useState } from "react";

export const Query = (props: any) => {

  const {onClickFetchTopicList, onClickItem} = props;
  const [inputtext, setInputText] = useState<any>("");
  const [inputtext2, setInputText2] = useState<any>("");
    
  const onChangeText = (e: ChangeEvent<HTMLInputElement>) => setInputText(e.target.value);
  const onChangeText2 = (e: ChangeEvent<HTMLInputElement>) => setInputText2(e.target.value);
    
  const inputWrapperStyle: React.CSSProperties = {
    position: "relative",
    display: "flex",
    alignItems: "center",
  };
  const iconStyle: React.CSSProperties = {
    position: "absolute",
    left: "8px",
    color: "#888",
    fontSize: "20px",
    pointerEvents: "none",
  };
  const inputStyle: React.CSSProperties = {
    paddingLeft: "32px",
    width: "100%",
    boxSizing: "border-box",
  };

  return (
    <div style={{ display: "flex", gap: "8px", alignItems: "center" }}>
      <div style={{ ...inputWrapperStyle, width: "600px" }}>
        <i className="material-icons" style={iconStyle}>search</i>
        <input type="text" value={inputtext} onChange={onChangeText} onKeyDown={(e) => e.key === "Enter" && onClickFetchTopicList(inputtext)} placeholder="検索キーワード" style={inputStyle} />
      </div>
      <div style={{ ...inputWrapperStyle, width: "80px" }}>
        <i className="material-icons" style={iconStyle}>search</i>
        <input type="text" value={inputtext2} onChange={onChangeText2} onKeyDown={(e) => e.key === "Enter" && onClickItem(inputtext2)} placeholder="検索ID" style={inputStyle} />
      </div>
    </div>
  );	
}
export default Query;
