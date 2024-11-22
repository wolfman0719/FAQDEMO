import React from 'react';
import { Home } from './components/Home';
import { Top } from './components/Top';
import { BrowserRouter, Routes, Route } from 'react-router-dom';

export const App = () => {
 
  return (
  <BrowserRouter>
	<Routes>
  <Route path="/Home/:topicid"  element={<Home/>} />
  <Route path="/"  element={<Top/>} />
  <Route path="/HowTo"  element={<Top/>} />
	</Routes>
   </BrowserRouter>   
  );	
}
export default App;
