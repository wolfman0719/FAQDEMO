Class KB.Platform Extends (%Persistent, %XML.Adaptor) [ Inheritance = right ]
{

/// プラットフォーム名
Property Name As %String(TRUNCATE = 1);

Index NameIndex On Name;

Query QueryAll() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID FROM Platform
 ORDER BY %ID
}

Query ListDescription() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,Name FROM Platform
}

ClassMethod Init()
{
	Do ##class(KB.Platform).%KillExtent()
	&SQL(insert into KB.Platform (Name) values ('Windows'))
	&SQL(insert into KB.Platform (Name) values ('Linux'))
	&SQL(insert into KB.Platform (Name) values ('MAC OS X'))
	&SQL(insert into KB.Platform (Name) values ('HP-UX'))
	&SQL(insert into KB.Platform (Name) values ('Solaris'))
	&SQL(insert into KB.Platform (Name) values ('AIX'))
	&SQL(insert into KB.Platform (Name) values ('OpenVMS'))
	&SQL(insert into KB.Platform (Name) values ('Linux/UNIX'))
	&SQL(insert into KB.Platform (Name) values ('プラットフォーム共通'))
}

Storage Default
{
<Data name="PlatformDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>^KB.PlatformD</DataLocation>
<DefaultData>PlatformDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^KB.PlatformD</IdLocation>
<IndexLocation>^KB.PlatformI</IndexLocation>
<StreamLocation>^KB.PlatformS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
