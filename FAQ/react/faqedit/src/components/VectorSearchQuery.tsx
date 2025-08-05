import React from 'react';
import { ChangeEvent, useState} from "react";
import { useNavigate } from "react-router-dom";
import { TopicVectorList } from './TopicVectorList';


export const VectorSearchQuery = (props: any) => {

 const {username,password,edit} = props;
 
 const navigate = useNavigate();

 const [inputtext, setInputText] = useState<any>(localStorage.getItem('inputtext'));
 const [queryText, setQueryText] = useState<any>('');

 localStorage.removeItem('topicid');
    
 const onChangeText = (e:  ChangeEvent<HTMLTextAreaElement>) => {
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
