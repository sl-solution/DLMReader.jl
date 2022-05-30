# DLMReader
[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://sl-solution.github.io/DLMReader.jl/stable) [![](https://img.shields.io/badge/docs-dev-blue.svg)](https://sl-solution.github.io/DLMReader.jl/dev)

An efficient multi-threaded package for reading(writing) delimited files. It is designed as a file parser for `InMemoryDatasets.jl`.

> DLMReader writes and reads AbstractDatasets types, i.e. other types must be converted to/from AbstractDatasets.

It works very well for huge files (long or/and wide).

> `DLMReader` does not guess `delimiter` and if it is different from `,`, it must be passed via the `delimiter` keyword argument. By default, the `DLMReader` package assumes Strings are not quoted, if they are quoted, user must pass the quote character via the `quotechar` keyword argument.


## Documentation

* [Stable](https://sl-solution.github.io/DLMReader.jl/stable)
* [Dev](https://sl-solution.github.io/DLMReader.jl/dev)

## Features

`DLMReader.jl` has some interesting features which distinguish it from other packages for reading delimited files. In what follows, we list a few of them;

* **`Informats`**: The `DLMReader` package uses  `informats`  to call a class of functions on the raw text before parsing its value(s). This provides a flexible and extendable approach to parse values with special patterns. For instance, using the predefined informat `COMMA!` allows users to read a numeric column with "thousands separator" and/or the dollar sign, e.g. using this informat, the raw text like "`$12,000.00`" will be parsed as "`12000.00`". Moreover,  `informat`s support function composing, e.g. `COMMA! ∘ ACC!`  parses "`$(12,000.00)`" as "`-12000.00`", i.e. `ACC!` is first applied and then `COMMA!` is applied on its result.
  
  * Additionally, `informats` can be applied on whole line before processing individual values.

* **Fixed-width text**: If users pass the columns locations via the `fixed` keyword argument, the package reads those columns as fixed-width format. For instance, passing `fixed = Dict(1=>1:1, 2=>2:2)` helps to parse "`10`" as "`[1,0]`".  Mixing fixed-width format and delimited format is also allowed.

* **Multiple observations per line**: The package allows reading more than one observation per line. This can be done by passing the `multiple_obs = true` keyword argument. The multithreading feature (plus some other features) will be switched off if this option is set.

* **Fast file writer**: The `DLMReader` package exploits the `byrow` function from [`InMemoryDatasets.jl`](https://github.com/sl-solution/InMemoryDatasets.jl) to write delimited files into disk. This enables `DLMReader` to convert values to string using multiple threads.

* **Alternative delimiters**: User can pass a vector of delimiters to the function. In this case, `filereader` treats any of the passed delimiters as field delimiter.

* **Multiple Date formats**: User can pass different date formats for different columns.

* **Different integer base**: The `DLMReader` package allows users pass the integer base if it is different from 10 when parsing integers.

* **String as delimiter**: User can pass a string as delimiter of values. This must be passed via the `dlmstr` keyword argument.

* **Informative warnings/info**: If something goes wrong during the reading phase, the package will provide detailed warnings/info to help user investigate the issue.

## Benchmarks

See [here](https://discourse.julialang.org/t/ann-dlmreader-the-most-versatile-julia-package-for-reading-delimited-files-yet/81899) for some benchmarks.

## Examples

The following files will be used during the examples, it is assumed that the files are located in the current working directory

ex1.csv
```text
a, b, c
1,2,NA
2,3,2001-1-2
2,4,2020-4-2
1,2,2000-12-1
```

ex2.csv
```text
a::b::C::DD
12::1345::15::15
12::13::15::15
12::13::15::15
12::13::15::15
12::13::15::15
12::13::15::15
12::13::15::15
12::13::::15
12::13::15::15
12::13::15::157
```

ex3.csv
```text
1
2
4;5
6
8;9
1
4;
```

ex4.csv
```text
1   3,5
2   4,6
33  5,7
```

ex5.csv
```text
x1;x2:x3,x4
1;2;123;3
2;4,4,5
```

ex6.csv
```text
id1 $2,000,000 3
id2 $34,000 4
id3 $200,000 1
```


And the code to read them into Julia

```julia
julia> using DLMReader
julia> filereader("ex1.csv", dtformat = Dict(3 => dateformat"y-m-d"))
julia> filereader("ex2.csv", dlmstr = "::")
julia> filereader("ex3.csv", types = [Int, Int, Int], header = false, linebreak = ';', delimiter = '\n')
julia> filereader("ex4.csv", fixed = Dict(1 => 1:4), header = false)
julia> filereader("ex5.csv", delimiter = [';', ':', ','])
julia> filereader("ex6.csv", delimiter = ' ', informat = Dict(2=>COMMA!), header = [:ID, :price, :quarter])
```

`COMMA!` is a built-in informat which removes the comma from numbers. If number contains dollar or sterling signs, it also removes them. The trimmed text is sent to the parser for converting to a number.

## Extra examples

```julia
julia> filereader(IOBuffer("1,2,3,4,5\n6,7,8\n10\n"),
                  header = [:x1, :x2],
                  types = [Int, Int],
                  multiple_obs = true)
5×2 Dataset
 Row │ x1        x2       
     │ identity  identity
     │ Int64?    Int64?   
─────┼────────────────────
   1 │        1         2
   2 │        3         4
   3 │        5         6
   4 │        7         8
   5 │       10   missing

julia> filereader(IOBuffer(""" name1 name2 avg1 avg2  y
              0   A   D   75   5    32
              1   A   D   75   5    32
              2   D   L   32   7    12
              3   F   C   99   8    42
              4   F   C   99   8    42
              5   C   A   43   6    39
              6   C   A   43   6    39
              7   L   R   53   3    11
              8   R   F   21   2    25
              9   R   F   21   2    25
              """), delimiter = ' ', ignorerepeated = true, emptycolname = true)
10×6 Dataset
 Row │ NONAME1   name1     name2     avg1      avg2      y        
     │ identity  identity  identity  identity  identity  identity
     │ Int64?    String?   String?   Int64?    Int64?    Int64?   
─────┼────────────────────────────────────────────────────────────
   1 │        0  A         D               75         5        32
   2 │        1  A         D               75         5        32
   3 │        2  D         L               32         7        12
   4 │        3  F         C               99         8        42
   5 │        4  F         C               99         8        42
   6 │        5  C         A               43         6        39
   7 │        6  C         A               43         6        39
   8 │        7  L         R               53         3        11
   9 │        8  R         F               21         2        25
  10 │        9  R         F               21         2        25
```
