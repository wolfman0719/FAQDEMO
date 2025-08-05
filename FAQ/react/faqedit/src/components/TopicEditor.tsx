import React from 'react';
import { ChangeEvent, useState, useEffect} from "react";
import { useParams, useNavigate } from "react-router-dom";
import {CKEditor} from "ckeditor4-react";
import axios from "axios";
import configinfo from '../serverconfig.json';
import './styleedit.css';

export const TopicEditor = (props: any) => {

  const [isLoading, setIsLoading] = useState(false);
  const [isError, setIsError] = useState(false);
  const [fileflag, setFileFlag] = useState(false);
  const [errorText, setErrorText] = useState<any>("");
  const [fileName, setFileName] = useState<any>("");
  const [topicId, setTopicId] = useState<any>("");
  const [title, setTitle] = useState<any>("");
  const [refTopics, setRefTopics] = useState<any>("");
  const [DCURL, setDCURL] = useState<any>("");
  const [productId, setProductId] = useState<any>("");
  const [facilityId, setFacilityId] = useState<any>("");
  const [platformId, setPlatformId] = useState<any>("");
  const [startVersionId, setStartVersionId] = useState<any>("");
  const [endVersionId, setEndVersionId] = useState<any>("");
  const [note, setNote] = useState<any>("");
  const [complete, setComplete] = useState<any>("");
  const [deleteFlg, setDeleteFlg] = useState<any>("");
  const [visible, setVisible] = useState<any>("");
  const [newUpdateDate, setNewUpdateDate] = useState<any>("");
  const [newUpdater, setNewUpdater] = useState<any>("");
  const [updateHistory, setUpdateHistory] = useState<any>([]);
  const [productList, setProductList] = useState<any>([]);
  const [facilityList, setFacilityList] = useState<any>([]);
  const [platformList, setPlatformList] = useState<any>([]);
  const [startVersionList, setStartVersionList] = useState<any>([]);
  const [endVersionList, setEndVersionList] = useState<any>([]);
  const [file, setFile] = useState<File | null>(null)
  const [updateDescription, setUpdateDescription] = useState<any>("");
  const [creator, setCreator] = useState<any>("");  
  const [ckeditor, setCkeditor] = useState<any>("");

  const ServerAddress = configinfo.ServerAddress;
  const ServerPort = configinfo.ServerPort;
  const ApplicationName = configinfo.ApplicationName;
  const Protocol = configinfo.Protocol;
  
  const Username = localStorage.getItem('username');
  const Password = localStorage.getItem('password');

  const updater = Username;

  const onChangeProduct = (e: ChangeEvent<HTMLSelectElement>) => setProductId(e.target.value);
  const onChangeFacility = (e: ChangeEvent<HTMLSelectElement>) => setFacilityId(e.target.value);
  const onChangePlatform = (e: ChangeEvent<HTMLSelectElement>) => setPlatformId(e.target.value);  
  const onChangeStartVersion = (e: ChangeEvent<HTMLSelectElement>) => setStartVersionId(e.target.value);
  const onChangeEndVersion = (e: ChangeEvent<HTMLSelectElement>) => setEndVersionId(e.target.value);
  const onChangeRefTopics = (e: ChangeEvent<HTMLInputElement>) => setRefTopics(e.target.value);
  const onChangeComplete = (e: ChangeEvent<HTMLInputElement>) => setComplete(e.target.checked);
  const onChangeDelete = (e: ChangeEvent<HTMLInputElement>) => setDeleteFlg(e.target.checked);
  const onChangeVisible = (e: ChangeEvent<HTMLInputElement>) => setVisible(e.target.checked);
  const onChangeDCURL = (e: ChangeEvent<HTMLInputElement>) => setDCURL(e.target.value);
  const onChangeNote = (e: ChangeEvent<HTMLTextAreaElement>) => setNote(e.target.value);
  const onChangeUpdateDescription = (e: ChangeEvent<HTMLTextAreaElement>) => setUpdateDescription(e.target.value);
  const onChangeTitle = (e: ChangeEvent<HTMLInputElement>) => setTitle(e.target.value);

  // topicidが0の場合は、新規トピック
  
  const topicid: any = useParams().topicid;

  const navigate = useNavigate();

  const onClickSave = () => {
  
    setIsLoading(true);
    setIsError(false);

    const senddata: any = {};
    if (topicid === '0' || topicid === 0) {
      senddata.New = true;  
    }
    else {
      senddata.New = false;  
    }
    senddata.Id = topicid;
    senddata.Title = title;
    senddata.Description = ckeditor.getData();
    senddata.ProductId = productId;
    senddata.FacilityId = facilityId;
    senddata.PlatformId = platformId;
    senddata.StartVersionId = startVersionId;
    senddata.EndVersionId = endVersionId;
    senddata.RefTopic = refTopics;
    senddata.Completed = complete;
    senddata.DeleteFlg = deleteFlg;
    senddata.Visible = visible;
    senddata.DCURL = DCURL;
    senddata.Note = note;
    senddata.UpdateDescription = updateDescription; 
    
    axios
      .post<any>(`${Protocol}://${ServerAddress}:${ServerPort}${ApplicationName}/TopicSave?IRISUsername=${Username}&IRISPassword=${Password}`,senddata)
      .then((result: any) => {
        window.alert('保存しました');
        if (topicid === '0') {
          setTitle('');
          setRefTopics('');
          setFileName('');
          setFileFlag(false);
          setDCURL('');
          setProductId('');
          setFacilityId('');
          setPlatformId('');
          setStartVersionId('');
          setEndVersionId('');
          setNote('');
          setCreator('');
          setComplete('');
          setDeleteFlg('');
          setVisible('');
          setUpdateHistory([]);
          setNewUpdateDate('');
          setNewUpdater('');
          if (ckeditor !== null && ckeditor !== '') ckeditor.setData('');

        }
      })
      .catch((error: any) => {
        setIsError(true);
        if (error.response) {			
          setErrorText(error.response.data.summary);
        }
        else if (error.request) {
          setErrorText(error.request);
        } 
        else {
          setErrorText(error.message);
        }
      
      })
      .finally(() => setIsLoading(false))
    
      };
    
    const delAttachedFile = () => {
      const delfile = window.confirm('添付ファイルを削除します。よろしいですか？');
      if (delfile===true) {
        attachedFileDelete(topicid);
        setFileName('');
      }
      
    }
    
    const onClickCancel = () => {
      if (topicid > 0) {
        navigate('/Content/' + topicid);
      }
      else {
        navigate('/Home', { state: {username: Username, password: Password, edit: true}});
      }
      
    }

    const attachedFileDelete = (topicid: any) => {
      setIsLoading(true);
      setIsError(false);
        
      axios
        .get<any>(`${Protocol}://${ServerAddress}:${ServerPort}${ApplicationName}/DeleteAttached/${topicid}?IRISUsername=${Username}&IRISPassword=${Password}`)
        .then((result: any) => {
        if (result.data.result===1) {
          setFileFlag(false);
        }
        else {
          setFileFlag(true);
        }
      })
      .catch((error: any) => {
        setIsError(true)
        if (error.response) {			
          setErrorText(error.response.data.summary);
        }
        else if (error.request) {
          setErrorText(error.request);
        } 
        else {
          setErrorText(error.message);
        }
      
      })
          .finally(() => setIsLoading(false))
      }
      
      const onChangeFile = (e: React.ChangeEvent<HTMLInputElement>) => {
        const files = e.target.files
        
         if (files && files[0]) {
            setFile(files[0]);
            setFileName(files[0].name);
            setFileFlag(false);
          }
      }

      const attachedFileUpload = () => {
        const formData = new FormData();

        const url = `${Protocol}://${ServerAddress}:${ServerPort}${ApplicationName}/AttachedUpload/${topicid}?IRISUsername=${Username}&IRISPassword=${Password}`;

        if (!file) {
          return
        }

        formData.append(fileName, file);

        setIsLoading(true);
        setIsError(false);
        
        axios
          .post<any>(url,formData)
          .then((result: any) => {
            setFileFlag(true);
            setFile(null);
            setFileName('Attached' + topicId + '.zip');
            window.alert('アップロード成功');         
        })
        .catch((error: any) => {
          setIsError(true)
          if (error.response) {			
            setErrorText(error.response.data.summary);
          }
          else if (error.request) {
            setErrorText(error.request);
          } 
          else {
            setErrorText(error.message);
          }
      
        })
            .finally(() => setIsLoading(false))
        }
      
      useEffect( () => {

        setIsLoading(true);
        setIsError(false);
        
        axios
          .get<any>(`${Protocol}://${ServerAddress}:${ServerPort}${ApplicationName}/ProductGet?IRISUsername=${Username}&IRISPassword=${Password}`)
          .then((result: any) => {
            const products = result.data.map((product: any) => ({
            id: product.productid,
            name: product.productname
          }));
            setProductList(products);
          })
          .catch((error: any) => {
            setIsError(true)
            setErrorText(error.message);
          })
          axios
          .get<any>(`${Protocol}://${ServerAddress}:${ServerPort}${ApplicationName}/FacilityGet?IRISUsername=${Username}&IRISPassword=${Password}`)
          .then((result: any) => {
            const facilities = result.data.map((facility: any) => ({
            id: facility.id,
            name: facility.description
          }));
            setFacilityList(facilities);
          })
          .catch((error: any) => {
            setIsError(true)
            setErrorText(error.message);
          })
          axios
          .get<any>(`${Protocol}://${ServerAddress}:${ServerPort}${ApplicationName}/PlatformGet?IRISUsername=${Username}&IRISPassword=${Password}`)
          .then((result: any) => {
            const platforms = result.data.map((platform: any) => ({
            id: platform.id,
            name: platform.name
          }));
            setPlatformList(platforms);
          })
          .catch((error: any) => {
            setIsError(true)
            setErrorText(error.message);
          })
          axios
          .get<any>(`${Protocol}://${ServerAddress}:${ServerPort}${ApplicationName}/VersionGet?IRISUsername=${Username}&IRISPassword=${Password}`)
          .then((result: any) => {
            const startVersions = result.data.map((startVersion: any) => ({
            id: startVersion.id,
            name: startVersion.version
          }));
            setStartVersionList(startVersions);
          })
          .catch((error: any) => {
            setIsError(true)
            setErrorText(error.message);
          })
          axios
          .get<any>(`${Protocol}://${ServerAddress}:${ServerPort}${ApplicationName}/VersionGet?IRISUsername=${Username}&IRISPassword=${Password}`)
          .then((result: any) => {
            const endVersions = result.data.map((endVersion: any) => ({
            id: endVersion.id,
            name: endVersion.version
          }));
            setEndVersionList(endVersions);
          })
          .catch((error: any) => {
            setIsError(true)
            setErrorText(error.message);
          })

          if (topicid !== 0 && topicid !== '0') {
          //新規トピックではない場合  
            axios
            .get<any>(`${Protocol}://${ServerAddress}:${ServerPort}${ApplicationName}/TopicGetForEdit/${topicid}?IRISUsername=${Username}&IRISPassword=${Password}`)
            .then((result: any) => {

              setTopicId(result.data.id);
              setTitle(result.data.Title);
              // onInstanceReadyは非同期処理なので、ckeditorが設定されていない可能性がある
              if (ckeditor !== null && ckeditor !== '') ckeditor.setData(result.data.Description);
              setRefTopics(result.data.RefTopics);
              setFileName(result.data.FileName);
              setFileFlag(result.data.FileFlg);
              setDCURL(result.data.DCURL);
              setProductId(result.data.ProductId);
              setFacilityId(result.data.FacilityId);
              setPlatformId(result.data.PlatformId);
              setStartVersionId(result.data.StartVersionId);
              setEndVersionId(result.data.EndVersionId);
              setNote(result.data.Note);
              setCreator(result.data.Creator);
              setComplete(result.data.Completed);
              setDeleteFlg(result.data.DeleteFlg);
              setVisible(result.data.Visible);
              setUpdateHistory(result.data.UpdateHistory);
              setNewUpdateDate(result.data.NewUpdateDate);
              setNewUpdater(result.data.NewUpdater);
            })
            .catch((error: any) => {
              setIsError(true)
              if (error.response) {			
                setErrorText(error.response.data.summary);
              }
              else if (error.request) {
                setErrorText(error.request);
              } 
              else {
                setErrorText(error.message);
            }
      
            })
            .finally(() => setIsLoading(false));
            } 
            else {
              setTopicId('');
              setIsLoading(false);   
            }
            
          // eslint-disable-next-line
            },[ckeditor]);
          
      return (
        <>
        {isLoading && <p>Laoding...</p>}
        {isError && <p className="text-danger fs-3"><span dangerouslySetInnerHTML={{__html: errorText}}></span></p>}
        <div className="text-primary text-center fs-2">
        <div className="row">
        <div className="col">
        FAQトピック 編集
        </div>
        <div className="col-8">
        </div>
        </div>
        </div>
        <table width="100%">
       <tr>
       <td align="right" colSpan={2} className="readonlytitle" style={{color: "#666666"}}>作成者:　<label>{creator}</label><label>最終更新者：　</label><label>{updater}</label></td>
        </tr>
      </table>
      <table>       
      <tr>
       </tr>
       {(topicid === '0') ?
        (<tr>
          <td align="right" className="text-primary">ID：</td>
          <td><label>新規</label></td><td></td><td></td><td></td>
        </tr>):
        (<tr>
          <td align="right" className="text-primary">ID：</td>
          <td><label>{topicId}</label></td><td></td><td></td><td></td>
        </tr>)}
        <tr>
        <td  align="right" className="text-primary"><label>タイトル： </label></td>  
        <td ><input type="text" name="Title" size={100} value={title} onChange={onChangeTitle}/></td>  
        </tr>
        <tr>
        <td  align="right" className="text-primary"><label>内容： </label></td>  
        <td width="90%">
        <CKEditor
          name="faqeditor"
          config={{
            extraPlugins: 'codesnippet,colorbutton,font,justify',
            removeButtons: '',
            codeSnippet_languages: {cos: 'ObjectScript',sql: 'SQL',python: 'Python',json: 'JSON',yaml: 'YAML',javascript: 'JavaScript',dockerfile: 'Dockerfile',html: 'HTML',css: 'CSS',java: 'Java',xml: 'XML',bash: 'Bash',makefile: 'Makefile',markdown: 'Markdown'},
            filebrowserUploadUrl : `${Protocol}://${ServerAddress}:${ServerPort}${ApplicationName}/ImageUpload`,
            filebrowserUploadMethod: 'form',
            versionCheck: false,
            clipboard_handleImages: false,
            toolbar:  [[ 'Bold', 'Italic', 'Underline', 'Strike', 'JustifyLeft', 'JustifyCenter', 'JustifyRight' , 'NumberedList', 'BulletedList', 'Indent',  'Outdent', 'Blockquote', 'Link', 'Unlink', 'Anchor', 'TextColor',  'Source', 'HorizontalRule', 'Table', 'RemoveFormat', 'Font', 'FontSize', 'Styles', 'Format', 'CodeSnippet', 'Image']],
            allowedContent: true
          }}
          onInstanceReady={ ( { editor } ) => {
            // Handles native `instanceReady` event.
            setCkeditor(editor);           
        } }

        />
        </td>
        </tr>
        <tr>
          <td align="right" className="text-primary">プロダクト：</td>
          <td>
          <select size={5} name="ProductList" value={productId} onChange={onChangeProduct}>
          { productList.map((product: any) => (
          <option value={product.id} key={product.id}>{product.name}</option>  
          ))}  
          </select>
          </td>
        </tr>
        <tr>
          <td align="right" className="text-primary">機能名：</td>
          <td >
          <select name="FacilityList" value={facilityId} onChange={onChangeFacility}>
          { facilityList.map((facility: any) => (
          <option value={facility.id} key={facility.id}>{facility.name}</option>  
          ))}  
          </select></td>
        </tr>
        <tr>
          <td align="right" className="text-primary">プラットフォーム：</td>
          <td>
          <select name="PlatformList" value={platformId} onChange={onChangePlatform}>
          { platformList.map((platform: any) => (
          <option value={platform.id} key={platform.id}>{platform.name}</option>  
          ))}
          </select></td>  
        </tr>
        <tr>
          <td align="right" className="text-primary">バージョン：</td>
          <td >
          <select name="StartVersion" value={startVersionId} onChange={onChangeStartVersion}>
          { startVersionList.map((startVersion: any) => (
          <option value={startVersion.id} key={startVersion.id}>{startVersion.name}</option>  
          ))}
          </select> ～ 
          <select name="EndVersion"  value={endVersionId} onChange={onChangeEndVersion}>
          { endVersionList.map((endVersion: any) => (
          <option value={endVersion.id} key={endVersion.id}>{endVersion.name}</option>  
          ))}
          </select>
          </td>       
        </tr>
        <tr>
          <td align="right" className="text-primary">関連トピック：</td>
          <td ><input type="text" name="RefTopic" value={refTopics} onChange={onChangeRefTopics}/></td>
        </tr>
        { (topicid != 0) &&
		    <tr>
          <td align="right" className="text-primary">添付ファイル：</td>
          {fileName && 
          <td>
          <table>
          <tr>
          <td><label>{fileName}</label></td>
          <td><button name="AttacheDel" className = "btn btn-outline-danger" disabled={!fileflag}  onClick={delAttachedFile} style={{height: "20"}}><i className="bi bi-trash"></i></button></td>
          </tr>
          </table>
          </td>}
        </tr>}
        { (topicid != 0) &&
        <tr>
        <td align="right" className="text-primary">Upload：</td>
        <td width="90%"><table><tr><td><input name="AttachedFile" type="file" onChange={onChangeFile}/></td>
        <td><button name="Upload" className = "btn btn-outline-primary" disabled={!file} onClick={attachedFileUpload}>アップロード<i className="bi bi-upload"></i></button></td>
        </tr></table></td>
        </tr>}
        <tr>
          <td align="right" className="text-primary">ステータス：</td>
          <td>
            <table width="100%" style={{padding:0}}>
            <tr>
            <td width="25%" className="text-primary"><label><input type="checkbox" name="Completed" checked={complete} onChange={onChangeComplete}/>作成完了</label></td>
            <td width="25%" className="text-primary"><label><input type="checkbox" name="DeleteFlg" checked={deleteFlg} onChange={onChangeDelete}/>削除可</label></td>
            <td width="20%" className="text-primary"><label><input type="checkbox" name="Visible" checked={visible} onChange={onChangeVisible}/>公開[管理用]</label></td>
		      </tr>
          </table>
		  </td>
		</tr>
        <tr>
          <td align="right" className="text-primary">DCURL：</td>
          <td ><input type="text" name="DCURL" size={100} className="textbox" value={DCURL} onChange={onChangeDCURL}/></td>
        </tr>
        <tr>
          <td align="right" className="text-primary">*社内用メモ*：</td>
          <td ><textarea name="Note" cols={65} rows={3} id="nt" value={note} onChange={onChangeNote}></textarea></td>
        </tr>
      { (topicid != 0) &&
	    <tr>
         <td align="right" className="text-primary">*更新履歴*：</td>
         <td>  
        <div>  
        <table className="table table2-bordered border-primary" width="100%">
        <tr>
          <th className="text-primary">更新日付</th>
  				<th className="text-primary">更新者</th>
  				<th className="text-primary">更新内容</th>
          </tr>
          { updateHistory.map((update: any) => (
          <tr>
          <td className="border-secondary">{update.UpdateDate}</td>
          <td className="border-secondary">{update.Updater}</td>
          <td className="border-secondary">{update.Description}</td>
          </tr>  
          ))}  
          <tr>
  				<td className="border-secondary">{newUpdateDate}</td>
  				<td className="border-secondary">{newUpdater}</td>
  				<td><textarea name="UpdateDescription" rows={2} id="ud" value={updateDescription} onChange={onChangeUpdateDescription}></textarea></td>
			  </tr>
        </table>
        </div>
          </td>
        </tr>}
        <tr>
          <td></td>
          <td colSpan={6} align="center">
            <table>
            <tr>  
            <td><button className = "btn btn-outline-primary" onClick={() => onClickSave()}>保存<i className="bi bi-save"></i></button></td>
            <td><button className = "btn btn-outline-primary" onClick={() => onClickCancel()}>キャンセル<i className="bi bi-x-circle"></i></button></td>
            </tr>
            </table>
          </td>
        </tr>
        </table>
    </>
    );

    }
  
    export default TopicEditor;