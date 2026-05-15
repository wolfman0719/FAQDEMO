import React from 'react';
import { Header } from './Header';
import { Query } from './Query';
import { QueryById } from './QueryById';
import { VectorSearchQuery } from './VectorSearchQuery';
import { Tab, Tabs, TabList, TabPanel } from 'react-tabs';
import 'react-tabs/style/react-tabs.css';
import { useLocation } from "react-router-dom";
import configinfo from '../serverconfig.json';

export const Home = () => {

  const location = useLocation();
  // eslint-disable-next-line
  const editflag = (location.state.edit as unknown) == 1 ? true : false;
  
  const vectorSearch = configinfo.VectorSearch;
  
  localStorage.setItem('username',location.state.username);
  localStorage.setItem('password',location.state.password);
  localStorage.setItem('edit',location.state.edit);

  
  return (
    <>
    <Tabs>
    <TabList>
    <Tab>キーワード検索</Tab>
    <Tab>ID検索</Tab>
    {vectorSearch &&<Tab>ベクトル検索</Tab>}
    </TabList>
    <TabPanel>
    <div className="title">
	  <Header />
	  </div>
    <div className="query">
	  <Query username = {location.state.username} password = {location.state.password} edit = {editflag} />
	  </div>      
    </TabPanel>
    <TabPanel>
    <div className="title">
	  <Header />
	  </div>
    <div className="querybyid">
	  <QueryById />
	  </div>
    </TabPanel>
    {vectorSearch && <TabPanel>
    <div className="title">
	  <Header />
	  </div><div className="vectorsearchquery">
	  <VectorSearchQuery username = {location.state.username} password = {location.state.password} edit = {editflag} />
	  </div>
    </TabPanel>}
    </Tabs>
    </>	
  );	
}
export default Home;
