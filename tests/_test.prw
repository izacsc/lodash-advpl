#include 'protheus.ch'
#include 'lodash.ch'
#include 'testsuite.ch'

import lodash

TestSuite _test Description 'Lodash AdvPL implementation' //Verbose
    Feature Chunk          Description 'Creates an array of elements split into groups the length of size.'// If array cant be split evenly, the final chunk will be the remaining elements.'
    Feature Compact        Description 'Creates an array with all falsey values removed ( .F., Nil, 0, "")'
    Feature Concat         Description 'Creates a new array concatenating array with arrays and/or values.'
    Feature Drop           Description 'Creates a slice of array with n elements dropped from the beginning.'
    Feature DropRight      Description 'Creates a slice of array with n elements dropped from the end.'
    Feature DropRightWhile Description 'Creates a slice of array excluding elements from the end.'// Elements are dropped until predicate returns falsey. The predicate is invoked with three arguments: (value, index, array).'
    Feature DropWhile      Description 'Creates a slice of array excluding elements from the beginning.'// Elements are dropped until predicate returns falsey. The predicate is invoked with three arguments: (value, index, array).'
    Feature Fill           Description 'Fills elements of array with value from start, but not including, end.'
    Feature FindIndex      Description 'Returns the index of the first element predicate returns truthy.'         
    Feature FindLastIndex  Description 'Like _.findIndex except that it iterates from right to left.'         
    Feature Flatten        Description 'Flattens array a single level deep.'
    Feature FlattenDeep    Description 'Recursively flattens array.'
    Feature FlattenDepth   Description 'Recursively flatten array up to depth times.'
    Feature FromPairs      Description 'Returns an object composed from key-value pairs.'
    Feature Head           Description 'Gets the first element of array.'
    Feature IndexOf        Description 'Gets the index of the first occurrence of value is found in array.'// If fromIndex is negative, its used as the offset from the end of array.'
    Feature Initial        Description 'Gets all but the last element of array.'
EndTestSuite

Feature Chunk TestSuite _test

    ::Expect( _:chunk({'a', 'b', 'c', 'd'}, 2) ):ToBe( {{'a', 'b'}, {'c', 'd'}} )
    ::Expect( _:chunk({'a', 'b', 'c', 'd'}, 3) ):ToBe( {{'a', 'b', 'c'}, {'d'}} )

Return

Feature Compact TestSuite _test

    ::Expect( _:compact( { 0, 1, .F., 2, "", 3, Nil } ) ):ToBe( { 1, 2, 3 } ) 

Return

Feature Concat TestSuite _test

    ::Expect( _:concat( { 1 }, 2, { 3 }, { { 4 } } ) ):ToBe( { 1, 2, 3, {4} } )

Return


Feature Drop TestSuite _test

    ::Expect( _:drop( { 1, 2, 3 }    ) ):ToBe( { 2, 3 } )
    ::Expect( _:drop( { 1, 2, 3 }, 2 ) ):ToBe( { 3 } )
    ::Expect( _:drop( { 1, 2, 3 }, 5 ) ):ToBe( { } )
    ::Expect( _:drop( { 1, 2, 3 }, 0 ) ):ToBe( { 1, 2, 3 } )

Return

Feature DropRight TestSuite _test

    ::Expect( _:dropRight( { 1, 2, 3 }    ) ):ToBe( { 1, 2 } )
    ::Expect( _:dropRight( { 1, 2, 3 }, 2 ) ):ToBe( { 1 } )
    ::Expect( _:dropRight( { 1, 2, 3 }, 5 ) ):ToBe( { } )
    ::Expect( _:dropRight( { 1, 2, 3 }, 0 ) ):ToBe( { 1, 2, 3 } )

Return

Feature DropRightWhile TestSuite _test

    ::Expect( _:dropRightWhile( { 1, 2, 3 }, {|| .F. } ) ):ToBe( { 1, 2, 3 }  )
    ::Expect( _:dropRightWhile( { 1, 2, 3 }, {|| .T. } ) ):ToBe( { }  )
    ::Expect( _:dropRightWhile( { 1, 2, 3 }, {|value| value > 1 } ) ):ToBe( { 1 }  )

Return

Feature DropWhile TestSuite _test

    ::Expect( _:dropWhile( { 1, 2, 3 }, {|| .F. } ) ):ToBe( { 1, 2, 3 }  )
    ::Expect( _:dropWhile( { 1, 2, 3 }, {|| .T. } ) ):ToBe( { }  )
    ::Expect( _:dropWhile( { 1, 2, 3 }, {|value| value < 3 } ) ):ToBe( { 3 }  )

Return

Feature Fill TestSuite _test
 
    ::Expect(_:fill( { 1, 2, 3 }, 'a')):ToBe( {'a', 'a', 'a'} )
    ::Expect(_:fill( Array( 3 ), 2 )):ToBe( {2, 2, 2} )
    ::Expect(_:fill( { 4, 6, 8, 10 }, '*', 2, 4)):ToBe( {4, '*', '*', 10} )
 
Return 


Feature FindIndex TestSuite _test
 
    ::Expect(_:findIndex( { 1, 2, 3 }, {|| .F. } )):ToBe( -1 )
    ::Expect(_:findIndex( { 1, 2, 3 }, {|value| value == 2 } )):ToBe( 2 )
    ::Expect(_:findIndex( { 1, 2, 3 }, {|value, index| index == 3 } )):ToBe( 3 )
    ::Expect(_:findIndex( { 1, 2, 3 }, {|value, index| index == 1 }, 2 )):ToBe( -1 )
 
Return 

Feature FindLastIndex TestSuite _test
 
    ::Expect(_:findLastIndex( { 1, 2, 3 }, {|| .F. } )):ToBe( -1 )
    ::Expect(_:findLastIndex( { 1, 2, 3 }, {|value| value == 2 } )):ToBe( 2 )
    ::Expect(_:findLastIndex( { 1, 2, 3 }, {|value, index| index == 3 } )):ToBe( 3 )
    ::Expect(_:findLastIndex( { 1, 2, 3 }, {|value, index| index == 3 }, 2 )):ToBe( -1 )
 
Return 

Feature Flatten TestSuite _test

    ::Expect( _:flatten( { 1, { 2, { 3, { 4 } }, 5 } } ) ):ToBe( { 1, 2, { 3, { 4 } }, 5 } )

Return

Feature FlattenDeep TestSuite _test

    ::Expect( _:flattenDeep( { 1, { 2, { 3, { 4 } }, 5 } } ) ):ToBe( { 1, 2, 3, 4, 5 } )

Return

Feature FlattenDepth TestSuite _test

    ::Expect( _:flattenDepth( {1, {2, {3, {4}}, 5}}, 1 ) ):ToBe( {1, 2, {3, {4}}, 5} )
    ::Expect( _:flattenDepth( {1, {2, {3, {4}}, 5}}, 2 ) ):ToBe( {1, 2, 3, {4}, 5} )
    
Return

Feature FromPairs TestSuite _test

    ::Expect( FwJsonSerialize(_:fromPairs( { {'a', 1} , {'b', 2} } )) ):ToBe('{"a":1,"b":2}' )
    
Return

Feature Head TestSuite _test

    ::Expect( _:head( { 1, 2, 3 }) ):ToBe( 1 )
    ::Expect( _:head( { } ) ):ToBe( Nil )
    
Return

Feature IndexOf TestSuite _test

    ::Expect(_:indexOf( { 1, 2, 1, 2 }, 2 )):ToBe( 2 )
    ::Expect(_:indexOf( { 1, 2, 1, 2 }, 2, 3 )):ToBe( 4 )
    
Return

Feature Initial TestSuite _test

    ::Expect(_:initial( { 1, 2, 3 } )):ToBe( { 1, 2 } )
    
Return

CompileTestSuite _test