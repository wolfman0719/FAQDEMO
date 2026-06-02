import React from 'react';
import { ChangeEvent, KeyboardEvent, useState } from "react";
import { useNavigate} from 'react-router-dom'


export const QueryById = () => {

 const [inputtext, setInputText] = useState<any>("");
 const navigate = useNavigate();

 const onChangeText = (e: ChangeEvent<HTMLInputElement>) => setInputText(e.target.value);

 const onKeyDown = (e: KeyboardEvent<HTMLInputElement>) => {
   if (e.key === 'Enter') navigate("/Content/" + inputtext);
 };

  return (
    <>
      <div className="search-input-wrapper" style={{width: "fit-content"}}>
        <i className="bi bi-search"></i>
        <input type="text" placeholder="検索ID" value={inputtext} onChange={onChangeText} onKeyDown={onKeyDown} style={{width: "10ch"}} />
      </div>
    </>
  );
}
export default QueryById;
