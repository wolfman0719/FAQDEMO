import React from 'react';
import { useEffect, useState } from "react";
import { TopicContent } from './components/TopicContent';
import { Home } from './components/Home';
import { BrowserRouter, Routes, Route } from 'react-router-dom';

export const App = () => {
 
  useEffect( () => {localStorage.setItem('inputtext','');}, []);   

  return (
    <BrowserRouter>
	<Routes>
	  <Route path='/' element={<Home/>} />
      <Route path="/Content/:topicid"  element={<TopicContent/>} />
	</Routes>
   </BrowserRouter>   
  );	
}
export default App;
