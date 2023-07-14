import React from 'react';
import { Header } from './Header';
import { Query } from './Query';
import { BrowserRouter, Routes, Route } from 'react-router-dom';

export const Home = () => {

  return (
    <>
    <div className="title">
	<Header />
	</div>
    <div className="query">
	<Query />
	</div>
    </>	
  );	
}
export default Home;
