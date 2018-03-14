#include 'protheus.ch'
#include 'lodash.ch'
#include 'testsuite.ch'

import lodash

TestSuite _test Description 'Lodash AdvPL implementation' Verbose
    Feature Chunk        Description 'Creates an array of elements split into groups the length of size.'// If array cant be split evenly, the final chunk will be the remaining elements.'
    Feature Compact      Description 'Creates an array with all falsey values removed ( .F., Nil, 0, "")'
    Feature Concat       Description 'Creates a new array concatenating array with arrays and/or values.'
    Feature Drop         Description 'Creates a slice of array with n elements dropped from the beginning.'
    Feature DropRight    Description 'Creates a slice of array with n elements dropped from the end.'
    Feature Fill         Description 'Fills elements of array with value from start up to, but not including, end.'
    Feature Flatten      Description 'Flattens array a single level deep.'
    Feature FlattenDeep  Description 'Recursively flattens array.'
    Feature FlattenDepth Description 'Recursively flatten array up to depth times.'
    Feature Head         Description 'Gets the first element of array.'
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

Feature Fill TestSuite _test
 
    ::Expect(_:fill( { 1, 2, 3 }, 'a')):ToBe( {'a', 'a', 'a'} )
    ::Expect(_:fill( Array( 3 ), 2 )):ToBe( {2, 2, 2} )
    ::Expect(_:fill( { 4, 6, 8, 10 }, '*', 2, 4)):ToBe( {4, '*', '*', 10} )
 
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

Feature Head TestSuite _test

    ::Expect( _:head( { 1, 2, 3 }) ):ToBe( 1 )
    ::Expect( _:head( { } ) ):ToBe( Nil )
    
Return

CompileTestSuite _test