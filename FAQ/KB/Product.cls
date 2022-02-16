Class KB.Product Extends (%Persistent, %XML.Adaptor) [ Inheritance = right ]
{

/// 説明
Property ProductName As %String(MAXLEN = 100, TRUNCATE = 1);

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
	&SQL(insert into KB.Product (ProductName,ProductId) values ('旧HealthShare',4))
	&SQL(insert into KB.Product (ProductName,ProductId) values ('IRIS Data Platform',8))
	&SQL(insert into KB.Product (ProductName,ProductId) values ('IRIS for Health',16))
	&SQL(insert into KB.Product (ProductName,ProductId) values ('Caché & Ensemble',3))
	&SQL(insert into KB.Product (ProductName,ProductId) values ('Ensemble & 旧HealthShare',6))
	&SQL(insert into KB.Product (ProductName,ProductId) values ('Caché & Ensemble & 旧HealthShare',7))
	&SQL(insert into KB.Product (ProductName,ProductId) values ('Ensemble & IRIS',10))
	&SQL(insert into KB.Product (ProductName,ProductId) values ('Ensemble + 旧HealthShare + IRIS',14))  
	&SQL(insert into KB.Product (ProductName,ProductId) values ('Caché & Ensemble & 旧HealthShare & IRIS',15))  
	&SQL(insert into KB.Product (ProductName,ProductId) values ('Ensemble & 旧HealthShare & IRIS for Health',22)) 
	&SQL(insert into KB.Product (ProductName,ProductId) values ('IRIS Data Platform & IRIS for Health',24)) 
	&SQL(insert into KB.Product (ProductName,ProductId) values ('Ensemble & IRIS & 旧HealthShare & IRIS for Health',30))  
	&SQL(insert into KB.Product (ProductName,ProductId) values ('Caché & Ensemble & 旧HealthShare & IRIS & IRIS for Health',31))
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
<ExtentSize>15</ExtentSize>
<IdLocation>^KB.ProductD</IdLocation>
<IndexLocation>^KB.ProductI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="ProductId">
<AverageFieldSize>3.07</AverageFieldSize>
<Selectivity>6.6667%</Selectivity>
</Property>
<Property name="ProductName">
<AverageFieldSize>45</AverageFieldSize>
<Selectivity>6.6667%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-4</BlockCount>
</SQLMap>
<SQLMap name="ProductNameIndex">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^KB.ProductS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
