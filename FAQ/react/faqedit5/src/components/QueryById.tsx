import React from 'react';
import { ChangeEvent, KeyboardEvent, useState } from "react";
import { useNavigate} from 'react-router-dom'


export const QueryById = (props: any) => {

 const [inputtext, setInputText] = useState<any>("");
 const navigate = useNavigate();

 localStorage.removeItem('topicid');

 const onChangeText = (e: ChangeEvent<HTMLInputElement>) => setInputText(e.target.value);

 const onClickItem = (topicid: any) => {
   navigate("/Content/" + topicid);
 };

 const onKeyDown = (e: KeyboardEvent<HTMLInputElement>) => {
   if (e.key === 'Enter') {
     onClickItem(inputtext);
   }
 };

  return (
    <>
    <table>
    <tbody>
    <tr>
	  <td>
        <div className="search-input-wrapper">
          <i className="material-icons">search</i>
          <input type="text" value={inputtext} onChange={onChangeText} onKeyDown={onKeyDown} placeholder="トピックIDで検索" style={{minWidth: 0, width: "10ch"}} />
        </div>
      </td>
    </tr>
    </tbody>
    </table>
    </>
  );
}
export default QueryById;
