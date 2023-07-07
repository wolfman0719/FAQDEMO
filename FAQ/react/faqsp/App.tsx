import React from 'react';
import './App.css';
import { TopicList } from './components/TopicList';
import { TopicContent } from './components/TopicContent';
import { BrowserRouter, Route } from 'react-router-dom';

export const App = () => {
 
  return (
    <BrowserRouter>
      <Route Path="/">
        <Home />
      </Route>
      <Route Path="/Content">
        <TopicContent />
      </Route>
   </BrowseRouter>   
  );	
}
export default App;
