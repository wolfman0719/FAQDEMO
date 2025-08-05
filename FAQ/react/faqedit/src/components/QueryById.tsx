import React from 'react';
import { ChangeEvent, useState } from "react";
import { useNavigate} from 'react-router-dom'


export const QueryById = (props: any) => {

 const [inputtext, setInputText] = useState<any>("");
 const navigate = useNavigate();

 localStorage.removeItem('topicid');
    
 const onChangeText = (e: ChangeEvent<HTMLInputElement>) => setInputText(e.target.value);
 
 const onClickItem = (topicid: any) => {
   navigate("/Content/" + topicid);
 };
 
  return (
    <>
    <table>
    <tr>
	  <td><label className="p-1">ID:</label></td>
	  <td><input type="text" value = {inputtext} onChange={onChangeText} /></td>
	  <td><button className="btn btn-outline-primary" onClick={() => onClickItem(inputtext)}>検索</button></td>
    </tr>
    </table>
    </>	
  );	
}
export default QueryById;
