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
	  <label className="p-2">検索キーワード: </label>
	  <input type="text" value = {inputtext} onChange={onChangeText} />
	  <TopicList keyword  = {inputtext} />
    </>	
  );	
}
export default Query;
