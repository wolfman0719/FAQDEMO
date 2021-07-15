Class FAQ.KeyWords Extends %Persistent
{

Property KeyWord As %String;

Property TimeStamp As %String;

Property SessionId As %String;

Storage Default
{
<Data name="KeyWordsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>KeyWord</Value>
</Value>
<Value name="3">
<Value>TimeStamp</Value>
</Value>
<Value name="4">
<Value>SessionId</Value>
</Value>
</Data>
<DataLocation>^FAQ.KeyWordsD</DataLocation>
<DefaultData>KeyWordsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^FAQ.KeyWordsD</IdLocation>
<IndexLocation>^FAQ.KeyWordsI</IndexLocation>
<StreamLocation>^FAQ.KeyWordsS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
