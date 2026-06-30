import React from 'react';
import { Header } from './Header';
import { Query } from './Query';
import { QueryById } from './QueryById';
import { Tab, Tabs, TabList, TabPanel } from 'react-tabs';
import 'react-tabs/style/react-tabs.css';

export const Home = () => {

  return (
    <div style={{padding: "8px"}}>
    <Tabs>
      <TabList>
        <Tab>キーワード検索</Tab>
        <Tab>ID検索</Tab>
      </TabList>
      <TabPanel>
      <div className="faq-card">
        <Header />
      </div>
      <div className="faq-card">
        <Query />
      </div>
      </TabPanel>
      <TabPanel>
      <div className="faq-card">
        <Header />
      </div>
      <div className="faq-card">
        <QueryById />
      </div>
      </TabPanel>
    </Tabs>
    </div>
  );	
}
export default Home;
