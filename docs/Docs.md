# Docs

## “Array” Methods
### _:chunk(array, [size=1])

Creates an array of elements split into groups the length of size. If array can"t be split evenly, the final chunk will be the remaining elements.

#### Arguments
array (Array): The array to process.  
[size=1] (number): The length of each chunk

#### Returns
(Array): Returns the new array of chunks.

#### Example
```xBase
_:chunk({ "a", "b", "c", "d" }, 2)
// => { { "a", "b" }, { "c", "d" } }
 
_:chunk({ "a", "b", "c", "d" }, 3)
// => { { "a", "b", "c" }, { "d" } }
```

### _:compact(array)

Creates an array with all falsey values removed. The values false, null, 0, "", undefined, and NaN are falsey.

#### Arguments
array (Array): The array to compact.

#### Returns
(Array): Returns the new array of filtered values.

#### Example
```xBase
_:compact({  0, 1, .F., 2, "", 3, Nil  })
// => { 1, 2, 3 }
```

### _:concat(array, [values])

Creates a new array concatenating array with any additional arrays and/or values.

#### Arguments
array (Array): The array to concatenate.  
[values] (...*): The values to concatenate.

#### Returns
(Array): Returns the new concatenated array.

#### Example
```xBase
array := { 1 }
other := _:concat(array, 2, { 3 }, { { 4 } })

// other
// => { 1, 2, 3, { 4 } }
 
//array
// => { 1 }
```

### _:drop(array, [n=1])

Creates a slice of array with n elements dropped from the beginning.

#### Arguments
array (Array): The array to query.  
[n=1] (number): The number of elements to drop.

#### Returns
(Array): Returns the slice of array.

#### Example
```xBase
_:drop({ 1, 2, 3 })
// => { 2, 3 }
 
_:drop({ 1, 2, 3 }, 2)
// => { 3 }
 
_:drop({ 1, 2, 3 }, 5)
// => {  }
 
_:drop({ 1, 2, 3 }, 0)
// => { 1, 2, 3 }
```

### _:dropRight(array, [n=1])

Creates a slice of array with n elements dropped from the end.

#### Arguments
array (Array): The array to query.  
[n=1] (number): The number of elements to drop.

#### Returns
(Array): Returns the slice of array.

#### Example
```xBase
_:dropRight({ 1, 2, 3 })
// => { 1, 2 }
 
_:dropRight({ 1, 2, 3 }, 2)
// => { 1 }
 
_:dropRight({ 1, 2, 3 }, 5)
// => {  }
 
_:dropRight({ 1, 2, 3 }, 0)
// => { 1, 2, 3 }
```

### _:fill(array, value, [start=0], [end=array.length])

Fills elements of array with value from start up to, but not including, end.

Note: This method mutates array.

#### Arguments
array (Array): The array to fill.  
value (*): The value to fill array with.  
[start=0] (number): The start position.  
[end=array.length] (number): The end position.  

#### Returns
(Array): Returns array.

#### Example
```xBase
array := { 1, 2, 3 }
 
_:fill(array, "a")
//array
// => { "a", "a", "a" }
 
_:fill(Array(3), 2)
// => { 2, 2, 2 }
 
_:fill({ 4, 6, 8, 10 }, "*", 2, 4)
// => { 4, "*", "*", 10 }
```


### _:flatten(array)

Flattens array a single level deep.

#### Arguments
array (Array): The array to flatten.

#### Returns
(Array): Returns the new flattened array.

#### Example
```xBase
_:flatten({ 1, { 2, { 3, { 4 } }, 5 } })
// => { 1, 2, { 3, { 4 } }, 5 }
```

### _:flattenDeep(array)

Recursively flattens array.

#### Arguments
array (Array): The array to flatten.

#### Returns
(Array): Returns the new flattened array.

#### Example
```xBase
_:flattenDeep({ 1, { 2, { 3, { 4 } }, 5 } })
// => { 1, 2, 3, 4, 5 }
```

### _:flattenDepth(array, [depth=1])

Recursively flatten array up to depth times.

#### Arguments
array (Array): The array to flatten.  
[depth=1] (number): The maximum recursion depth.

#### Returns
(Array): Returns the new flattened array.

#### Example
```xBase
array := { 1, { 2, { 3, { 4 } }, 5 } }
 
_:flattenDepth(array, 1)
// => { 1, 2, { 3, { 4 } }, 5 }
 
_:flattenDepth(array, 2)
// => { 1, 2, 3, { 4 }, 5 }
```

### _:head(array)

Gets the first element of array.

#### Aliases
_:first

#### Arguments
array (Array): The array to query.

#### Returns
(*): Returns the first element of array.

#### Example
```xBase
_:head({ 1, 2, 3 })
// => 1
 
_:head({  })
// => Nil
```