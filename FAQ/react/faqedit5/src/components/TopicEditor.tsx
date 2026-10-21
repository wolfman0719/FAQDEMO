import React from 'react';
import { ChangeEvent, useState, useEffect} from "react";
import { useParams, useNavigate } from "react-router-dom";
import { CKEditor, useCKEditorCloud } from "@ckeditor/ckeditor5-react";
import axios from "axios";
import configinfo from '../serverconfig.json';
import './styleedit.css';

// ライセンスキーの配布チャネルがcloudのため、CKEditor 5はCDNから読み込む
const CKEDITOR_VERSION = '49.0.0';
const CKEDITOR_LICENSE_KEY = 'ライセンスキーの値を設定してください';

// ckeditor4のcodeSnippet_languagesを引き継ぐ（出力は<pre><code class="language-xxx">で互換）
const codeBlockLanguages = [
  { language: 'plaintext', label: 'Plain text' },
  { language: 'cos', label: 'ObjectScript' },
  { language: 'sql', label: 'SQL' },
  { language: 'python', label: 'Python' },
  { language: 'json', label: 'JSON' },
  { language: 'yaml', label: 'YAML' },
  { language: 'javascript', label: 'JavaScript' },
  { language: 'dockerfile', label: 'Dockerfile' },
  { language: 'html', label: 'HTML' },
  { language: 'css', label: 'CSS' },
  { language: 'java', label: 'Java' },
  { language: 'xml', label: 'XML' },
  { language: 'bash', label: 'Bash' },
  { language: 'makefile', label: 'Makefile' },
  { language: 'markdown', label: 'Markdown' },
  { language: 'shell', label: 'Shell' }
];

// ckeditor4のfilebrowserUploadUrl(filebrowserUploadMethod: 'form')と同じ形式で
// ImageUpload RestAPIへ画像を送信するアップロードアダプタ
class ImageUploadAdapter {
  loader: any;
  url: string;
  controller: AbortController | null = null;

  constructor(loader: any, url: string) {
    this.loader = loader;
    this.url = url;
  }

  upload() {
    return this.loader.file
      .then((file: File) => resizeImageFile(file, IMAGE_MAX_WIDTH, IMAGE_MAX_HEIGHT))
      .then((file: File) => {
      const formData = new FormData();
      formData.append('upload', file);
      this.controller = new AbortController();

      return axios
        .post<any>(`${this.url}?CKEditor=faqeditor&CKEditorFuncNum=1&langCode=ja`, formData, {
          signal: this.controller.signal,
          onUploadProgress: (e: any) => {
            if (e.total) {
              this.loader.uploadTotal = e.total;
              this.loader.uploaded = e.loaded;
            }
          }
        })
        .then((result: any) => {
          const imageUrl = parseImageUploadResponse(result.data);
          if (!imageUrl) {
            return Promise.reject(`画像のアップロードに失敗しました: ${file.name}`);
          }
          return { default: imageUrl };
        });
    });
  }

  abort() {
    this.controller?.abort();
  }
}

// JSON({url}, {uploaded, url})と、ckeditor4形式の
// <script>window.parent.CKEDITOR.tools.callFunction(1, 'url', 'message')</script> の両方に対応
const parseImageUploadResponse = (data: any): string | null => {
  if (data && typeof data === 'object') {
    return data.url || data.default || null;
  }
  if (typeof data === 'string') {
    try {
      const json = JSON.parse(data);
      if (json && json.url) return json.url;
    } catch (e) {
      // JSONでなければckeditor4形式として扱う
    }
    const match = data.match(/callFunction\(\s*\d+\s*,\s*(['"])(.*?)\1/);
    if (match && match[2]) return match[2];
  }
  return null;
};

// アップロードする画像の最大サイズ（縦横比を保ったままこの範囲に収まるよう縮小する）
const IMAGE_MAX_WIDTH = 800;
const IMAGE_MAX_HEIGHT = 600;

// アップロード前に画像がmaxWidth x maxHeightを超える場合はブラウザ側で縮小する
// GIF(アニメーション)とSVGは縮小すると内容が失われるため対象外
const resizeImageFile = (file: File, maxWidth: number, maxHeight: number): Promise<File> => {
  if (!/^image\/(jpeg|png|webp)$/.test(file.type)) {
    return Promise.resolve(file);
  }
  return new Promise((resolve) => {
    const objectUrl = URL.createObjectURL(file);
    const img = new Image();
    img.onload = () => {
      URL.revokeObjectURL(objectUrl);
      const scale = Math.min(maxWidth / img.naturalWidth, maxHeight / img.naturalHeight);
      if (scale >= 1) {
        resolve(file);
        return;
      }
      const canvas = document.createElement('canvas');
      canvas.width = Math.round(img.naturalWidth * scale);
      canvas.height = Math.round(img.naturalHeight * scale);
      const ctx = canvas.getContext('2d');
      if (!ctx) {
        resolve(file);
        return;
      }
      ctx.imageSmoothingQuality = 'high';
      ctx.drawImage(img, 0, 0, canvas.width, canvas.height);
      canvas.toBlob((blob) => {
        // 縮小後の方が大きくなった場合は元のファイルを使う
        resolve(blob && blob.size < file.size ? new File([blob], file.name, { type: file.type }) : file);
      }, file.type, 0.9);
    };
    img.onerror = () => {
      URL.revokeObjectURL(objectUrl);
      resolve(file);
    };
    img.src = objectUrl;
  });
};

const imageUploadUrl = `${configinfo.Protocol}://${configinfo.ServerAddress}:${configinfo.ServerPort}${configinfo.ApplicationName}/ImageUpload`;

function ImageUploadAdapterPlugin(editor: any) {
  editor.plugins.get('FileRepository').createUploadAdapter = (loader: any) => new ImageUploadAdapter(loader, imageUploadUrl);
}

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

  const cloud = useCKEditorCloud({ version: CKEDITOR_VERSION, translations: ['ja'] });

  const ServerAddress = configinfo.ServerAddress;
  const ServerPort = configinfo.ServerPort;
  const ApplicationName = configinfo.ApplicationName;
  const Protocol = configinfo.Protocol;
  
  const Username = localStorage.getItem('username');
  const Password = localStorage.getItem('password');

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

  const updater = (topicid === '0' || topicid === 0) ? "" : Username;

  const navigate = useNavigate();

  const onClickSave = () => {
    if (!window.confirm('保存します。よろしいですか？')) return;

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
        if (topicid !== '0' && topicid !== 0) {
          setUpdateHistory((prev: any) => [...prev, {
            UpdateDate: newUpdateDate,
            Updater: newUpdater,
            Description: updateDescription
          }]);
          setUpdateDescription('');
        }
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
          setErrorText(error.toJSON());
        } 
        else {
          setErrorText(error.message + error.toJSON() + ' 再ログインが必要です');
        }
      
      })
      .finally(() => setIsLoading(false))
    
      };
    
    const delAttachedFile = () => {
      const delfile = window.confirm('添付ファイルを削除します。よろしいですか？');
      if (delfile===true) {
        attachedFileDelete(topicid);
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
          setFile(null);
          setFileName('');
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
          setErrorText(error.toJSON());
        } 
        else {
          setErrorText(error.message + error.toJSON() + ' 再ログインが必要です');
        }
      
      })
          .finally(() => setIsLoading(false))
      }
      
      const onChangeFile = (e: React.ChangeEvent<HTMLInputElement>) => {
        const files = e.target.files
        
         if (files && files[0]) {
            setFile(files[0]);
            //setFileName(files[0].name);
            //setFileFlag(false);
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
            setErrorText(error.toJSON());
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
            setErrorText(error.message + error.toJSON());
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
            setErrorText(error.message + error.toJSON());
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
            setErrorText(error.message + error.toJSON());
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
            setErrorText(error.message + error.toJSON());
          })

          if (topicid !== 0 && topicid !== '0') {
          //新規トピックではない場合  
            axios
            .get<any>(`${Protocol}://${ServerAddress}:${ServerPort}${ApplicationName}/TopicGetForEdit/${topicid}?IRISUsername=${Username}&IRISPassword=${Password}`)
            .then((result: any) => {

              setTopicId(result.data.id);
              setTitle(result.data.Title);
              // onReadyは非同期処理なので、ckeditorが設定されていない可能性がある
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
                setErrorText(error.toJSON());
              } 
              else {
                setErrorText(error.message + error.toJSON() + ' 再ログインが必要です');
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
        <div className="faq-card" style={{margin: "8px"}}>
        {isLoading && <p>Loading...</p>}
        {isError && <p className="red-text"><span dangerouslySetInnerHTML={{__html: errorText}}></span></p>}
        <div style={{color: "#0d6efd", textAlign: "left", fontSize: "1.5rem", fontWeight: "bold", marginBottom: "12px"}}>
        FAQトピック 編集
        </div>
        <table width="100%">
       <tbody>
       <tr>
       <td align="right" colSpan={2} className="readonlytitle" style={{color: "#666666"}}>作成者:　<label>{creator}</label>　<label>最終更新者：　</label><label>{updater}</label></td>
        </tr>
        </tbody>
      </table>
      <table>
      <tbody>
      <tr>
       </tr>
       {(topicid === '0') ?
        (<tr>
          <td align="right" style={{color: "#0d6efd"}}>ID：</td>
          <td><label>新規</label></td><td></td><td></td><td></td>
        </tr>):
        (<tr>
          <td align="right" style={{color: "#0d6efd"}}>ID：</td>
          <td><label>{topicId}</label></td><td></td><td></td><td></td>
        </tr>)}
        <tr>
        <td  align="right" style={{color: "#0d6efd"}}><label>タイトル： </label></td>  
        <td ><input type="text" name="Title" value={title} onChange={onChangeTitle} style={{width: "33%"}}/></td>
        </tr>
        <tr>
        <td  align="right" style={{color: "#0d6efd"}}><label>内容： </label></td>  
        <td>
        <div style={{width: "50vw"}}>
        {cloud.status === 'error' && <p className="red-text">エディタの読み込みに失敗しました</p>}
        {cloud.status === 'loading' && <p>Loading editor...</p>}
        {cloud.status === 'success' && (() => {
          const {
            ClassicEditor, Essentials, Paragraph, Heading, Bold, Italic, Underline, Strikethrough,
            Alignment, List, Indent, BlockQuote, Link, AutoLink, FontColor, FontFamily, FontSize,
            SourceEditing, HorizontalLine, Table, TableToolbar,
            CodeBlock, Image, ImageInsert, ImageUpload, ImageToolbar, ImageCaption,
            ImageStyle, LinkImage, GeneralHtmlSupport, Autoformat
          } = cloud.CKEditor;
          return (
        <CKEditor
          editor={ClassicEditor}
          config={{
            licenseKey: CKEDITOR_LICENSE_KEY,
            language: 'ja',
            plugins: [
              Essentials, Paragraph, Heading, Bold, Italic, Underline, Strikethrough,
              Alignment, List, Indent, BlockQuote, Link, AutoLink, FontColor, FontFamily, FontSize,
              SourceEditing, HorizontalLine, Table, TableToolbar,
              CodeBlock, Image, ImageInsert, ImageUpload, ImageToolbar, ImageCaption,
              ImageStyle, LinkImage, GeneralHtmlSupport, Autoformat
            ],
            extraPlugins: [ImageUploadAdapterPlugin],
            toolbar: {
              items: [
                'undo', 'redo', '|', 'heading', '|', 'bold', 'italic', 'underline', 'strikethrough', '|',
                'alignment', 'numberedList', 'bulletedList', 'outdent', 'indent', 'blockQuote', '|',
                'link', 'fontColor', 'fontFamily', 'fontSize', '|',
                'horizontalLine', 'insertTable', 'codeBlock', 'insertImage', '|', 'sourceEditing'
              ],
              shouldNotGroupWhenFull: true
            },
            heading: {
              options: [
                { model: 'paragraph', title: 'Paragraph', class: 'ck-heading_paragraph' },
                { model: 'heading1', view: 'h1', title: 'Heading 1', class: 'ck-heading_heading1' },
                { model: 'heading2', view: 'h2', title: 'Heading 2', class: 'ck-heading_heading2' },
                { model: 'heading3', view: 'h3', title: 'Heading 3', class: 'ck-heading_heading3' },
                { model: 'heading4', view: 'h4', title: 'Heading 4', class: 'ck-heading_heading4' },
                { model: 'heading5', view: 'h5', title: 'Heading 5', class: 'ck-heading_heading5' }
              ]
            },
            codeBlock: { languages: codeBlockLanguages },
            // ckeditor4ではリンクのターゲット初期値を_blankにしていたため、新しいタブで開くを既定でONにする
            link: {
              defaultProtocol: 'https://',
              decorators: {
                openInNewTab: {
                  mode: 'manual',
                  label: '新しいタブで開く',
                  defaultValue: true,
                  attributes: { target: '_blank', rel: 'noopener noreferrer' }
                }
              }
            },
            image: {
              toolbar: ['imageTextAlternative', 'toggleImageCaption', '|', 'imageStyle:inline', 'imageStyle:block', 'imageStyle:side', '|', 'linkImage']
            },
            table: {
              contentToolbar: ['tableColumn', 'tableRow', 'mergeTableCells']
            },
            // ckeditor4のallowedContent: true相当（イベントハンドラ属性は除外）
            htmlSupport: {
              allow: [{ name: /.*/, attributes: true, classes: true, styles: true }],
              disallow: [{ attributes: [{ key: /^on.*/i, value: true }] }]
            }
          }}
          onReady={ ( editor: any ) => {
            setCkeditor(editor);
          } }
        />
          );
        })()}
        </div>
        </td>
        </tr>
        <tr>
          <td align="right" style={{color: "#0d6efd"}}>プロダクト：</td>
          <td>
          <select size={5} name="ProductList" value={productId} onChange={onChangeProduct} style={{width: "33%"}}>
          { productList.map((product: any) => (
          <option value={product.id} key={product.id}>{product.name}</option>  
          ))}  
          </select>
          </td>
        </tr>
        <tr>
          <td align="right" style={{color: "#0d6efd"}}>機能名：</td>
          <td >
          <select name="FacilityList" value={facilityId} onChange={onChangeFacility} style={{width: "33%"}}>
          { facilityList.map((facility: any) => (
          <option value={facility.id} key={facility.id}>{facility.name}</option>  
          ))}  
          </select></td>
        </tr>
        <tr>
          <td align="right" style={{color: "#0d6efd"}}>プラットフォーム：</td>
          <td>
          <select name="PlatformList" value={platformId} onChange={onChangePlatform} style={{width: "33%"}}>
          { platformList.map((platform: any) => (
          <option value={platform.id} key={platform.id}>{platform.name}</option>  
          ))}
          </select></td>  
        </tr>
        <tr>
          <td align="right" style={{color: "#0d6efd"}}>バージョン：</td>
          <td >
          <select name="StartVersion" value={startVersionId} onChange={onChangeStartVersion} style={{width: "15%"}}>
          { startVersionList.map((startVersion: any) => (
          <option value={startVersion.id} key={startVersion.id}>{startVersion.name}</option>  
          ))}
          </select> ～ 
          <select name="EndVersion" value={endVersionId} onChange={onChangeEndVersion} style={{width: "15%"}}>
          { endVersionList.map((endVersion: any) => (
          <option value={endVersion.id} key={endVersion.id}>{endVersion.name}</option>  
          ))}
          </select>
          </td>       
        </tr>
        <tr>
          <td align="right" style={{color: "#0d6efd"}}>関連トピック：</td>
          <td ><input type="text" name="RefTopic" value={refTopics} onChange={onChangeRefTopics} style={{width: "33%"}}/></td>
        </tr>
        { (topicid !== 0 && topicid !== '0') &&
		    <tr>
          <td align="right" style={{color: "#0d6efd"}}>添付ファイル：</td>
          {fileName &&
          <td>
            <div style={{display: "inline-flex", alignItems: "center", gap: "8px"}}>
              <label>{fileName}</label>
              <button name="AttacheDel" className="delete-btn" disabled={!fileflag} onClick={delAttachedFile}>削除<i className="material-icons" style={{fontSize: "18px"}}>delete</i></button>
            </div>
          </td>}
        </tr>}
        { (topicid !== 0 && topicid !== '0') &&
        <tr>
        <td align="right" style={{color: "#0d6efd"}}>Upload：</td>
        <td width="90%"><div style={{display: "inline-flex", alignItems: "center", gap: "8px"}}><input name="AttachedFile" type="file" onChange={onChangeFile}/><button name="Upload" className="gray-action-btn" disabled={!file} onClick={attachedFileUpload} style={{opacity: !file ? 0.5 : 1, cursor: !file ? "default" : "pointer"}}>アップロード<i className="material-icons" style={{fontSize: "18px"}}>file_upload</i></button></div></td>
        </tr>}
        <tr>
          <td align="right" style={{color: "#0d6efd"}}>ステータス：</td>
          <td>
            <div style={{display: "flex", gap: "16px"}}>
              <label style={{color: "#0d6efd"}}><input type="checkbox" name="Completed" checked={complete} onChange={onChangeComplete}/>作成完了</label>
              <label style={{color: "#0d6efd"}}><input type="checkbox" name="DeleteFlg" checked={deleteFlg} onChange={onChangeDelete}/>削除可</label>
              <label style={{color: "#0d6efd"}}><input type="checkbox" name="Visible" checked={visible} onChange={onChangeVisible}/>公開[管理用]</label>
            </div>
          </td>
		</tr>
        <tr>
          <td align="right" style={{color: "#0d6efd"}}>DCURL：</td>
          <td ><input type="text" name="DCURL" className="textbox" value={DCURL} onChange={onChangeDCURL} style={{width: "33%"}}/></td>
        </tr>
        <tr>
          <td align="right" style={{color: "#0d6efd"}}>*社内用メモ*：</td>
          <td ><textarea name="Note" rows={3} id="nt" value={note} onChange={onChangeNote} style={{width: "33%"}}></textarea></td>
        </tr>
      { (topicid !== 0 && topicid !== '0') &&
	    <tr>
         <td align="right" style={{color: "#0d6efd"}}>*更新履歴*：</td>
         <td>  
        <div style={{width: "33%"}}>
        <table className="striped bordered" style={{width: "100%"}}>
        <tbody>
        <tr>
          <th style={{color: "#0d6efd"}}>更新日付</th>
  				<th style={{color: "#0d6efd"}}>更新者</th>
  				<th style={{color: "#0d6efd"}}>更新内容</th>
          </tr>
          { updateHistory.map((update: any) => (
          <tr>
          <td >{update.UpdateDate}</td>
          <td >{update.Updater}</td>
          <td >{update.Description}</td>
          </tr>  
          ))}  
          <tr>
  				<td >{newUpdateDate}</td>
  				<td >{newUpdater}</td>
  				<td><textarea name="UpdateDescription" rows={2} id="ud" value={updateDescription} onChange={onChangeUpdateDescription}></textarea></td>
			  </tr>
        </tbody>
        </table>
        </div>
          </td>
        </tr>}
        <tr>
          <td></td>
          <td colSpan={6} align="center">
            <div style={{display: "inline-flex", gap: "8px"}}>
              <button className="gray-action-btn" onClick={() => onClickSave()}>保存<i className="material-icons" style={{fontSize: "18px"}}>save</i></button>
              <button className="gray-action-btn" onClick={() => onClickCancel()}>キャンセル<i className="material-icons" style={{fontSize: "18px"}}>cancel</i></button>
            </div>
          </td>
        </tr>
        </tbody>
        </table>
        </div>
    );

    }
  
    export default TopicEditor;
