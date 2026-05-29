import React from 'react';
import { ChangeEvent, KeyboardEvent, useState} from "react";
import { TopicVectorList } from './TopicVectorList';


export const VectorSearchQuery = (props: any) => {

 const {username,password,edit} = props;

 if (localStorage.getItem('inputtextv') === undefined || localStorage.getItem('inputtextv') === null) {
   localStorage.setItem('inputtextv','')
 }

 const [inputtext, setInputText] = useState<any>(localStorage.getItem('inputtextv'));
 const [queryText, setQueryText] = useState<any>('');

 const onChangeText = (e: ChangeEvent<HTMLTextAreaElement>) => {
     setInputText(e.target.value);
  }

 const onClickItem = (inputtext: any) => {
   localStorage.setItem('inputtextv', inputtext);
   setQueryText(inputtext);
 };

 const onKeyDown = (e: KeyboardEvent<HTMLTextAreaElement>) => {
   if (e.key === 'Enter' && !e.shiftKey) {
     e.preventDefault();
     onClickItem(inputtext);
   }
 };

  return (
    <>
    <table>
    <tr>
     <td><textarea name="Question" rows={5} cols={100} value={inputtext} onChange={onChangeText} onKeyDown={onKeyDown} placeholder="知りたい内容を入力してください（Shift+Enterで改行、Enterで検索）"></textarea></td>
    </tr>
    </table>
	  <TopicVectorList queryText={queryText} username={username} password={password} edit={edit}/>
    </>
  );
}
export default VectorSearchQuery;
