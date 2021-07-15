/*** Zen Module: FAQ ***/

self._zenClassIdx['http://www.intersystems.com/zen/mojo/faq/FAQTopicQueryTemplate'] = 'FAQ_FAQTopicQueryTemplate';
self.FAQ_FAQTopicQueryTemplate = function(index,id) {
	if (index>=0) {FAQ_FAQTopicQueryTemplate__init(this,index,id);}
}

self.FAQ_FAQTopicQueryTemplate__init = function(o,index,id) {
	('undefined' == typeof _ZEN_Mojo_Component_contentTemplate__init) ?zenMaster._ZEN_Mojo_Component_contentTemplate__init(o,index,id):_ZEN_Mojo_Component_contentTemplate__init(o,index,id);
}
function FAQ_FAQTopicQueryTemplate_serialize(set,s)
{
	var o = this;s[0]='2350274433';s[1]=o.index;s[2]=o.id;s[3]=o.name;s[4]=set.addObject(o.parent,'parent');s[5]=set.addObject(o.composite,'composite');s[6]=o.align;s[7]=o.aux;s[8]=o.containerStyle;s[9]=(o.dragEnabled?1:0);s[10]=(o.dropEnabled?1:0);s[11]=(o.dynamic?1:0);s[12]=o.enclosingClass;s[13]=o.enclosingStyle;s[14]=o.error;s[15]=o.height;s[16]=(o.hidden?1:0);s[17]=o.hint;s[18]=o.hintClass;s[19]=o.hintStyle;s[20]=o.label;s[21]=o.labelClass;s[22]=o.labelDisabledClass;s[23]=o.labelStyle;s[24]=o.onafterdrag;s[25]=o.onbeforedrag;s[26]=o.ondrag;s[27]=o.ondrop;s[28]=o.onhide;s[29]=o.onrefresh;s[30]=o.onshow;s[31]=o.onupdate;s[32]=o.overlayMode;s[33]=o.renderFlag;s[34]=(o.showLabel?1:0);s[35]=o.slice;s[36]=o.title;s[37]=o.tuple;s[38]=o.valign;s[39]=(o.visible?1:0);s[40]=o.width;
}
function FAQ_FAQTopicQueryTemplate_getSettings(s)
{
	s['name'] = 'string';
	this.invokeSuper('getSettings',arguments);
}

self.FAQ_FAQTopicQueryTemplate_getLayout = function(key,criteria) {
var content = null;
switch(key) {
case 'query-entry' :
content = {
children:[
{type:'$header',caption:'=[sectionHeader]'},
{ type: '$div', style: 'text-align: center;', children: [
{ type: '$grid', showBox: false, children: [
{
type: '$text', placeHolder: '=[inputPrompt]', fieldcontain: false,
key: 'query-text', label: '=[inputPrompt]', apply: true
},
]},
{ type: '$grid', showBox: false, children: [
{ type: '$button', caption: '=[buttonLabel]', key: 'query-button' }
]},
]}
]
};
break;
case 'list-topics' :
content = {
children:[
{type:'$header',caption:'=[sectionHeader]'},
{type:'$listview',value:'=[topicList]',filter:true,children:[
{type:'$listviewitem',key:'drill-topic',value:'=[id]',label:'=[title]',content:'=[sdesc]',clickable:true,labelNoWrapper:true }
]}
]
};
break;
case 'show-topic' :
content = {
children:[
{type:'$header',caption:'=[sectionHeader]'},
{type:'$h1',$content:'=[title]'},
{type:'$content',content:'=[description]',style: 'word-wrap: break-word;'},
]
};
break;
}
return content;
}

self.FAQ_FAQTopicQueryTemplate_onGetContent = function(which,key,criteria) {
switch (which)
{
case 'layout':
return this.getLayout(key,criteria);
case 'data':
}
return null;
}

self.FAQ_FAQTopicQueryTemplate_onchange = function(key,value,final,docViewId) {
console.log('change ' + key + ' to ' + value);
var view = zen(docViewId);
switch(key) {
}
}

self.FAQ_FAQTopicQueryTemplate_onselect = function(key,value,docViewId) {
console.log('select '+key);
var mainView = zen(docViewId);
var realKey = key.split(':')[0];
switch(realKey) {
case 'query-button':
var qt=zen('mainView').getItemByKey('query-text');
mainView.pushDocument('list-topics',{queryText:qt.value},'list-topics',{queryText:qt.value});
break;
case 'drill-topic':
mainView.pushDocument('show-topic',{id:value},'show-topic',{id:value});
break;
}
}

self.FAQ_FAQTopicQueryTemplate_ReallyRefreshContents = function() {
	zenInstanceMethod(this,'ReallyRefreshContents','','',arguments);
}
self.FAQ_FAQTopicQueryTemplate__Loader = function() {
	zenLoadClass('_ZEN_Mojo_Component_contentTemplate');
	FAQ_FAQTopicQueryTemplate.prototype = zenCreate('_ZEN_Mojo_Component_contentTemplate',-1);
	var p = FAQ_FAQTopicQueryTemplate.prototype;
	if (null==p) {return;}
	p.constructor = FAQ_FAQTopicQueryTemplate;
	p.superClass = ('undefined' == typeof _ZEN_Mojo_Component_contentTemplate) ? zenMaster._ZEN_Mojo_Component_contentTemplate.prototype:_ZEN_Mojo_Component_contentTemplate.prototype;
	p.__ZENcomponent = true;
	p._serverClass = 'FAQ.FAQTopicQueryTemplate';
	p._type = 'FAQTopicQueryTemplate';
	p.serialize = FAQ_FAQTopicQueryTemplate_serialize;
	p.getSettings = FAQ_FAQTopicQueryTemplate_getSettings;
	p.ReallyRefreshContents = FAQ_FAQTopicQueryTemplate_ReallyRefreshContents;
	p.getLayout = FAQ_FAQTopicQueryTemplate_getLayout;
	p.onGetContent = FAQ_FAQTopicQueryTemplate_onGetContent;
	p.onchange = FAQ_FAQTopicQueryTemplate_onchange;
	p.onselect = FAQ_FAQTopicQueryTemplate_onselect;
}
/* EOF */