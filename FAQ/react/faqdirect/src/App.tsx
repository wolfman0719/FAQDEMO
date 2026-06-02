import React from 'react';
import { Home } from './components/Home';
import { Top } from './components/Top';
import { Second } from './components/Second';
import { BrowserRouter, Routes, Route } from 'react-router-dom';

export const App = () => {
 
  return (
  <BrowserRouter basename="/faqdirect/">
	<Routes>
  <Route path="/"  element={<Top/>} />
  <Route path="/Second/"  element={<Second/>} />  
  <Route path="/Content/:topicid/"  element={<Home/>} />
  <Route  element={<Second/>} />
	</Routes>
   </BrowserRouter>   
  );	
}
export default App;
