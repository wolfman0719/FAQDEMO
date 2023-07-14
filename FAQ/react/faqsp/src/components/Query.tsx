import React from 'react';
import { ChangeEvent, useState } from "react";
import { TopicList } from './TopicList';


export const Query = () => {

 const [inputtext, setInputText] = useState<any>("");
    
 const onChangeText = (e: ChangeEvent<HTMLInputElement>) => setInputText(e.target.value);
    
  return (
    <>
	  <label>検索キーワード: </label>
	  <input type="text" value = {inputtext} onChange={onChangeText} />
	  <TopicList keyword  = {inputtext} />
    </>	
  );	
}
export default Query;
