# Lodash-advpl
This is an atempt to implement the [ Lodash library ](https://lodash.com/), a well known utility library, in [AdvPL](http://tdn.totvs.com/display/tec/AdvPL+-+Sobre). 

The goal is to implement most functionalities described in their [docs](https://lodash.com/docs/4.17.5) as close as possible to the original (names, arguments, expected behavior). I will be using [lodash.js](https://github.com/lodash/lodash/blob/4.17.5/lodash.js) as a reference. I will be using [advpl-testsuite](https://github.com/nginformatica/advpl-testsuite) to write the tests.

# Installation
- Download include/lodash.ch and move it to your includes directory
- Download and compile all the files under source/ directory

# Using

```
    #include 'lodash.ch'

    import lodash as "_"

    User Function TestLodash()

    aRet := _:chunk({'a', 'b', 'c', 'd'}, 2)
    //aRet := {{'a', 'b'}, {'c', 'd'}}
    
    Return

```

# Features

- Chunk       
- Compact     
- Concat      
- Flatten     
- FlattenDeep 
- FlattenDepth