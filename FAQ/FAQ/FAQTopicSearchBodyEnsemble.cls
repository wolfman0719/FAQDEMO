Class FAQ.FAQTopicSearchBodyEnsemble Extends  %ZEN.Component.page
{

ClassMethod %OnPreHTTP() As %Boolean [ ServerOnly = 1 ]
{
 #dim %response As %CSP.Response
 set %response.ServerSideRedirect="transfer.csp"
 quit $$$OK
}

}
