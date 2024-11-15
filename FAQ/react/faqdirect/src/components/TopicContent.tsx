import React, { useEffect } from 'react';
import hljs from 'highlight.js/lib/core';
import 'highlight.js/styles/panda-syntax-light.css';
import xml from 'highlight.js/lib/languages/xml';
import python from 'highlight.js/lib/languages/python';
import javascript from 'highlight.js/lib/languages/javascript';
import cos from 'highlight.js/lib/languages/cos';
import sql from 'highlight.js/lib/languages/sql';
import json from 'highlight.js/lib/languages/json';
import yaml from 'highlight.js/lib/languages/yaml';
import dockerfile from 'highlight.js/lib/languages/dockerfile';
import java from 'highlight.js/lib/languages/java';
import css from 'highlight.js/lib/languages/css';
import csharp from 'highlight.js/lib/languages/csharp';


hljs.registerLanguage('xml', xml);
hljs.registerLanguage('python', python);
hljs.registerLanguage('javascript', javascript);
hljs.registerLanguage('cos', cos);
hljs.registerLanguage('sql', sql);
hljs.registerLanguage('json', json);
hljs.registerLanguage('yaml', yaml);
hljs.registerLanguage('dockerfile', dockerfile);
hljs.registerLanguage('java', java);
hljs.registerLanguage('css', css);
hljs.registerLanguage('csharp', csharp);

export const TopicContent = (props: any) => {

  const {response} = props; 

 useEffect(() => {
   hljs.initHighlighting();
   // hljs.initHighlighting.called = false;

   hljs.addPlugin({
    'after:highlightElement': ({ el, result }) => {
      // result の language プロパティが undefined でなければ
      if(result.language) {
        // language を result から取得して code 要素（el）の data-language 属性に設定
      if (result.language === 'cos') {
        el.setAttribute('data-language','ObjectScript');
      }
      else {
        el.setAttribute('data-language',result.language); 
      }
      }
    }
   });
 });
        
  return (
    <>
    {(response.DCURL === "") && <div style = {{ marginLeft: "20px", marginRight: "20px"}}><span dangerouslySetInnerHTML={{__html: response.Description}}></span></div>}	
    {(response.DCURL !== "") && (response.DCURL !== undefined ) && <div style = {{ marginLeft: "20px", marginRight: "20px"}}><span><p>最新内容は、デベロッパーコミュニティをご参照ください</p><a href={response.DCURL}  target="_blank" rel="noreferrer">デベロッパーコミュニティの記事</a></span></div>}	
    </>	
  );	
}
export default TopicContent;
