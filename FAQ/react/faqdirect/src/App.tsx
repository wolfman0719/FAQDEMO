import React from 'react';
import { Home } from './components/Home';
import { BrowserRouter, Routes, Route } from 'react-router-dom';

export const App = () => {
 
  return (
    <BrowserRouter>
	<Routes>
	  <Route path='/' element={<App/>} />
      <Route path="/Home/:topicid"  element={<Home/>} />
	</Routes>
   </BrowserRouter>   
  );	
}
export default App;
