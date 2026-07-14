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
	&SQL(insert into KB.Facility (Description) values ('ObjectScript'))
	&SQL(insert into KB.Facility (Description) values ('Object'))
	&SQL(insert into KB.Facility (Description) values ('SQL'))
	&SQL(insert into KB.Facility (Description) values ('Webテクノロジー'))
	&SQL(insert into KB.Facility (Description) values ('言語バインディング/テクノロジー連携'))
	&SQL(insert into KB.Facility (Description) values ('システムコア/アーキテクチャー'))
	&SQL(insert into KB.Facility (Description) values ('インターオペラビリティ'))
	&SQL(insert into KB.Facility (Description) values ('クラウド'))
	&SQL(insert into KB.Facility (Description) values ('開発環境'))
	&SQL(insert into KB.Facility (Description) values ('システム管理/運用'))
	&SQL(insert into KB.Facility (Description) values ('分析/AI'))
	&SQL(insert into KB.Facility (Description) values ('セキュリティ'))
	&SQL(insert into KB.Facility (Description) values ('その他'))
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
