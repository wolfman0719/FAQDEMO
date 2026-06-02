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
      <div className="search-input-wrapper" style={{width: "50vw"}}>
        <i className="material-icons">search</i>
        <input type="text" value={inputtext} onChange={onChangeText} placeholder="キーワードで検索" />
      </div>
      {edit && (
        <button className="new-topic-btn" onClick={() => {navigate('/Edit/' + 0)}}>
          新規トピック<i className="material-icons" style={{fontSize: "18px"}}>description</i>
        </button>
      )}
    </div>
	  <TopicList keyword  = {inputtext} username = {username} password = {password} edit = {edit}/>
    </>	
  );	
}
export default Query;
