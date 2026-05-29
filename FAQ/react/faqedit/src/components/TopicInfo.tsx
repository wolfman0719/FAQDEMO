import React, { useState, useEffect } from 'react';
import axios from "axios";
import { useParams, useNavigate } from "react-router-dom";
import { TopicContent } from './TopicContent';
import { RelatedTopics } from './RelatedTopics';
import { DownloadFile } from './DownloadFile';
import configinfo from '../serverconfig.json';

export const TopicInfo = (props: any) => {

let topicid: any = useParams().topicid;

if ((localStorage.getItem('topicid') !== null) && (localStorage.getItem('topicid') !== undefined)) {
  topicid = localStorage.getItem('topicid');
}

const {direct} = props;

const navigate = useNavigate();

const [isLoading, setIsLoading] = useState(false);
const [isError, setIsError] = useState(false);
const [response, setResponse] = useState<any>("");
const [fileflag, setFileFlag] = useState(false);
const [reftopics, setRefTopics] = useState<any>([]);
const [errortext, setErrorText] = useState<any>("");

const ServerAddress = configinfo.ServerAddress;
const ServerPort = configinfo.ServerPort;
const ApplicationName = configinfo.ApplicationName;
const Protocol = configinfo.Protocol;

const Username = localStorage.getItem('username');
const Password = localStorage.getItem('password');
const editflag = localStorage.getItem('edit');
// eslint-disable-next-line
const Edit = (editflag as unknown) == 1 ? true : false;

const onClickItem2 = (topicid: any) => {
	setIsLoading(true);
	setIsError(false);

	axios
	  .get<any>(`${Protocol}://${ServerAddress}:${ServerPort}${ApplicationName}/TopicGetById/${topicid}?IRISUsername=${Username}&IRISPassword=${Password}`)
	  .then((result: any) => {
		setResponse(result.data);
		localStorage.setItem('topicid', topicid);
		setFileFlag(result.data.FileFlg ? true : false);
		setRefTopics(result.data.RefArray);
	  })
      .catch((error: any) => {
	     setIsError(true);
		 if (error.response) {
		   setErrorText(error.response.data.summary);
		 } else if (error.request) {
		   setErrorText(error.toJSON());
		 } else {
		   setErrorText(error.message + error.toJSON() + ' 再ログインが必要です');
		 }
	  })
      .finally(() => setIsLoading(false));
};

  useEffect(() => {
	setIsLoading(true);
	setIsError(false);

	axios
	  .get<any>(`${Protocol}://${ServerAddress}:${ServerPort}${ApplicationName}/TopicGetById/${topicid}?IRISUsername=${Username}&IRISPassword=${Password}`)
	  .then((result: any) => {
	    setResponse(result.data);
		setFileFlag(result.data.FileFlg ? true : false);
		setRefTopics(result.data.RefArray);
	  })
      .catch((error: any) => {
	     setIsError(true);
		 if (error.response) {
		   setErrorText(error.response.data.summary);
		 } else if (error.request) {
		   setErrorText(error.toJSON());
		 } else {
		   setErrorText(error.message + error.toJSON() + ' 再ログインが必要です');
		 }
	  })
	  // eslint-disable-next-line react-hooks/exhaustive-deps
      .finally(() => setIsLoading(false));
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [topicid]);

  return (
    <>
    {isError && <p className="red-text" style={{padding: "8px"}}><span dangerouslySetInnerHTML={{__html: errortext}}></span></p>}
    {(direct === false) && (
      <div style={{padding: "8px 8px 4px"}}>
        <button onClick={() => navigate('/Home', {state: {username: Username, password: Password, edit: editflag}})} style={{backgroundColor: "#757575", color: "#ffffff", border: "none", borderRadius: "20px", cursor: "pointer", display: "inline-flex", alignItems: "center", gap: "4px", fontSize: "0.9rem", width: "fit-content", padding: "6px 14px"}}>
          <i className="material-icons" style={{fontSize: "18px"}}>arrow_back</i>検索に戻る
        </button>
      </div>
    )}
    {isLoading && <p style={{padding: "8px"}}>Loading...</p>}

    <div style={{padding: "0 8px 8px", display: "flex", flexDirection: "column", gap: "8px"}}>
      <div className="faq-card" style={{display: "flex", alignItems: "center", justifyContent: "space-between"}}>
        <div style={{display: "flex", alignItems: "center", gap: "8px"}}>
          <img src="../images/Question.gif" alt=''/>
          <span style={{fontSize: "1.2rem", fontWeight: "bold", color: "#0d6efd"}}>{response.Title}</span>
        </div>
        <span className="light-blue-text">{response.VersionRange}</span>
      </div>
      <div className="faq-card" style={{overflowY: "auto", maxHeight: "calc(100vh - 320px)"}}>
        <TopicContent response={response} />
      </div>
      <div className="faq-card">
        <p style={{margin: 0, color: "#0d6efd"}}>該当する製品: <span style={{color: "#212121"}}>{response.ProductText}</span></p>
      </div>
      <div className="faq-card">
        <RelatedTopics reftopics={reftopics} onClickItem={onClickItem2} />
      </div>
      {fileflag && (
        <div className="faq-card">
          <DownloadFile fileflag={fileflag} response={response} />
        </div>
      )}
      {Edit && (
        <div className="faq-card">
          <button onClick={() => navigate('/Edit/' + topicid)} style={{backgroundColor: "#9e9e9e", color: "#ffffff", border: "none", borderRadius: "20px", padding: "8px 16px", cursor: "pointer", display: "inline-flex", alignItems: "center", gap: "4px", fontSize: "0.9rem", width: "fit-content"}}>
            編集<i className="material-icons" style={{fontSize: "18px"}}>edit</i>
          </button>
        </div>
      )}
    </div>
    </>
  );
}
export default TopicInfo;
