import React from 'react';
import { ChangeEvent, useState} from "react";
import { useNavigate } from "react-router-dom";
import { TopicList } from './TopicList';


export const Query = (props: any) => {

 const {username,password,edit} = props;
 
 const navigate = useNavigate();

 if (localStorage.getItem('inputtext') === undefined || localStorage.getItem('inputtext') === null) {
   localStorage.setItem('inputtext','')
 } 
 const [inputtext, setInputText] = useState<any>(localStorage.getItem('inputtext'));

 localStorage.removeItem('topicid');
    
 const onChangeText = (e: ChangeEvent<HTMLInputElement>) => {
     localStorage.setItem('inputtext', e.target.value);
     setInputText(e.target.value);
  }

  return (
    <>
    <table>
    <tbody>
    <tr>  
	  <td><label className="p-2">検索キーワード: </label></td>
	  <td><input type="text" value = {inputtext} onChange={onChangeText} /></td>
    {edit && <td><button className = "btn btn-outline-primary" onClick={() => {navigate('/Edit/' + 0)}}>新規トピック<span className="bi bi-file-text"></span></button></td>}
    </tr>
    </tbody>
    </table>
	  <TopicList keyword  = {inputtext} username = {username} password = {password} edit = {edit}/>
    </>	
  );	
}
export default Query;
