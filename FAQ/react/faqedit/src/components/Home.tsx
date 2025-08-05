import React from 'react';
import { Header } from './Header';
import { Query } from './Query';
import { QueryById } from './QueryById';
import { VectorSearchQuery } from './VectorSearchQuery';
import { Tab, Tabs, TabList, TabPanel } from 'react-tabs';
import 'react-tabs/style/react-tabs.css';
import { useLocation } from "react-router-dom";


export const Home = () => {

  const location = useLocation();

  return (
    <>
    <Tabs>
    <TabList>
    <Tab>キーワード検索</Tab>
    <Tab>ID検索</Tab>
    <Tab>ベクトル検索</Tab>
    </TabList>
    <TabPanel>
    <div className="title">
	  <Header />
	  </div>
    <div className="query">
	  <Query username = {location.state.username} password = {location.state.password} edit = {location.state.edit} />
	  </div>      
    </TabPanel>
    <TabPanel>
    <div className="title">
	  <Header />
	  </div>
    <div className="querybyid">
	  <QueryById username = {location.state.username} password = {location.state.password} edit = {location.state.edit} />
	  </div>
    </TabPanel>
    <TabPanel>
    <div className="title">
	  <Header />
	  </div><div className="vectorsearchquery">
	  <VectorSearchQuery username = {location.state.username} password = {location.state.password} edit = {location.state.edit} />
	  </div>
    </TabPanel>
    </Tabs>
    </>	
  );	
}
export default Home;
