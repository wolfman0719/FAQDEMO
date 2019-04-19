Class KB.Product Extends (%Persistent, %XML.Adaptor) [ Inheritance = right ]
{

/// 説明
Property ProductName As %String(TRUNCATE = 1);

Property ProductId As %Integer;

Index ProductNameIndex On ProductName;

Query QueryAll() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID FROM Category
 ORDER BY %ID
}

Query ListProduct() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,ProductName FROM Product
}

ClassMethod Init()
{
	Do ##class(KB.Product).%KillExtent()
	&SQL(insert into KB.Product (ProductName,ProductId) values ('一般',1024))
	&SQL(insert into KB.Product (ProductName,ProductId) values ('Caché',1))
	&SQL(insert into KB.Product (ProductName,ProductId) values ('Ensemble',2))
	&SQL(insert into KB.Product (ProductName,ProductId) values ('HealthShare',4))
	&SQL(insert into KB.Product (ProductName,ProductId) values ('IRIS Data Platform',8))
	&SQL(insert into KB.Product (ProductName,ProductId) values ('HealthShare/IRIS Based',16)) //Including IRIS for Health
	&SQL(insert into KB.Product (ProductName,ProductId) values ('旧データプラットフォーム共通',3))  //Caché & Ensemble
	&SQL(insert into KB.Product (ProductName,ProductId) values ('旧インターオペラビリティ共通(HealthShare)',6))  //Ensemble & HealthShare/Caché Based
	&SQL(insert into KB.Product (ProductName,ProductId) values ('旧データプラットフォーム共通(HealthShare)',7))  //Caché & Ensemble & HealthShare/Caché Based
	&SQL(insert into KB.Product (ProductName,ProductId) values ('インターオペラビリティ共通',10))  //Ensemble & IRIS
	&SQL(insert into KB.Product (ProductName,ProductId) values ('インターオペラビリティ共通(Ensemble + HealthShare/Caché Based + IRIS)',14))  //Ensemble & HealthShare/Caché Based + IRIS
	&SQL(insert into KB.Product (ProductName,ProductId) values ('データプラットフォーム共通',15))  //Caché & Ensemble & HealthShare & IRIS
	&SQL(insert into KB.Product (ProductName,ProductId) values ('インターオペラビリティ/Healthcare共通',22))  //Ensemble & HealthShare & IRIS for Health & HealthShare/IRIS Based
	&SQL(insert into KB.Product (ProductName,ProductId) values ('新インターオペラビリティ共通',24))  //IRIS & HealthShare IRIS based & IRIS for Health
	&SQL(insert into KB.Product (ProductName,ProductId) values ('インターオペラビリティ共通(HealthShare)',30))  //Ensemble & IRIS & HealthShare & IRIS for Health
	&SQL(insert into KB.Product (ProductName,ProductId) values ('データプラットフォーム共通(Health)',31))  //Caché & Ensemble & HealthShare & IRIS & HealthShare/IRIS Based & IRIS for Health
}

Storage Default
{
<Data name="ProductDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ProductName</Value>
</Value>
<Value name="3">
<Value>ProductId</Value>
</Value>
</Data>
<DataLocation>^KB.ProductD</DataLocation>
<DefaultData>ProductDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^KB.ProductD</IdLocation>
<IndexLocation>^KB.ProductI</IndexLocation>
<StreamLocation>^KB.ProductS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
