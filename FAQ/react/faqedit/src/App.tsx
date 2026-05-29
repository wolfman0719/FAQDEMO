import React from 'react';
import { useEffect } from "react";
import { TopicInfo } from './components/TopicInfo';
import { TopicEditor } from './components/TopicEditor';
import { Home } from './components/Home';
import Signin from "./components/Signin";
import NoSignin from "./components/NoSignin";
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import configinfo from './serverconfig.json';
import './Table.css'

export const App = () => {
 
  useEffect( () => {
    localStorage.setItem('inputtext','');
    localStorage.removeItem('topicid');
    localStorage.removeItem('username');
    localStorage.removeItem('password');
    localStorage.removeItem('edit');
  }, []); 
  
  const edit = configinfo.Edit

  return (
  <BrowserRouter basename = {'/faqedit/'}>
	<Routes>
    {edit ? <Route path='/' element={<Signin />} />
  : <Route path='/' element={<NoSignin />} />}
  <Route path='/Home' element={<Home />} />
  <Route path="/Content/:topicid"  element={<TopicInfo direct={false}/>} />
  <Route path="/Direct/:topicid"  element={<TopicInfo direct={true}/>} />
  {edit &&<Route path="/Edit/:topicid"  element={<TopicEditor />} />}
	</Routes>
  </BrowserRouter>   
  );	
}
export default App;
