import React from 'react';
import { Header } from './Header';
import { Query } from './Query';
import { QueryById } from './QueryById';
import { Tab, Tabs, TabList, TabPanel } from 'react-tabs';
import 'react-tabs/style/react-tabs.css';

export const Home = () => {

  return (
    <>
    <Tabs>
      <TabList>
        <Tab>キーワード検索</Tab>
        <Tab>ID検索</Tab>
      </TabList>
      <TabPanel>
      <div className="title">
	  <Header />
	  </div>
      <div className="query">
	  <Query />
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
    </Tabs>
    </>	
  );	
}
export default Home;
