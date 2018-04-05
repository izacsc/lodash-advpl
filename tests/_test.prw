#include 'protheus.ch'
#include 'lodash.ch'
#include 'testsuite.ch'

#xtranslate Expect <prm,...> to be <expr,...> => ::Expect(<prm>):ToBe(<expr>)

import lodash

TestSuite _test Description 'Lodash AdvPL implementation' Verbose
    Feature Chunk             Description 'Creates an array of elements split into groups the length of size.'// If array cant be split evenly, the final chunk will be the remaining elements.'
    Feature Compact           Description 'Creates an array with all falsey values removed ( .F., Nil, 0, "")'
    Feature Concat            Description 'Creates a new array concatenating array with arrays and/or values.'
    Feature Difference        Description 'Creates an array of array values not included in the other given arrays using SameValueZero for equality comparisons. The order and references of result values are determined by the first array.'
    Feature Drop              Description 'Creates a slice of array with n elements dropped from the beginning.'
    Feature DropRight         Description 'Creates a slice of array with n elements dropped from the end.'
    Feature DropRightWhile    Description 'Creates a slice of array excluding elements from the end.'// Elements are dropped until predicate returns falsey. The predicate is invoked with three arguments: (value, index, array).'
    Feature DropWhile         Description 'Creates a slice of array excluding elements from the beginning.'// Elements are dropped until predicate returns falsey. The predicate is invoked with three arguments: (value, index, array).'
    Feature Fill              Description 'Fills elements of array with value from start, but not including, end.'
    Feature FindIndex         Description 'Returns the index of the first element predicate returns truthy.'
    Feature FindLastIndex     Description 'Like _.findIndex except that it iterates from right to left.'
    Feature Flatten           Description 'Flattens array a single level deep.'
    Feature FlattenDeep       Description 'Recursively flattens array.'
    Feature FlattenDepth      Description 'Recursively flatten array up to depth times.'
    Feature FromPairs         Description 'Returns an object composed from key-value pairs.'
    Feature Head              Description 'Gets the first element of array.'
    Feature IndexOf           Description 'Gets the index of the first occurrence of value is found in array.'// If fromIndex is negative, its used as the offset from the end of array.'
    Feature Initial           Description 'Gets all but the last element of array.'
    Feature Last              Description 'Gets the last element of array.'
    Feature LastIndexOf       Description 'This method is like _.indexOf but iterates right to left.'
    Feature Nth               Description 'Gets the element at index n of array. If n negative, from the end'
    Feature Pull              Description 'Removes all given values from array '
    Feature PullAll           Description 'This method is like _.pull but accepts an array of values to remove.'
    Feature PullAllBy         Description 'This method is like _.pullAll but accepts an iteratee with argument value.'
    Feature PullAllWith       Description 'This method is like _.pullAll but accepts an comparator'
    Feature PullAt            Description 'Removes elements from array corresponding to indexes and returns an array of removed elements.'
    Feature Remove            Description 'Removes all elements from array that predicate returns truthy for and returns an array of the removed elements.'
    Feature Reverse           Description 'Reverses array so that the first element becomes the last, the second element becomes the second to last, and so on.'
    Feature Slice             Description 'Creates a slice of array from start up to, but not including, end.'
    Feature SortedIndex       Description 'Uses a binary search to determine the lowest index at which value should be inserted into array in order to maintain its sort order.'
    Feature SortedIndexBy     Description 'This method is like _.sortedIndex except that it accepts iteratee which is invoked for value and each element of array to compute their sort ranking. The iteratee is invoked with one argument: (value).'
    Feature SortedIndexOf     Description 'This method is like _.indexOf except that it performs a binary search on a sorted array.'
    Feature SortedLastIndex   Description 'This method is like _.sortedIndex except that it returns the highest index at which value should be inserted into array in order to maintain its sort order.'
    Feature SortedLastIndexBy Description 'This method is like _.sortedLastIndex except that it accepts iteratee which is invoked for value and each element of array to compute their sort ranking. The iteratee is invoked with one argument: (value).'
    Feature SortedLastIndexOf Description 'This method is like _.lastIndexOf except that it performs a binary search on a sorted array.'
EndTestSuite

Feature Chunk TestSuite _test

    Expect _:chunk( {'a', 'b', 'c', 'd'}, 2) to be { {'a', 'b'}, {'c', 'd'} }
    Expect _:chunk( {'a', 'b', 'c', 'd'}, 3) to be { {'a', 'b', 'c'}, {'d'} }

Return

Feature Compact TestSuite _test

    Expect _:compact( { 0, 1, .F., 2, "", 3, Nil } ) to be { 1, 2, 3 }

Return

Feature Concat TestSuite _test

    Expect _:concat( { 1 }, 2, { 3 }, { { 4 } } ) to be { 1, 2, 3, {4} }

Return

Feature Difference TestSuite _test

    Expect _:difference({2, 1}, {2, 3}) to be { 1 }

Return

Feature Drop TestSuite _test

    Expect _:drop( { 1, 2, 3 }    ) to be { 2, 3 }
    Expect _:drop( { 1, 2, 3 }, 2 ) to be { 3 }
    Expect _:drop( { 1, 2, 3 }, 5 ) to be { }
    Expect _:drop( { 1, 2, 3 }, 0 ) to be { 1, 2, 3 }

Return

Feature DropRight TestSuite _test

    Expect _:dropRight( { 1, 2, 3 }    ) to be { 1, 2 }
    Expect _:dropRight( { 1, 2, 3 }, 2 ) to be { 1 }
    Expect _:dropRight( { 1, 2, 3 }, 5 ) to be { }
    Expect _:dropRight( { 1, 2, 3 }, 0 ) to be { 1, 2, 3 }

Return

Feature DropRightWhile TestSuite _test

    Expect _:dropRightWhile( { 1, 2, 3 }, {|| .F. } ) to be { 1, 2, 3 }
    Expect _:dropRightWhile( { 1, 2, 3 }, {|| .T. } ) to be { }
    Expect _:dropRightWhile( { 1, 2, 3 }, {|value| value > 1 } ) to be { 1 }

Return

Feature DropWhile TestSuite _test

    Expect _:dropWhile( { 1, 2, 3 }, {|| .F. } ) to be { 1, 2, 3 }
    Expect _:dropWhile( { 1, 2, 3 }, {|| .T. } ) to be { }
    Expect _:dropWhile( { 1, 2, 3 }, {|value| value < 3 } ) to be { 3 }

Return

Feature Fill TestSuite _test

    Expect _:fill( { 1, 2, 3 }, 'a') to be {'a', 'a', 'a'}
    Expect _:fill( Array( 3 ), 2 ) to be {2, 2, 2}
    Expect _:fill( { 4, 6, 8, 10 }, '*', 2, 4) to be {4, '*', '*', 10}

Return


Feature FindIndex TestSuite _test

    Expect _:findIndex( { 1, 2, 3 }, {|| .F. } ) to be -1
    Expect _:findIndex( { 1, 2, 3 }, {|value| value == 2 } ) to be 2
    Expect _:findIndex( { 1, 2, 3 }, {|value, index| index == 3 } ) to be 3
    Expect _:findIndex( { 1, 2, 3 }, {|value, index| index == 1 }, 2 ) to be -1

Return

Feature FindLastIndex TestSuite _test

    Expect _:findLastIndex( { 1, 2, 3 }, {|| .F. } ) to be -1
    Expect _:findLastIndex( { 1, 2, 3 }, {|value| value == 2 } ) to be 2
    Expect _:findLastIndex( { 1, 2, 3 }, {|value, index| index == 3 } ) to be 3
    Expect _:findLastIndex( { 1, 2, 3 }, {|value, index| index == 3 }, 2 ) to be -1

Return

Feature Flatten TestSuite _test

    Expect _:flatten( { 1, { 2, { 3, { 4 } }, 5 } } ) to be { 1, 2, { 3, { 4 } }, 5 }

Return

Feature FlattenDeep TestSuite _test

    Expect _:flattenDeep( { 1, { 2, { 3, { 4 } }, 5 } } ) to be { 1, 2, 3, 4, 5 }

Return

Feature FlattenDepth TestSuite _test

    Expect _:flattenDepth( {1, {2, {3, {4}}, 5}}, 1 ) to be {1, 2, {3, {4}}, 5}
    Expect _:flattenDepth( {1, {2, {3, {4}}, 5}}, 2 ) to be {1, 2, 3, {4}, 5}

Return

Feature FromPairs TestSuite _test

    Expect FwJsonSerialize(_:fromPairs( { {'a', 1} , {'b', 2} } )) To be'{"a":1,"b":2}'

Return

Feature Head TestSuite _test

    Expect _:head( { 1, 2, 3 }) to be 1
    Expect _:head( { } ) to be Nil

Return

Feature IndexOf TestSuite _test

    Expect _:indexOf( { 1, 2, 1, 2 }, 2 ) to be 2
    Expect _:indexOf( { 1, 2, 1, 2 }, 2, 3 ) to be 4

Return

Feature Initial TestSuite _test

    Expect _:initial( { 1, 2, 3 } ) to be { 1, 2 }

Return

Feature Last TestSuite _test

    Expect _:last( { 1, 2, 3 } ) to be 3

Return

Feature LastIndexOf TestSuite _test

    Expect _:lastIndexOf( { 1, 2, 1, 2 }, 2 ) to be 4
    Expect _:lastIndexOf( { 1, 2, 1, 2 }, 2, 2 ) to be 2

Return

Feature nth TestSuite _test

    Expect _:nth( { 'a', 'b' ,'c', 'd'}, 2 ) To be'b'
    Expect _:nth( { 'a', 'b' ,'c', 'd'}, -2 ) to be 'c'

Return

Feature pull TestSuite _test
    Local array := { 'a', 'b' ,'c', 'd', 'a', 'b' ,'c'}

    Expect _:pull( array , 'a', 'b' ) to be { 'c', 'd', 'c'}
    Expect array to be { 'c', 'd', 'c'}

Return

Feature pullAll TestSuite _test
    Local array := { 'a', 'b' ,'c', 'd', 'a', 'b' ,'c'}

    Expect _:pullAll( array , {'a', 'b'} ) to be { 'c', 'd', 'c'}
    Expect array to be { 'c', 'd', 'c'}

Return

Feature pullAllBy TestSuite _test

    // Expect _:pullAllBy( { 'a', 'b' ,'c', 'd', 'a', 'b' ,'c'} , {'a', 'b'}, { | value | value } ) to be { 'c', 'd', 'c'}
    Expect _:pullAllBy( { 'a', 'b' ,'c', 'd', 'a', 'b' ,'c'} , {'a', 'b'}, { | value | Asc(value) } ) to be { 'c', 'd', 'c'}
    // Expect _:pullAllBy( { 'a', 'b' ,'c', 'd', 'a', 'b' ,'c'} , {'a', 'b'}, { |value| If( value < 'd', value, '') } ) to be { 'c', 'c'}

Return

Feature pullAllWith TestSuite _test

    Expect _:pullAllWith( { 'a', 'b' ,'c', 'd', 'a', 'b' ,'c'} , {'a', 'b'}, { | | .F. } ) to be { 'a', 'b' ,'c', 'd', 'a', 'b' ,'c' }
    Expect _:pullAllWith( { 'a', 'b' ,'c', 'd', 'a', 'b' ,'c'} , {'a', 'b'}, { | | .T. } ) to be { }
    Expect _:pullAllWith( { 'a', 'b' ,'c', 'd', 'a', 'b' ,'c'} , {'a'}, { |value, comp| value != comp } ) to be { 'a', 'a'}

Return

Feature pullAt TestSuite _test
    Local array := { 'a', 'b' ,'c', 'd'}

    Expect _:pullAt( array, {1, 3} ) to be {'a', 'c'}
    Expect array to be {'b', 'd'}

Return

Feature Remove TestSuite _test
    Local array := { 1, 2, 3, 4}
    Local evens := { }

    evens := _:remove( array, { |n| n%2==0 })

    Expect array to be { 1, 3 }
    Expect evens to be { 2, 4 }

Return

Feature Reverse TestSuite _test
    Local array := { 1, 2, 3}

    Expect _:reverse( array) To be { 3, 2, 1 }
    Expect array to be { 3, 2, 1 }

Return

Feature Slice TestSuite _test
    Local array := { 1, 2, 3}

    Expect _:slice( array, 2) to be { 2, 3 }
    Expect _:slice( array, 1, 2) to be { 1 }
    Expect _:slice( array, 1, 4) to be { 1, 2, 3 }

Return

Feature SortedIndex TestSuite _test
    Local array := { 30, 50 }

    Expect _:sortedIndex( array, 40) to be 2

Return

Feature SortedIndexBy TestSuite _test
    Local array := { {50, 30}, {40, 50} }

    Expect _:sortedIndexBy( array, {30, 40}, { |value| value[2] }) to be 2

Return

Feature SortedIndexOf TestSuite _test
    Local array := { 4, 5, 5, 5, 6 }

    Expect _:sortedIndexOf( array, 5) to be 2

Return

Feature SortedLastIndex TestSuite _test
    Local array := { 4, 5, 5, 5, 6 }

    Expect _:sortedLastIndex( array, 5) to be 5

Return

Feature SortedLastIndexBy TestSuite _test
    Local array := { {50, 30}, {40, 50}, {40, 50}, {40, 60} }

    Expect _:sortedLastIndexBy( array, {40, 50}, { |value| value[2] }) to be 4

Return

Feature SortedLastIndexOf TestSuite _test
    Local array := { 4, 5, 5, 5, 6 }

    Expect _:sortedLastIndexOf( array, 5) to be 4

Return


CompileTestSuite _test