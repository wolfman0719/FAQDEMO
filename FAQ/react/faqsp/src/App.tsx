import React from 'react';
import { useEffect } from "react";
import { TopicInfo } from './components/TopicInfo';
import { Home } from './components/Home';
import { BrowserRouter, Routes, Route } from 'react-router-dom';

export const App = () => {
 
  useEffect( () => {localStorage.setItem('inputtext','');}, []);   

  return (
    <BrowserRouter>
	<Routes>
	  <Route path='/' element={<Home/>} />
      <Route path="/Content/:topicid"  element={<TopicInfo/>} />
	</Routes>
   </BrowserRouter>   
  );	
}
export default App;
