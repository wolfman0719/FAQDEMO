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
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="#888" viewBox="0 0 16 16"><path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001c.03.04.062.078.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1.007 1.007 0 0 0-.115-.099zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0z"/></svg>
        <input type="text" placeholder="検索キーワード" value={inputtext} onChange={onChangeText} />
      </div>
      <TopicList keyword={inputtext} />
    </>
  );	
}
export default Query;
