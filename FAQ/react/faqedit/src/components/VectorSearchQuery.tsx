import React from 'react';
import { ChangeEvent, useState} from "react";
import { TopicVectorList } from './TopicVectorList';


export const VectorSearchQuery = (props: any) => {

 const {username,password,edit} = props;

 if (localStorage.getItem('inputtextv') === undefined || localStorage.getItem('inputtextv') === null) {
   localStorage.setItem('inputtextv','')
 } 

 const [inputtext, setInputText] = useState<any>(localStorage.getItem('inputtextv'));
 const [queryText, setQueryText] = useState<any>('');
    
 const onChangeText = (e:  ChangeEvent<HTMLTextAreaElement>) => {
     localStorage.setItem('inputtextv', e.target.value);
     setInputText(e.target.value);
  }

const onClickItem = (inputtext: any) => {
   setQueryText(inputtext);
 };

  return (
    <>
    <table>
    <tr>  
	  <td><label className="p-2 text-primary">知りたい内容: </label></td>
     <td ><textarea name="Question" rows={10} cols={100} value={inputtext} onChange={onChangeText}></textarea></td>
    </tr>
    <tr><td></td><td><button style={{width: "20%"}} className="btn btn-outline-primary" onClick={() => onClickItem(inputtext)}>検索</button></td></tr>
    </table>
	  <TopicVectorList queryText  = {queryText} username = {username} password = {password} edit = {edit}/>
    </>	
  );	
}
export default VectorSearchQuery;
