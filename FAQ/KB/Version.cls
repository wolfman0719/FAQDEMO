Class KB.Version Extends (%Persistent, %XML.Adaptor) [ Inheritance = right ]
{

/// 表示用バージョン番号
Property ExternalVersion As %String(MAXLEN = 20, TRUNCATE = 1);

/// 内部バージョン（大小比較用）
Property InternalVersion As %Integer;

/// 時系列順ID
Property OrderId As %Integer;

Index ExternalVersionIndex On ExternalVersion;

Index InternalVersionIndex On InternalVersion;

Index OrderIdIndex On OrderId;

Query QueryAll() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID FROM Version
 ORDER BY %ID
}

Query ListDescription() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,ExternalVersion FROM Version ORDER BY OrderId
}

// Parameter XMLSUMMARY = ID;

Parameter XMLDEFAULTREFERENCE = "ID";

ClassMethod Init()
{
	Do ##class(KB.Version).%KillExtent()
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('300','3.0'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('310','3.1.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('320','3.2.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('400','4.0.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('410','4.1.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('500','5.0.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('510','5.1.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('520','5.2.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('20071','2007.1.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('20081','2008.1.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('20082','2008.2.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('20091','2009.1.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('20101','2010.1.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('20102','2010.2.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('20111','2011.1.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('20121','2012.1.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('20122','2012.2.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('20131','2013.1.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('20141','2014.1.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('20151','2015.1.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('20152','2015.2.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('20161','2016.1.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('20162','2016.2.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('20171','2017.1.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('20172','2017.2.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('20181','2018.1.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('20182','2018.2.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('20191','2019.1.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('20192','2019.2.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('20201','2020.1.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('20202','2020.2.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('20211','2021.1.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('20212','2021.2.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('20221','2022.1.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('20222','2022.2.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('20231','2023.1.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('20241','2024.1.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('20242','2024.2.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('20243','2024.3.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('20251','2025.1.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('20252','2025.2.x'))
}

ClassMethod SetVersionRange(pStart As KB.Version, pEnd As KB.Version) As %String
{
  if $isobject(pStart) {
	set startname=pStart.ExternalVersion
	set startorder=pStart.OrderId
  }
  else{
	set startver="",startname="",startorder=""
  }

  if $isobject(pEnd) {
	set endname=pEnd.ExternalVersion
	set endorder=pEnd.OrderId
  }
  else{
	set endver="",endname="",endorder=""
  }

  if $isobject(pStart) {
	if $isobject(pEnd) {
		if startorder > endorder {
		  set vrange=""
		}
		elseif pStart.%Id()=pEnd.%Id() {
		  set vrange=startname
		}
		else
		{
		  set vrange=startname_" ～ "_endname
		}
	}
	else
	{
	  set vrange=startname_" ～"
	}
  }
  elseif $isobject(pEnd) {
    set vrange=" ～ "_endname
  }
  else {
    set vrange=""
  }
 
 quit vrange
}

Storage Default
{
<Data name="VersionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ExternalVersion</Value>
</Value>
<Value name="3">
<Value>InternalVersion</Value>
</Value>
<Value name="4">
<Value>OrderId</Value>
</Value>
</Data>
<DataLocation>^KB.VersionD</DataLocation>
<DefaultData>VersionDefaultData</DefaultData>
<ExtentSize>37</ExtentSize>
<IdLocation>^KB.VersionD</IdLocation>
<IndexLocation>^KB.VersionI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,16,$lb("-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000"),$lb(21,21,21,21,21,21,21,21,21,21,21,21,21,21,21),$lb(758198320,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,758198320))</Histogram>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>3</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,0,$lb(1,3,6,9,12,15,18,21,23,25,27,29,31,33,35,37),$lb(0,0,0,0,1,1,0,1,1,1,1,0,1,1,1),"")</Histogram>
<Selectivity>1</Selectivity>
</Property>
<Property name="ExternalVersion">
<AverageFieldSize>9.3</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" 2007.1.X"," 2008.2.X"," 2010.2.X"," 2012.2.X"," 2015.1.X"," 2016.2.X"," 2018.1.X"," 2019.2.X"," 2020.2.X"," 2021.2.X"," 2022.2.X"," 2024.1.X"," 3.1.X"," 4.0.X"," 5.0.X"," 5.2.X"),$lb(4,3,4,4,4,4,4,3,4,4,4,1,1,1,3),$lb(540160048,925774126,942551598,808988210,825241138,808333870,841888302,841888302,892219694,892219694,908997166,908997166,942551342,942551342,959328814,825830962,842018354,808333870,825111086,825111086,841888302,841888302,875442478,842019380,858665262,858665262,875442222,875442222,892219438,808343552,841897984,540356146))</Histogram>
<Selectivity>2.7027%</Selectivity>
</Property>
<Property name="InternalVersion">
<AverageFieldSize>4</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,0,$lb(300,320,500,20071,20091,20111,20131,20152,20162,20172,20182,20192,20202,20212,20222,20241),$lb(1,0,0,3,2,3,3,3,3,3,3,2,3,3,3),"")</Histogram>
<Selectivity>2.7027%</Selectivity>
</Property>
<Property name="OrderId">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,16,$lb(-10000000000000000000,-10000000000000000000,-10000000000000000000,-10000000000000000000,-10000000000000000000,-10000000000000000000,-10000000000000000000,-10000000000000000000,-10000000000000000000,-10000000000000000000,-10000000000000000000,-10000000000000000000,-10000000000000000000,-10000000000000000000,-10000000000000000000,-10000000000000000000),$lb(21,21,21,21,21,21,21,21,21,21,21,21,21,21,21),"")</Histogram>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<SQLMap name="ExternalVersionIndex">
<BlockCount>-4</BlockCount>
</SQLMap>
<SQLMap name="IDKEY">
<BlockCount>-4</BlockCount>
</SQLMap>
<SQLMap name="InternalVersionIndex">
<BlockCount>-4</BlockCount>
</SQLMap>
<SQLMap name="OrderIdIndex">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^KB.VersionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
