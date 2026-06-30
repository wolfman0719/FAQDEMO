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
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="#888" viewBox="0 0 16 16"><path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001c.03.04.062.078.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1.007 1.007 0 0 0-.115-.099zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0z"/></svg>
        <input type="text" placeholder="検索ID" value={inputtext} onChange={onChangeText} onKeyDown={onKeyDown} style={{width: "10ch"}} />
      </div>
    </>
  );
}
export default QueryById;
