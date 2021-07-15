Class FAQ.SessionEvents Extends %CSP.SessionEvents
{

/// Called when a new session is created and its values are initialised.
/// <p>This is called before the license for this session is allocated, and if
/// you wish to abort this session and return the standard out of licenses error
/// page then:
/// <example>
/// Set %session.EndSession=1
/// </example>
ClassMethod OnStartSession()
{
    s x=$system.License.PublicWebAppUser() 
    
	//FAQアプリへのアクセスカウント
	set ^AccessCountTest = $Get(^AccessCountTest)+1
	set today=$zdate($h,8)
	set ^AccessCountTest(today) = $Get(^AccessCountTest(today))+1
    
    q $$$OK
}

}
