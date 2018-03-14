
#include "protheus.ch"
#include "lodash.ch"

User Function _(id)
    Local nActivation := -1

    If id == Nil
        id := "_"
    EndIf

    While ProcName( ++ nActivation ) != ""
        cProcname := ProcName( nActivation )
    EndDo

    If Type(id) == "U"
        oLodash := lodash():New()

        _SetNamedPrvt( id, oLodash, cProcname )
    EndIf

Return oLodash:VERSION

Class lodash From LongNameClass

    DATA VERSION as char

    Method New() //Constructor
    Method chunk()
    Method compact()
    Method concatenate()
    // Method difference()
    // Method differenceBy()
    // Method differenceWith()
    // Method drop()
    // Method dropRight()
    // Method dropRightWhile()
    // Method dropWhile()
    // Method fill()
    // Method findIndex()
    // Method findLastIndex()
    Method first()
    Method flatten()
    Method flattenDeep()
    Method flattenDepth()
    Method head()


EndClass

Method New() Class lodash

    self:VERSION := "0.1"

Return self

Method chunk( array, size ) Class lodash
    Local result := {{}} ,;
          length := Len( array ),;
          index  := 0

    While index++ < length
        AAdd( ATail( result ), array[ index ] )

        If index % size == 0 .And. length > index
             AAdd( result, {} )
        EndIf
    EndDo

    Return result

Method compact( array ) Class lodash
    Local result := {}
    Local length := Len( array )
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

    arrayPush(result, flatten)

    Return result

Static Function arrayPush(array, values)
    Local index  := 0
    Local length := Len( values )

    While index ++ < length
        AAdd( array, values[ index ] )
    EndDo

    Return

Method flattenDepth( array, depth ) Class lodash

    Return baseFlatten(array, depth )

Method flatten( array ) Class lodash

    Return baseFlatten(array, 1)

Method flattenDeep( array ) Class lodash

    Return baseFlatten(array, 9999)

Static Function baseFlatten( array, depth, result)
    Local index  := 0
    Local length := Len( array )
    Local value

    If Empty(result)
        result := {}
    EndIf

    while index ++ < length
        value := array[index]
        If (depth > 0 .And. ValType(value) == "A")
            If (depth > 1)
                baseFlatten(value, depth - 1, result)
            else
                arrayPush(result, value)
            EndIf
        else
            AAdd( result, value )
        EndIf
    EndDo

    return result

Method first(array) Class lodash
    Return ::head(array)

Method head(array) Class lodash
    Return If (ValType(array) == "A" .And. Len( array ) > 0) ? array[1] : Nil