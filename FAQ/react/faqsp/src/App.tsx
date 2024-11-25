import React from 'react';
import { useEffect } from "react";
import { TopicInfo } from './components/TopicInfo';
import { Home } from './components/Home';
import { HashRouter, Routes, Route } from 'react-router-dom';

export const App = () => {
 
  useEffect( () => {localStorage.setItem('inputtext','');}, []);   

  return (
    <HashRouter>
	<Routes>
	  <Route path='/' element={<Home/>} />
      <Route path="/Content/:topicid"  element={<TopicInfo/>} />
	</Routes>
   </HashRouter>   
  );	
}
export default App;
