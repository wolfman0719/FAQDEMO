import React from 'react';
import { ChangeEvent, useState, useEffect} from "react";
import { TopicList } from './TopicList';


export const Query = () => {

 const [inputtext, setInputText] = useState<any>("");
    
 const onChangeText = (e: ChangeEvent<HTMLInputElement>) => {
     localStorage.setItem('inputtext', e.target.value);
     setInputText(e.target.value);
  }

 console.log('inputtext1 = ' + inputtext);
 console.log('localstorage = ' + localStorage.getItem('inputtext'));

 useEffect( () => {localStorage.getItem('inputtext') && setInputText(localStorage.getItem('inputtext'))});   

 console.log('inputtext2 = ' + inputtext);

  return (
    <>
	  <label>検索キーワード: </label>
	  <input type="text" value = {inputtext} onChange={onChangeText} />
	  <TopicList keyword  = {inputtext} />
    </>	
  );	
}
export default Query;
