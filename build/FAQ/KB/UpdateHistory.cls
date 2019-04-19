Class KB.UpdateHistory Extends (%Persistent, %Populate, %XML.Adaptor)
{

Property UpdateDate As %String;

Property Updater As %String;

Property Description As %String(MAXLEN = "");

Relationship Topic As KB.Topic [ Cardinality = parent, Inverse = UpdateDetail ];

Index TopicIndex On Topic;

Storage Default
{
<Data name="UpdateHistoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UpdateDate</Value>
</Value>
<Value name="3">
<Value>Updater</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>Topic</Value>
</Value>
</Data>
<DataLocation>^KB.UpdateHistoryD</DataLocation>
<DefaultData>UpdateHistoryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^KB.UpdateHistoryD</IdLocation>
<IndexLocation>^KB.UpdateHistoryI</IndexLocation>
<StreamLocation>^KB.UpdateHistoryS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
