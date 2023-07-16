import React from 'react';
import { ChangeEvent, useState } from "react";
import { useNavigate} from 'react-router-dom'


export const QueryById = () => {

 const [inputtext, setInputText] = useState<any>("");
 const navigate = useNavigate();
    
 const onChangeText = (e: ChangeEvent<HTMLInputElement>) => setInputText(e.target.value);
 
 const onClickItem = (topicid: any) => {
   navigate("/Content/" + topicid);
 };
 
  return (
    <>
	  <label>ID検索: </label>
	  <input type="text" value = {inputtext} onChange={onChangeText} />
	  <button onClick={() => onClickItem(inputtext)}>トピックID検索</button>

    </>	
  );	
}
export default QueryById;
