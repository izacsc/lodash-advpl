
#include "protheus.ch"
#include "lodash.ch"

#DEFINE INFINITY  1/(0.1^30) //The closer I could getValue
#DEFINE CLONE_DEEP_FLAG 1
#DEFINE MAX_SAFE_INTEGER 9007199254740991
#DEFINE MAX_ARRAY_LENGTH 100000
#DEFINE LARGE_ARRAY_SIZE 200
#DEFINE MAX_ARRAY_INDEX MAX_ARRAY_LENGTH
#DEFINE HALF_MAX_ARRAY_LENGTH NoRound(MAX_ARRAY_LENGTH / 2, 0 )

//problems with 10 char size limit.
// Functions will be compiled as follows:
// b -> b   example: bIndexOf   -> bIndexOf
// strict -> s example: strictIndexOf -> sIndexOf
// bSortedIndex -> bSortInd
// arrayIncludes -> aIncludes

Static __self 

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
    Method difference( )
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
    Method pullAll( )
    Method pullAllBy( )
    Method pullAllWith( )
    Method pullAt( )
    Method remove( )
    Method reverse( )
    Method slice( )
    Method sortedIndex( )
    Method sortedIndexBy( )
    Method sortedIndexOf( )
    Method sortedLastIndex( )
    Method sortedLastIndexBy( )
    Method sortedLastIndexOf( )
    Method tail( )

    Method isArray()
    Method isArrayLike()
    Method isArrayLikeObject()
    Method isFunction()
    Method isLength()
    Method isObject()
    Method isObjectLike()

EndClass

Method new( ) Class lodash
    __self := self
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
        result[ resIndex++ ] := bSlice( array, index, ( index + size ) )
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

Method difference( array, values ) Class lodash
        //   ? bDifference( array, bFlatten( values, 1, { |value | __self:isArrayLikeObject(value) }, .T. ) );
        // Arrays in JS are Objects
    Return If ::isArrayLikeObject( array );
          ? bDifference( array, values );
          : {}

Method isArrayLikeObject( value ) Class lodash
    // Return ::isObjectLike( value ) .And. ::isArrayLike( value ) Arrays in JS are Objects
    Return ::isArrayLike( value )

Method isObjectLike( value ) Class lodash
    Return value != Nil .And. Valtype(value) == 'O'

Method isArrayLike( value ) Class lodash
    Return value != Nil .And. !::isFunction( value ) .And. ::isLength( Len( value ) ) 

Method isLength( value ) Class lodash
    Return ValType( value ) == 'N' .And.;
            value > -1 .And. value % 1 == 0 .And. value <= MAX_SAFE_INTEGER

Static Function bDifference( array, values, iteratee, comparator )
    Local index := 0
    Local includes := Function( array, value )->aIncludes( array, value )
    Local isCommon := .T.
    Local length := Len( array )
    Local result := { }
    Local valuesLength := Len( values )
    Local value
    Local computed
    Local valuesIndex

    If length == 0
        Return result
    EndIf

    If iteratee != Nil
        values := arrayMap( values, bUnary( iteratee ) )
    EndIf

    If comparator != Nil
        includes := Function( array, value, comparator )->aIncludesWith( array, value, comparator )
        isCommon := .F.
    elseIf .F. //Len( values ) >= LARGE_ARRAY_SIZE cache commented out
        includes := Function( cache, key )->cacheHas( cache, key )
        isCommon := .F.
        values := SetCache():New( values )
    EndIf

    While index++ < length
        Begin Sequence
            value := array[ index ]
            computed := If iteratee == Nil ? value : Eval iteratee( value )

            value := If ( comparator .Or. value != 0 ) ? value : 0

            If isCommon .And. computed == computed
                valuesIndex := valuesLength
                While valuesIndex > 0
                    If values[ valuesIndex ] == computed
                        Break
                    EndIf
                    valuesIndex --
                EndDo
                AAdd( result, value )
            ElseIf ! Eval includes( values, computed, comparator )
                AAdd( result, value )
            EndIf
        End Sequence
    EndDo

    Return result

Static Function aIncludes( array, value )
      Local length := If array == Nil ? 0 : Len( array )
      Return length > 0 .And. bIndexOf( array, value, 0 ) > -1

Static Function aIncludesWith( array, value, comparator )
    Local index := 0
    Local length := If array == Nil ? 0 : Len( array )

    While index ++ < length
        If Eval comparator( value, array[ index ] )
            Return .T.
        EndIf
    EndDo

    Return .F.

Method isFunction( value ) Class lodash
    Return ValType( value ) == 'B'

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

    Return bFlatten( array, depth )

Method flatten( array ) Class lodash

    Return bFlatten( array, 1 )

Method flattenDeep( array ) Class lodash

    Return bFlatten( array, 9999 )

Static Function bFlatten( array, depth, predicate, isStrict, result )
    Local index  := 0
    Local length := Len( array )
    Local value

    If predicate == Nil 
        predicate := Function( par )-> ValType( par ) == "A"
    EndIf
    
    If result == Nil 
        result := { }
    EndIf

    While index ++ < length
        value := array[ index ]
        If ( depth > 0 .And. Eval predicate(value) )
            If ( depth > 1 )
                bFlatten( value, depth - 1, predicate, isStrict, result )
            Else
                arrayPush( result, value )
            EndIf
        ElseIf !isStrict
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

    Return bSlice( array, If n < 0 ? 0 : n, length )

Method dropRight( array, n, guard ) Class lodash
    Local length := If array == Nil ? 0 : Len( array )

    If length == 0
        Return { }
    EndIf

    n := If ( guard != Nil .Or. n == Nil ) ? 1 : toInteger( n )
    n := length - n

    Return bSlice( array, 0, If n < 0 ? 0 : n )

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

Static Function bSlice( array, start, finish )
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

    Return bFill( array, value, start, finish )


Function bFill( array, value, start, finish )
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
        ? bWhile( array, getIteratee( predicate, 3 ), .T. );
        : { }

Method dropRightWhile( array, predicate ) Class lodash
    Return If array != Nil .And. Len( array ) > 0 ;
        ? bWhile( array, getIteratee( predicate, 3 ), .T., .T. );
        : { }

Static Function bWhile( array, predicate, isDrop, fromRight )
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
        Return bSlice( array, If fromRight ? 0 : index - 1, If fromRight ? index : length )
    Else
        Return bSlice( array, If fromRight ? index + 1  : 0, If fromRight ? length : index - 1 )
    EndIf

Static Function getIteratee( arg1, arg2 )
    Local result := Function( x, y )->iteratee( x, y )

    Return If arg1 != Nil ? Eval result( arg1, arg2 ) : result

 Static Function iteratee( fun )
      Return bIteratee( fun )
    //   Return bIteratee( If ValType( func ) == 'B' ? func : bClone( func, CLONE_DEEP_FLAG ) )

Static Function bClone( par1, flag )

    Return par1

Function bIteratee( value )

    If ValType( value ) == 'B'
        Return value
    EndIf

    If ( value == Nil )
        Return Function( value )->identity( value )
    EndIf

    If ValType( value ) == 'O'
    Return If isArray( value );
        ? bMatchesProperty( value[ 0 ], value[ 1 ] );
        : bMatches( value )

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

    Return bFindIndex( array, getIteratee( predicate, 3 ), index )

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

    Return bFindIndex( array, getIteratee( predicate, 3 ), index, .T. )

Static Function bFindIndex( array, predicate, fromIndex, fromRight )

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

    Return bIndexOf( array, value, index )

Static Function bIndexOf( array, value, fromIndex )
    //   Return If value === value;
    //     ? sIndexOf( array, value, fromIndex );
    //     : bFindIndex( array, bIsNaN, fromIndex )
      Return sIndexOf( array, value, fromIndex )

Static Function sIndexOf( array, value, fromIndex )
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

    Return If length > 0 ? bSlice( array, 0, -1 ) : {}

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

    Return sLastIndexOf( array, value, index )
    // Return value === value
        // ? sLastIndexOf( array, value, index )
        // : bFindIndex( array, bIsNaN, index, .T. )

Static Function sLastIndexOf( array, value, fromIndex )
    Local index := fromIndex + 1

    While index -- > 0
        If array[ index ] == value
            Return index
        EndIf
    EndDo

    Return - 1

Static Function bIndexOfWith( array, value, fromIndex, comparator )
    Local index := fromIndex - 1
    Local length := Len( array )

    While index ++ < length
        If Eval comparator( array[ index ], value )
            Return index
        EndIf
    EndDo

    Return -1

Method nth( array, n ) Class lodash

    Return If ( array != Nil .And. Len( array ) > 0) ? bNth( array, toInteger( n ) ) : Nil

Static Function bNth( array, n )
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

Method pullAll( array, values ) Class lodash
    Return If ( array != Nil .And. Len( array ) > 0 .And. values != Nil .And. Len( values ) > 0 );
            ? bPullAll( array, values );
            : array

Method pullAllBy( array, values, iteratee ) Class lodash
    Return If ( array != Nil .And. Len( array ) > 0 .And. values != Nil .And. Len( values ) > 0 );
            ? bPullAll( array, values, getIteratee( iteratee, 2 ) );
            : array

Method pullAllWith( array, values, comparator ) Class lodash
    Return If ( array != Nil .And. Len( array ) > 0 .And. values != Nil .And. Len( values ) > 0 );
            ? bPullAll( array, values, Nil, comparator );
            : array


Static Function bPullAll( array, values, iteratee, comparator )
    Local indexOf := Function( array, value, fromIndex )-> bIndexOf( array, value, fromIndex )
    Local index := 0
    Local length := Len( values )
    Local seen := array
    Local fromIndex
    Local value
    Local computed

    If array == values
        values := AClone( values )
    EndIf

    If comparator != Nil
        indexOf := Function( array, value, fromIndex, comparator )-> bIndexOfWith( array, value, fromIndex, comparator )
    EndIf

    If iteratee != Nil
        seen := arrayMap( array, bUnary( iteratee ) )
    EndIf

    While index++ < length
        fromIndex := 1
        value := values[ index ]
        computed := If iteratee != Nil ? Eval iteratee( value ) : value

        While ( fromIndex := Eval indexOf( seen, computed, fromIndex, comparator ) ) > -1
            If seen != array
                ADel( seen, fromIndex ) //splice.call( seen, fromIndex, 1 )
                ASize( seen, Len( seen ) - 1 )
            EndIf
            ADel( array, fromIndex ) // splice.call( array, fromIndex, 1 )
            ASize( array, Len( array ) - 1 )
        EndDo
    EndDo

    Return array

Static Function arrayMap( array, iteratee )
    Local index := 0
    Local length := If array == Nil ? 0 : Len( array )
    Local result := Array( length )

    While index++ < length
        result[ index ] := Eval iteratee( array[ index ], index, array )
    EndDo

    Return result

Static Function bUnary( block )

    Return Function( value ) -> Eval block( value )

Method pullAt ( array, indexes ) Class lodash
    Local length := If array == Nil ? 0 : Len( array )
    Local result := bAt( array, indexes )

    bPullAt( array , ASort( arrayMap( indexes, { | index | If( isIndex( index, length ),  + index, index) } ) ) )

    Return result

function bPullAt( array, indexes )
    Local length := If array  != Nil ? Len( indexes ) + 1 : 0
    Local lastIndex := length - 1
    Local index
    Local previous

    While length -- > 1
        index := indexes[ length ]

        If length == lastIndex .Or. index != previous
            previous := index
            If isIndex( index )
                ADel( array, index )
                ASize( array, Len( array ) - 1 )
            else
                bUnset( array, index )
            EndIf
        EndIf
    EndDo

    Return array

Static Function bAt( object, paths )
    Local index := 0
    Local length := Len( paths )
    Local result := Array( length )
    Local skip   := object == Nil

    While index++ < length
        result[ index ] := If skip ? Nil : getValue( object, paths[ index ] )
    EndDo

    Return result

//TODO
Static Function bUnset( object, path )
    path := castPath( path, object )
    object := parent( object, path )
    Return object == Nil //.Or. delete object[ toKey( last( path ) ) ]

Static Function getValue( object, path, defaultValue )
    Local result := If object == Nil ? Nil : bGet( object, path )
    Return If result == Nil ? defaultValue : result

Static Function bGet( object, path )
    Local index := 0
    Local length := If ValType(path) == "N" ? 1 : Len( path )
    Local result

    path := castPath( path, object )

    While object != Nil .And. index < length
        index ++
        result := object[ toKey( path[ index ] ) ]
    EndDo

    Return If ( index != Nil .And. index == length ) ? result : Nil

Static Function toKey( value )
    Return value
    // If typeof value == 'string' .Or. isSymbol( value )
    //     Return value
    // }
    // Local result := ( value + '' )
    // Return If ( result == '0' .And. ( 1 / value ) == -INFINITY ) ? '-0' : result

Static Function castPath( value, object )

    Return { value }

    // If isArray( value )
    //     Return value
    // EndIf

    // Return If isKey( value, object ) ? [ value ] : stringToPath( toString( value ) )

Static Function isArray(value)

    Return Valtype(value) == 'A'

Method remove( array, predicate ) Class lodash
    Local result := {}
    Local index := 0
    Local indexes := {}
    Local length := Len( array )
    Local value

    If !( array != Nil .And. Len( array ) > 0 )
        Return result
    EndIf

    predicate := getIteratee( predicate, 3 )

    While index ++ < length
        value := array[ index ]
        If Eval predicate( value, index, array )
            AAdd( result, value)
            AAdd( indexes, value)
        EndIf
    EndDo

    bPullAt( array, indexes )
    Return result

Method reverse( array ) Class lodash
    Local reversed := {}
    Local length := If array == Nil ? 0 : Len( array )
    Local index := length + 1

    If array != Nil
        While index -- > 1
            AAdd(reversed, array[ index ] )
        EndDo

        array := reversed
    EndIf

    Return array

Method slice( array, start, finish ) Class lodash
    Local length := If array == Nil ? 0 : Len( array )

    If length == Nil
        Return { }
    EndIf

    If finish .And. ValType(finish) != 'N' .And. isIterateeCall( array, start, finish )
        start := 1
        finish := length
    Else
        start := If start == Nil ? 1 : toInteger( start )
        finish := If finish == Nil ? length : toInteger( finish ) - 1
    EndIf

    Return bSlice( array, start - 1 , finish )

Method sortedIndex( array, value ) Class lodash
    Return bSortInd( array, value )

Method sortedLastIndex( array, value ) Class lodash
    Return bSortInd( array, value, .T. )

Static Function bSortInd( array, value, retHighest )
    Local low := 0
    Local high := If array == Nil ? low : Len( array )
    Local mid
    Local computed

    If Valtype( value ) == 'N' .And. high <= HALF_MAX_ARRAY_LENGTH
        While low < high
            mid := NoRound( ( low + high ) / 2 , 0)
            computed := array[ mid ]

            If computed != Nil .And. !isSymbol( computed ) .And. ;
               If  retHighest ?  computed <= value  : computed < value
                low := mid + 1
            else
                high := mid
            EndIf
        EndDo

        Return high
    EndIf

    Return bSortIndBy( array, value, { |value| identity(value) } , retHighest )

function bSortIndBy( array, value, iteratee, retHighest )

    Local low := 0
    Local high := If array == Nil ? 0 : Len( array )
    Local valIsNaN := value != value
    Local valIsNil := value == Nil
    Local valIsSymbol := isSymbol( value )
    Local mid
    Local computed
    Local othIsDefined
    Local othIsNil
    Local othIsReflexive
    Local othIsSymbol
    Local setLow

    value := Eval iteratee( value )

    While low < high
        mid := NoRound( ( low + high ) / 2 , 0)
        computed := Eval iteratee( array[ mid ] )
        othIsDefined := computed != Nil
        othIsNil := computed == Nil
        othIsReflexive := computed == computed
        othIsSymbol := isSymbol( computed )

        If valIsNaN
            setLow := retHighest .Or. othIsReflexive
        elseIf valIsNil
            setLow := othIsReflexive .And. ( retHighest .Or. othIsDefined )
        elseIf valIsNil
            setLow := othIsReflexive .And. othIsDefined .And. ( retHighest .Or. !othIsNil )
        elseIf valIsSymbol
            setLow := othIsReflexive .And. othIsDefined .And. !othIsNil .And. ( retHighest .Or. !othIsSymbol )
        elseIf othIsNil .Or. othIsSymbol
            setLow := .F.
        else
            setLow := If retHighest ? ( computed <= value ) : ( computed < value )
        EndIf
        If setLow
            low := mid + 1
        else
            high := mid
        EndIf
    EndDo

    Return Min( high, MAX_ARRAY_INDEX )

Static Function isSymbol( value )
    Return .F.

Method sortedIndexOf( array, value ) Class lodash
    Local length := If array == Nil ? 0 : Len( array )
    Local index

    If length > 0
        index := bSortInd( array, value )
        If index < length .And. eq( array[ index ], value )
            Return index
        EndIf
    EndIf

    Return -1

Method sortedLastIndexOf( array, value ) Class lodash
    Local length := If array == Nil ? 0 : Len( array )
    Local index

    If length > 0
        index := bSortInd( array, value, .T. ) - 1
        If eq( array[ index ], value )
            Return index
        EndIf
    EndIf
    Return -1

Method sortedIndexBy( array, value, iteratee ) Class lodash
    Return bSortIndBy( array, value, getIteratee( iteratee, 2 ) )

Method sortedLastIndexBy( array, value, iteratee ) Class lodash
    Return bSortIndBy( array, value, getIteratee( iteratee, 2 ), .T. )

Static Function eq(value, compare)
    Return value == compare

Method tail( array ) Class lodash
    Local length := If array == Nil ? 0 : Len( array )
    Return If length > 0 ? bSlice( array, 1, length ) : {}