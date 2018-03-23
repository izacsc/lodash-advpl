
#include "protheus.ch"
#include "lodash.ch"

#DEFINE INFINITY  1/(0.1^30) //O mais perto que eu cheguei
#DEFINE CLONE_DEEP_FLAG 1
#DEFINE MAX_SAFE_INTEGER 9007199254740991

User Function _( id )
    Local nActivation := 0
    Local cProcname   := ""

    If id == Nil
        id := "_"
    EndIf

    If Type( id ) == "U"

        While ProcName( ++ nActivation ) != ""
            cProcname := ProcName( nActivation )
        EndDo

        oLodash := lodash( ):New( )

        _SetNamedPrvt( id, oLodash, cProcname )
    ElseIf !( Type( id ) == "O" .And. &( id ):ClassName( ) == "lodash" )
        UserException( "It was not possible to instantiate lodash. Id '" + id +  "' already in use." )
    EndIf

Return &( id ):Version( )

Class lodash From LongNameClass

    Method new( ) //Constructor
    Method version( )
    Method className( )

    Method chunk( )
    Method compact( )
    Method concatenate( )
    Method drop( )
    Method dropRight( )
    Method dropRightWhile( )
    Method dropWhile( )
    Method fill( )
    Method findIndex( )
    Method findLastIndex( )
    Method first( )
    Method flatten( )
    Method flattenDeep( )
    Method flattenDepth( )
    Method fromPairs( )
    Method head( )
    Method indexOf( )
    Method initial( )
    Method last( )
    Method lastIndexOf( )
    Method nth( )

EndClass

Method new( ) Class lodash

    Return self

Method className( ) Class lodash

    Return "lodash"

Method version( ) Class lodash

    Return "0.1"

Method chunk( array, size, guard ) Class lodash
    Local length   := If array == Nil ? 0 : Len( array )
    Local index    := 0
    Local resIndex := 1
    Local result   := { }

    If ( If guard != Nil ? isIterateeCall( array, size, guard ) : size == Nil )
        size := 1
    Else
        size := Max( toInteger( size ), 0 )
    EndIf

    If length == Nil .Or. size < 1
        Return { }
    EndIf

    result := Array( Ceiling( ( length / size ) ) )

    While index < length
        result[ resIndex++ ] := baseSlice( array, index, ( index + size ) )
        index += size
    EndDo

    Return result

Method compact( array ) Class lodash
    Local result := { }
    Local length := If array == Nil ? 0 : Len( array )
    Local index  := 0
    Local value

    While index++ < length
        value := array[ index ]

        If Empty( value )
            Loop
        EndIf

        AAdd( result, array[ index ] )

    EndDo

    Return result

Method concatenate( array, params ) Class lodash
    Local result  := AClone( array )
    Local flatten := ::flatten( params )

    arrayPush( result, flatten )

    Return result

Static Function arrayPush( array, values )
    Local index  := 0
    Local length := Len( values )

    While index ++ < length
        AAdd( array, values[ index ] )
    EndDo

    Return

Method flattenDepth( array, depth ) Class lodash

    Return baseFlatten( array, depth )

Method flatten( array ) Class lodash

    Return baseFlatten( array, 1 )

Method flattenDeep( array ) Class lodash

    Return baseFlatten( array, 9999 )

Static Function baseFlatten( array, depth, result )
    Local index  := 0
    Local length := Len( array )
    Local value

    If Empty( result )
        result := { }
    EndIf

    While index ++ < length
        value := array[ index ]
        If ( depth > 0 .And. ValType( value ) == "A" )
            If ( depth > 1 )
                baseFlatten( value, depth - 1, result )
            Else
                arrayPush( result, value )
            EndIf
        Else
            AAdd( result, value )
        EndIf
    EndDo

    Return result

Method first( array ) Class lodash
    Return ::head( array )

Method head( array ) Class lodash
    Return If ( ValType( array ) == "A" .And. Len( array ) > 0 ) ? array[ 1 ] : Nil

Method drop( array, n, guard ) Class lodash
    Local length := If array == Nil ? 0 : Len( array )

    If length == 0
        Return { }
    EndIf

    n := If ( guard != Nil .Or. n == Nil ) ? 1 : toInteger( n )

    Return baseSlice( array, If n < 0 ? 0 : n, length )

Method dropRight( array, n, guard ) Class lodash
    Local length := If array == Nil ? 0 : Len( array )

    If length == 0
        Return { }
    EndIf

    n := If ( guard != Nil .Or. n == Nil ) ? 1 : toInteger( n )
    n := length - n

    Return baseSlice( array, 0, If n < 0 ? 0 : n )

Static Function toInteger( value )
    Local result    := toFinite( value )
    Local remainder := result % 1

    Return If remainder > 0 ? result - remainder : result

Static Function  toFinite( value )
    Local sign 

    If value == Nil
        Return 0
    EndIf

    value := toNumber( value )

    If value == INFINITY .Or. value == -INFINITY
        sign := If value < 0 ? -1 : 1 
        Return sign * MAX_INTEGER
    EndIf

    Return If value == value ? value : 0

Static Function toNumber( value )
    Local isBinary

    If ValType(value) == 'N'
        Return value
    EndIf

    If isSymbol( value )
        Return NAN
    EndIf

    // If isObject( value )
    //     Local other := If typeof value.valueOf == 'function' ? value.valueOf( ) : value
    //     value := If isObject( other ) ? ( other + '' ) : other
    // EndIf

    If Valtype(value) != 'C'
        Return If value == 0 ? value : +value
    EndIf

    value := AllTrim(value)
    Return Val(value)
    // isBinary :=  .F. //reIsBinary:test( value )
    // Return If ( isBinary .Or. .F. ;//reIsOctal:test( value ) );
    //        ? freeParseInt( value.slice( 2 ), isBinary ? 2 : 8 )
    //        : ( reIsBadHex.test( value ) ? NAN : +value )

Static Function toLength( n )
    //TODO implementar
    Return If n == Nil ?  1 : n

Static Function baseSlice( array, start, finish )
    Local index  := 0
    Local length := Len( array )
    Local result := { }

    If start < 0
        start := If -start > length ? 0 : ( length + start )
    EndIf

    finish := If finish > length ? length : finish

    If finish < 0
        finish += length
    EndIf

    length := If start > finish ? 0 : ( finish - start )

    result := Array( length )

    While index ++ < length
        result[ index ] := array[ index + start ]
    End

    Return result

Method fill( array, value, start, finish ) Class lodash
    Local length := If array == Nil ? 0 : Len( array )

    If Empty( length )
        Return { }
    EndIf

    If start != Nil .And. ValType( start ) != 'N' .And. isIterateeCall( array, value, start )
        start := 1
        finish := length
    EndIf

    Return baseFill( array, value, start, finish )


Function baseFill( array, value, start, finish )
    Local length := Len( array )

    If start == Nil
        start := 1
    EndIf

    start := toInteger( start )

    If start < 0
        start := If -start > length ? 0 : ( length + start )
    EndIf

    finish := If ( finish == Nil .Or. finish > length ) ? length + 1 : toInteger( finish )

    If finish < 0
        finish += length + 1
    EndIf

    finish := If start > finish ? 0 : toLength( finish )

    While start < finish
        array[ start++ ] := value
    EndDo

    Return array

Static Function isIterateeCall( )

Return .F.

Method dropWhile( array, predicate ) Class lodash
    Return If array != Nil .And. Len( array ) > 0 ;
        ? baseWhile( array, getIteratee( predicate, 3 ), .T. );
        : { }

Method dropRightWhile( array, predicate ) Class lodash
    Return If array != Nil .And. Len( array ) > 0 ;
        ? baseWhile( array, getIteratee( predicate, 3 ), .T., .T. );
        : { }

Static Function baseWhile( array, predicate, isDrop, fromRight )
    Local length  := Len( array )
    Local index   := If fromRight ? length : 0
    Local start   := 0
    Local finish  := 0

    If fromRight
        While index > 0 .And. Eval predicate( array[ index ], index, array )
            index --
        EndDo
    Else
        While index ++ < length .And. Eval predicate( array[ index ], index, array )
        EndDo
    EndIf

    If isDrop
        Return baseSlice( array, If fromRight ? 0 : index - 1, If fromRight ? index : length )
    Else
        Return baseSlice( array, If fromRight ? index + 1  : 0, If fromRight ? length : index - 1 )
    EndIf

Static Function getIteratee( arg1, arg2 )
    Local result := Function( x, y )->iteratee( x, y )

    Return If arg1 != Nil ? Eval result( arg1, arg2 ) : result

 Static Function iteratee( fun )
      Return baseIteratee( fun )
    //   Return baseIteratee( If ValType( func ) == 'B' ? func : baseClone( func, CLONE_DEEP_FLAG ) )

Static Function baseClone( par1, flag )

    Return par1

Function baseIteratee( value )

    If ValType( value ) == 'B'
        Return value
    EndIf

    If ( value == Nil )
        Return Function( value )->identity( value )
    EndIf

    If ValType( value ) == 'O' 
    Return If isArray( value );
        ? baseMatchesProperty( value[ 0 ], value[ 1 ] );
        : baseMatches( value )
    
    EndIf

    Return property( value )

Static Function identity( value )
    Return value

Method findIndex( array, predicate, fromIndex ) Class lodash
    Local length := If array == Nil ? 0 : Len( array )
    Local index  := 0

    If length < 1
        Return -1
    EndIf

    index := If fromIndex == Nil ? 1 : toInteger( fromIndex )

    If index < 0
        index := Max( length + index, 1 )
    Else
        index := Min( index, length )
    EndIf

    Return baseFindIndex( array, getIteratee( predicate, 3 ), index )

Method findLastIndex( array, predicate, fromIndex ) Class lodash
    Local length := If array == Nil ? 0 : Len( array )
    Local index  := 0

    If length < 1
        Return -1
    EndIf

    index := length

    If fromIndex != Nil
        index := toInteger( fromIndex )
        index := If fromIndex < 0 ;
                    ? Max( length + index, 0 );
                    : Min( index, length )
    EndIf

    Return baseFindIndex( array, getIteratee( predicate, 3 ), index, .T. )

Static Function baseFindIndex( array, predicate, fromIndex, fromRight )

    Local length := Len( array ) + 1
    Local index := If fromRight ? fromIndex + 1 : fromIndex - 1

    While If fromRight ? index -- > 1 : ++ index < length
        If Eval predicate( array[ index ], index, array )
            Return index
        EndIf
    EndDo

    Return -1

Method fromPairs( pairs ) Class lodash
    Local index := 0
    Local length := If pairs == Nil ? 0 : Len( pairs )
    Local result := JsonObject( ):New( )
    Local pair

    While index++ < length
        pair := pairs[ index ]
        result[ pair[ 1 ] ] := pair[ 2 ]
    EndDo

    Return result

Method indexOf( array, value, fromIndex ) Class lodash

    Local length := If array == Nil ? 0 : Len( array )
    Local index  := 0

    If length < 1
        Return -1
    EndIf

    index := If fromIndex == Nil ? 1 : toInteger( fromIndex )

    If index < 0
        index := Max( length + index, 1)
    EndIf

    Return baseIndexOf( array, value, index )

Static Function baseIndexOf( array, value, fromIndex )
    //   Return If value === value;
    //     ? strictIndexOf( array, value, fromIndex );
    //     : baseFindIndex( array, baseIsNaN, fromIndex )
      Return strictIndexOf( array, value, fromIndex )

Static Function strictIndexOf( array, value, fromIndex )
    Local index := fromIndex - 1
    Local length := Len( array )

    While index++ < length
        If array[ index ] == value
            Return index
        EndIf
    EndDo

    Return -1

Method initial( array ) Class lodash
    Local length := If array == Nil ? 0 : Len( array )

    Return If length > 0 ? baseSlice( array, 0, -1 ) : {}

Method last( array ) Class lodash
    Local length := If array == Nil ? 0 : Len( array )
    Return If length > 0 ? array[ length ] : Nil


Method lastIndexOf( array, value, fromIndex ) Class lodash
    Local length := If array == Nil ? 0 : Len( array )
    Local index := length

    If length < 1
        Return -1
   EndIf

    If fromIndex != Nil
        index := toInteger( fromIndex )
        index := If index < 0 ? Max( length + index, 0 ) : Min( index, length - 1 )
    EndIf

    Return strictLastIndexOf( array, value, index )
    // Return value === value
        // ? strictLastIndexOf( array, value, index )
        // : baseFindIndex( array, baseIsNaN, index, .T. )

Static Function strictLastIndexOf( array, value, fromIndex )
    Local index := fromIndex + 1

    While index -- > 0
        If array[ index ] == value
            Return index
        EndIf
    EndDo

    Return - 1

Method nth( array, n ) Class lodash

    Return If ( array != Nil .And. Len( array ) > 0) ? baseNth( array, toInteger( n ) ) : Nil

Static Function baseNth( array, n )
    Local length := Len( array )

    If length == Nil
        Return
    EndIf

    n += If n < 0 ? length + 1  : 0
    Return If isIndex( n, length ) ? array[ n ] : Nil

Static Function isIndex( value, length )
    Local type := ValType(value)

    length := If length == Nil ? MAX_SAFE_INTEGER : length

    Return !length == Nil .And.;
        ( type == 'N' .Or.;
        ( .F. .And. type != 'symbol' .And. reIsUint:test( value ) ) ) .And.;
        ( value > 0 .And. value % 1 == 0 .And. value < length )