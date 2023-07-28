import React from 'react';
import { ChangeEvent, useState } from "react";

export const Query = (props: any) => {

  const {onClickFetchTopicList, onClickItem} = props;
  const [inputtext, setInputText] = useState<any>("");
  const [inputtext2, setInputText2] = useState<any>("");
    
  const onChangeText = (e: ChangeEvent<HTMLInputElement>) => setInputText(e.target.value);
  const onChangeText2 = (e: ChangeEvent<HTMLInputElement>) => setInputText2(e.target.value);
    
  return (
    <>
	  <label className="p-2">検索キーワード: </label>
	  <input type="text" value = {inputtext} onChange={onChangeText} />
	  <button className="btn btn-secondary" onClick={() => onClickFetchTopicList(inputtext)}>トピック検索</button>
	  <label className="p-2">検索ID: </label>
	  <input type="text" value = {inputtext2} onChange={onChangeText2} />
	  <button className="btn btn-secondary" onClick={() => onClickItem(inputtext2)}>トピックID検索</button>
    </>	
  );	
}
export default Query;
