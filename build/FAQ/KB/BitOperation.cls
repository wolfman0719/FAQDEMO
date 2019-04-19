Include (bitutil)

Class KB.BitOperation
{

ClassMethod bitalloc(gn As %String, on As %Boolean, length As %Integer)
{
  Set chunk=(length-1)\$$$CHUNKSIZE,offset=length-(chunk*$$$CHUNKSIZE)
  For i = 1:1:chunk {
	 For j = 1:1:$$$CHUNKSIZE {
		 Set $Bit(@gn@(i),j)=on
	 }
  }
  For i = 1:1:offset {
    Set $Bit(@gn@(chunk+1),i)=on
  }
}

ClassMethod bitset(gn As %String, col As %Integer)
{
  //Cache SQLで使用するビットマップインデックスの1ビット目は使用していないため,1ずらす
  set col = col + 1
  Set chunk=(col-1)\$$$CHUNKSIZE,offset=col-(chunk*$$$CHUNKSIZE)
  Set $Bit(@gn@(chunk+1),offset)=1
}

ClassMethod bitclear(gn As %String, col As %Integer)
{
  //Cache SQLで使用するビットマップインデックスの1ビット目は使用していないため,1ずらす
   set col = col + 1	
   Set chunk=(col-1)\$$$CHUNKSIZE,offset=col-(chunk*$$$CHUNKSIZE)
   Set $Bit(@gn@(chunk+1),offset)=0
}

ClassMethod bitget(gn As %String, col As %Integer) As %Boolean
{
  //Cache SQLで使用するビットマップインデックスの1ビット目は使用していないため,1ずらす
 set col = col + 1
 set $zt = "error"
 Set chunk=(col-1)\$$$CHUNKSIZE,offset=col-(chunk*$$$CHUNKSIZE)
 Quit $Bit(@gn@(chunk+1),offset)
error	quit 0
}

ClassMethod bitcount(gn As %String, on As %Boolean = 1) As %Integer
{
	Set chunk="",cnt=0
	//chunkでループ
	For  {
		Set chunk=$Order(@gn@(chunk))
		Quit:chunk=""
		
		Set cnt = cnt + $BITCOUNT((@gn@(chunk)),on)
			
 
		}
		Quit cnt
}

ClassMethod bitand(gn1 As %String, gn2 As %String, result As %String)
{
	Set chunk=""
	//chunkでループ
	For  {
		Set chunk=$Order(@gn1@(chunk))
		Quit:chunk=""
				
		Set @result@(chunk)=$BITLOGIC(
			(@gn1@(chunk))
			&(@gn2@(chunk)))
								
		}
}

ClassMethod bitor(gn1 As %String, gn2 As %String, result As %String)
{
	Set chunk=""
	//chunkでループ
	For  {
		Set chunk=$Order(@gn1@(chunk))
		Quit:chunk=""
				
		Set @result@(chunk)=$BITLOGIC(
			(@gn1@(chunk))
			|(@gn2@(chunk)))
								
		}
}

ClassMethod bitnot(gn1 As %String, result As %String)
{
	Set chunk=""
	//chunkでループ
	For  {
		    Set chunk=$Order(@gn1@(chunk))
		    Quit:chunk=""
				
		    Set @result@(chunk)=$BITLOGIC(
			    ~(@gn1@(chunk)))
			if chunk = 1 {
				//先頭の1ビットは、かならず0
				set $bit(@result@(chunk),1) = 0
		    }
								
		}
}

ClassMethod bitandnot(gn1 As %String, gn2 As %String, result As %String)
{
	Set chunk=""
	//chunkでループ
	For  {
		    Set chunk=$Order(@gn1@(chunk))
		    Quit:chunk=""
				
		    Set @result@(chunk)=$BITLOGIC(
			    @gn1@(chunk)&~(@gn2@(chunk)))
			if chunk = 1 {
				//先頭の1ビットは、かならず0
				set $bit(@result@(chunk),1) = 0
		    }
								
		}
}

ClassMethod bitfind(gn As %String, on As %Boolean, col As %Integer) As %Integer
{
    //Cache SQLで使用するビットマップインデックスの1ビット目は使用していないため,1ずらす
	set col = col + 1
    Set chunk=(col-1)\$$$CHUNKSIZE,offset=col-(chunk*$$$CHUNKSIZE)
    //chunkでループ
    Set start = chunk*$$$CHUNKSIZE
    For  {
	   Set chunk=$Order(@gn@(chunk))
	   Quit:chunk=""							
	   Set pos = $BITFIND(@gn@(chunk),on,offset)
	   If pos=0 {
		  Set offset = 0 	
          Set start = start + $$$CHUNKSIZE
	   }
      Quit:pos
	}
	If chunk="" {
		Set start = 0
		Set pos = 0
	}
	Quit start+pos
}

// 引数1　bsgn　ビットスライス用インデックスグローバル参照　Cache SQLが生成する構造を想定

// 引数2　cdgn　計算条件用ビットマップグローバル

ClassMethod bitslicesum(bsgn As %String, cdgn As %String) As %Integer
{
	Set bitno="",sum = 0
	//bitnoは、2進の桁数を表す
	For  {
		  Set bitno=$Order(@bsgn@(bitno))
		  Quit:(bitno="-")||(bitno="N")||(bitno="Z")||(bitno="")
		  // Cache SQLが生成するbitsliceインデックスには、-,N,Zを表現するbit列を別に持つ
		  
		  Set no = 2 ** (bitno - 1)		//桁数は飛び飛びになりうるので、この様に計算する
		  Set chunk=""
		  For {
			Set chunk=$Order(@bsgn@(bitno,chunk))
			Quit:chunk=""
			set select = $bitlogic(@bsgn@(bitno,chunk)&@cdgn@(chunk))
			set minus = $get(@bsgn@("-",chunk))
			
			// 全体を加算後、マイナス分を2倍して引く
			
			Set sum = sum + (no * ($bitcount(select,1) - (2*$bitcount($bitlogic(select&minus),1))))  
		  }
	} 	
 
   Quit sum
}

ClassMethod bitslicesum1(bsgn As %String) As %Integer
{
	Set bitno="",sum = 0
	//bitnoは、2進の桁数を表す
	For  {
		  Set bitno=$Order(@bsgn@(bitno))
		  Quit:(bitno="-")||(bitno="N")||(bitno="Z")||(bitno="")
		  // Cache SQLが生成するbitsliceインデックスには、-,N,Zを表現するbit列を別に持つ
		  
		  Set no = 2 ** (bitno - 1)		//桁数は飛び飛びになりうるので、この様に計算する
		  Set chunk=""
		  For {
			Set chunk=$Order(@bsgn@(bitno,chunk))
			Quit:chunk=""
			//set select = $bitlogic(@bsgn@(bitno,chunk)&@cdgn@(chunk))
			set select = $get(@bsgn@(bitno,chunk))
			set minus = $get(@bsgn@("-",chunk))
			
			// 全体を加算後、マイナス分を2倍して引く
			
			Set sum = sum + (no * (($bitcount(select,1) - (2*$bitcount($bitlogic(select&minus),1)))))  
		  }
	} 	
 
   Quit sum
}

}
