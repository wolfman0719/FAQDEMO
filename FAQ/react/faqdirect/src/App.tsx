import React from 'react';
import { Home } from './components/Home';
import { HomeDesc } from './components/HomeDesc';
import { Top } from './components/Top';
import { BrowserRouter, Routes, Route } from 'react-router-dom';

export const App = () => {
 
  return (
  <BrowserRouter basename="/faqreact/faqdirect/">
	<Routes>
  <Route path="/"  element={<Top/>} />  
  <Route path="/Content/:topicid/"  element={<HomeDesc/>} />
  <Route path="/Contentdc/:topicid/"  element={<Home/>} />
	</Routes>
   </BrowserRouter>   
  );	
}
export default App;
