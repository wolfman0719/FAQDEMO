Class KB.Event Extends %CSP.SessionEvents
{

/// Called when the CSP Daemon times out out this session before calling <method>EndSession</method>.
/// Use the %session object to examine this session. If you wish to abort this deletion then:
/// <example>
/// Set %session.EndSession=0
/// </example>
ClassMethod OnTimeout()
{
	Set %session.EndSession = 1
	Quit
}

}
