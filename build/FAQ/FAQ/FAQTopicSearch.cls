Class FAQ.FAQTopicSearch Extends %ZEN.Component.page
{

ClassMethod %OnPreHTTP() As %Boolean [ ServerOnly = 1 ]
{
 #dim %response As %CSP.Response
 //set %response.ServerSideRedirect="transfer.csp"
 set %response.Redirect="transfer.csp"
 quit $$$OK
}

}
