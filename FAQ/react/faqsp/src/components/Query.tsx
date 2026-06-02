import React from 'react';
import { ChangeEvent, useState} from "react";
import { TopicList } from './TopicList';


export const Query = () => {

 const [inputtext, setInputText] = useState<any>(localStorage.getItem('inputtext'));
    
 const onChangeText = (e: ChangeEvent<HTMLInputElement>) => {
     localStorage.setItem('inputtext', e.target.value);
     setInputText(e.target.value);
  }

  return (
    <>
      <div className="search-input-wrapper" style={{width: "50%"}}>
        <i className="bi bi-search"></i>
        <input type="text" placeholder="検索キーワード" value={inputtext} onChange={onChangeText} />
      </div>
      <TopicList keyword={inputtext} />
    </>
  );	
}
export default Query;
