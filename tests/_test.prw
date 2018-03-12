#include 'protheus.ch'
#include 'lodash.ch'
#include 'testsuite.ch'

import lodash

TestSuite _test Description 'Lodash AdvPL implementation' Verbose
    Feature Chunk        Description 'Creates an array of elements split into groups the length of size.'// If array cant be split evenly, the final chunk will be the remaining elements.'
    Feature Compact      Description 'Creates an array with all falsey values removed ( .F., Nil, 0, "")'
    Feature Concat       Description 'Creates a new array concatenating array with arrays and/or values.'
    Feature Flatten      Description 'Flattens array a single level deep.'
    Feature FlattenDeep  Description 'Recursively flattens array.'
    Feature FlattenDepth Description 'Recursively flatten array up to depth times.'
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

CompileTestSuite _test