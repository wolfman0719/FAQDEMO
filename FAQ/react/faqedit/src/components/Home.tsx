import React from 'react';
import { Header } from './Header';
import { Query } from './Query';
import { QueryById } from './QueryById';
import { Tab, Tabs, TabList, TabPanel } from 'react-tabs';
import 'react-tabs/style/react-tabs.css';
import { useLocation } from "react-router-dom";

export const Home = () => {

  const location = useLocation();
  // eslint-disable-next-line
  const editflag = (location.state.edit as unknown) == 1 ? true : false;

  localStorage.setItem('username', location.state.username);
  localStorage.setItem('password', location.state.password);
  localStorage.setItem('edit', location.state.edit);

  return (
    <>
    <Tabs>
    <TabList>
    <Tab>キーワード検索</Tab>
    <Tab>ID検索</Tab>
    </TabList>

    <TabPanel>
      <div className="faq-card" style={{margin: "8px"}}>
        <Header />
      </div>
      <div className="faq-card" style={{margin: "8px"}}>
        <Query username={location.state.username} password={location.state.password} edit={editflag} />
      </div>
    </TabPanel>

    <TabPanel>
      <div className="faq-card" style={{margin: "8px"}}>
        <Header />
      </div>
      <div className="faq-card" style={{margin: "8px"}}>
        <QueryById />
      </div>
    </TabPanel>
    </Tabs>
    </>
  );
}
export default Home;
