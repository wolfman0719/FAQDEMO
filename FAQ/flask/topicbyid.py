from flask import Flask, render_template, request, redirect
from markupsafe import Markup
import iris

def topic_byid(id):
    try:

      sql="select title,description,reftopic,product->productid as productid, dcurl, versionrange from kb.topic WHERE id = ?"
      stmt=iris.sql.prepare(sql)
      rset=stmt.execute(id)
      record = rset.__next__()
    
      description = record[1]
      # flaskの存在場所は、/csp/faqflaskで固定
      # cspの場所も/csp/faqで固定
      replacetext = '../../faq/images'
      description = description.replace('./images',replacetext)
      reftopics = record[2]
      refarray = []
      if (reftopics is not ''):
        for refno in reftopics.split(','):
          sql2="select title from kb.topic WHERE id = ? and completed=1 and visible=1 and deleteflg!=1"
          stmt2=iris.sql.prepare(sql2)
          rset2=stmt2.execute(refno)
          for record2 in rset2.__next__():
            refarray.append(['/topicid/' + str(refno),record2])
      filename = iris.cls('KB.Config').getAttachedFileName() + str(id) + '.zip'
      dir = iris.cls('KB.Config').getFTPDirectory()
      sep = iris.cls('KB.Config').getDirectorySeparator()
      filepath = dir + sep + filename
      fileexists = iris.cls('%File').Exists(filepath)
      downloadFile = ''
      if (fileexists == 1):    
        downloadFile =  '../../faq/downloads/' + filename
      dcurl = record[4]
      productText = iris.cls('%CSP.Page').UnescapeHTML(iris.cls('KB.Utility').ProductText(record[3]))
      versionRange = record[5]	   
      result = {'title': record[0], 'description': Markup(description),'fileexists': fileexists,'downloadfile': downloadFile,'DCURL': dcurl, 'producttext': productText, 'versionrange': versionRange, 'reftopics': refarray, 'error': ''}

      return result
    except Exception as e:
      result = {'error': 'エラー発生: 該当ドキュメントが見つかりません'}
      return result
    
def dcurl_byid(id):
    try:

      sql3="select dcurl from kb.topic WHERE id = ?"
      stmt3=iris.sql.prepare(sql3)
      rset3=stmt3.execute(id)
      record3 = rset3.__next__()
      dcurl = record3[0]
      return dcurl

    except Exception as e:
      return ''

app = Flask(__name__)

@app.route('/')
def index():
    return 'Top Page'

@app.route('/topicid/<topic_id>', methods=['GET'])
def get_topic(topic_id):
    dcurl = dcurl_byid(topic_id)
    if (dcurl != ''):
      return redirect(dcurl)
    else:
      result = topic_byid(topic_id)
      return render_template("result.html",get_result=result)

if __name__ == '__main__':
    app.run(debug=True) 
