Class KB.Facility Extends (%Persistent, %XML.Adaptor) [ Inheritance = right ]
{

/// 説明
Property Description As %String(TRUNCATE = 1);

Index DescriptionIndex On Description;

Parameter XMLDEFAULTREFERENCE = "ID";

Query QueryAll() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID FROM Facility
 ORDER BY %ID
}

Query ListDescription() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,Description FROM Facility
}

ClassMethod Init()
{
	Do ##class(KB.Facility).%KillExtent()
	&SQL(insert into KB.Facility (Description) values ('一般的質問'))
	&SQL(insert into KB.Facility (Description) values ('InterSystems ObjectScript'))
	&SQL(insert into KB.Facility (Description) values ('Object'))
	&SQL(insert into KB.Facility (Description) values ('SQL'))
	&SQL(insert into KB.Facility (Description) values ('Webテクノロジー'))
	&SQL(insert into KB.Facility (Description) values ('Java'))
	&SQL(insert into KB.Facility (Description) values ('.NET'))
	&SQL(insert into KB.Facility (Description) values ('他言語対応'))
	&SQL(insert into KB.Facility (Description) values ('XML'))
	&SQL(insert into KB.Facility (Description) values ('Web Service'))
	&SQL(insert into KB.Facility (Description) values ('システム'))
	&SQL(insert into KB.Facility (Description) values ('その他'))
	&SQL(insert into KB.Facility (Description) values ('Interoperability'))
	&SQL(insert into KB.Facility (Description) values ('InterSystems Business Intelligence'))
	&SQL(insert into KB.Facility (Description) values ('InterSystems Text Analytics'))
	&SQL(insert into KB.Facility (Description) values ('REST/JSON'))
	&SQL(insert into KB.Facility (Description) values ('Cloud'))
	&SQL(insert into KB.Facility (Description) values ('開発環境'))
	&SQL(insert into KB.Facility (Description) values ('運用関連'))
	&SQL(insert into KB.Facility (Description) values ('人工知能/機械学習'))
	&SQL(insert into KB.Facility (Description) values ('マルチモデル'))
	&SQL(insert into KB.Facility (Description) values ('Embedded Python'))
	&SQL(insert into KB.Facility (Description) values ('Columnar Storage'))
	&SQL(insert into KB.Facility (Description) values ('FHIR SQL Builder'))
	&SQL(insert into KB.Facility (Description) values ('Adaptive Analytics'))
	&SQL(insert into KB.Facility (Description) values ('Foreign Tables'))
	&SQL(insert into KB.Facility (Description) values ('IntegratedML'))
	
}

Storage Default
{
<Data name="FacilityDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>^KB.FacilityD</DataLocation>
<DefaultData>FacilityDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^KB.FacilityD</IdLocation>
<IndexLocation>^KB.FacilityI</IndexLocation>
<StreamLocation>^KB.FacilityS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
