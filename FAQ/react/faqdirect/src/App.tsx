import React from 'react';
import { Home } from './components/Home';
import { Top } from './components/Top';
import { HashRouter, Routes, Route } from 'react-router-dom';

export const App = () => {
 
  return (
  <HashRouter>
	<Routes>
  <Route path="/Content/:topicid"  element={<Home/>} />
  <Route path="/"  element={<Top/>} />
  <Route path="/HowTo"  element={<Top/>} />
	</Routes>
   </HashRouter>   
  );	
}
export default App;
