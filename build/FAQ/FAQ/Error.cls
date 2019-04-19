Class FAQ.Error Extends (%Persistent, %XML.Adaptor)
{

/// アプリケーションエラーを記録するクラス
Property EventDateTime As %TimeStamp;

Property ErrorDescription As %String(MAXLEN = 1000);

ClassMethod StoreErrorInformation(pException As %Exception.General) As %Status
{
	Set tSC = $$$OK
	Try {
	    set tError = ##class(FAQ.Error).%New()
	    set tError.EventDateTime = $zdatetime($zts,3)
	    set tStatus = pException.AsStatus()
	    set tSC = $System.Status.DecomposeStatus(tStatus,.tErrorContent)
	    set n = ""
	    Do {
		   set n= $order(tErrorContent(n))
		   if n = "" quit
		   set tErrorContent = $get(tErrorContent)_$get(tErrorContent(n))
	    } while n='""

	   set tError.ErrorDescription = $Get(tErrorContent)
	   set tSC = tError.%Save()
	} 
	Catch tE {
		Set ^FAQError(tError.EventDateTime)= $Get(tStatus)
	}
	quit tSC
}

Storage Default
{
<Data name="ErrorDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EventDateTime</Value>
</Value>
<Value name="3">
<Value>ErrorDescription</Value>
</Value>
</Data>
<DataLocation>^FAQ.ErrorD</DataLocation>
<DefaultData>ErrorDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^FAQ.ErrorD</IdLocation>
<IndexLocation>^FAQ.ErrorI</IndexLocation>
<StreamLocation>^FAQ.ErrorS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
