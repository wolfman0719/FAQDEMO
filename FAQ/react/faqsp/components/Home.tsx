import React from 'react';
import axios from "axios";
import { useState } from "react";
import { Header } from './Header';
import { Query } from './Query';
import { BrowserRouter, Route } from 'react-router-dom';
import configinfo from './serverconfig.json';

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
