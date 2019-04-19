Class KB.UsersVoice Extends %Persistent
{

Property TopicId As %String;

Property RefFreq As %Integer [ InitialExpression = 0 ];

Property EnqYes As %Integer [ InitialExpression = 0 ];

Property EnqNo As %Integer [ InitialExpression = 0 ];

Storage Default
{
<Data name="UsersVoiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RefFreq</Value>
</Value>
<Value name="3">
<Value>EnqYes</Value>
</Value>
<Value name="4">
<Value>EnqNo</Value>
</Value>
<Value name="5">
<Value>TopicId</Value>
</Value>
</Data>
<DataLocation>^KB.UsersVoiceD</DataLocation>
<DefaultData>UsersVoiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^KB.UsersVoiceD</IdLocation>
<IndexLocation>^KB.UsersVoiceI</IndexLocation>
<StreamLocation>^KB.UsersVoiceS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
