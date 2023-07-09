import React from 'react';
import './App.css';
import { TopicContent } from './components/TopicContent';
import { Home } from './components/Home';
import { BrowserRouter, Routes, Route } from 'react-router-dom';

export const App = () => {
 
  return (
    <BrowserRouter>
	<Routes>
      <Route path="/">
        <Home />
      </Route>
      <Route path="/Content/:topicid">
        <TopicContent />
      </Route>
	</Routes>
   </BrowserRouter>   
  );	
}
export default App;
