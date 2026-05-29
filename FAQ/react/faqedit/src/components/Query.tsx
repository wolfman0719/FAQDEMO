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
    <div style={{display: "flex", alignItems: "center", gap: "8px"}}>
      <div className="search-input-wrapper" style={{minWidth: "500px"}}>
        <i className="material-icons">search</i>
        <input type="text" value={inputtext} onChange={onChangeText} placeholder="キーワードで検索" />
      </div>
      {edit && (
        <button onClick={() => {navigate('/Edit/' + 0)}} style={{backgroundColor: "#9e9e9e", color: "#ffffff", border: "none", borderRadius: "20px", padding: "8px 16px", cursor: "pointer", display: "inline-flex", alignItems: "center", gap: "4px", fontSize: "0.9rem", width: "fit-content", flexShrink: 0}}>
          新規トピック<i className="material-icons" style={{fontSize: "18px"}}>description</i>
        </button>
      )}
    </div>
	  <TopicList keyword  = {inputtext} username = {username} password = {password} edit = {edit}/>
    </>	
  );	
}
export default Query;
