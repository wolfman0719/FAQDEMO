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
		//タイムゾーンを調整する
	    set tError.EventDateTime = $zdatetime($zdatetimeh($zts,-3),3)
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
<ExtentSize>12</ExtentSize>
<IdLocation>^FAQ.ErrorD</IdLocation>
<IndexLocation>^FAQ.ErrorI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="ErrorDescription">
<AverageFieldSize>116.5</AverageFieldSize>
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="EventDateTime">
<AverageFieldSize>21</AverageFieldSize>
<Selectivity>10.0000%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^FAQ.ErrorS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
