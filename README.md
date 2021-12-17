# DLMReader

An efficient multi-threaded package for reading delimited files. It designed as a file parser for `InMemoryDatasets.jl`.

The package supports:

* alternative delimiter: e.g. reading `2,3;4,5` where `,` or `;` is the column separator
* string as delimiter: e.g. having `::` as column separator
* fixed width column: e.g. reading `2  3,4,5` where the first column is located at characters `1:3`, but the rest of columns are separated by `,`
* using different eol character: e.g. having `;` as eol and `\n` as the column separator
* using `informat`s: e.g. to be able to read lines like `$2,000;200;1` efficiently
* parsing columns as `Date` with given set of `DateFormat`s
* allow different `base` for parsing integers
* ...

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
using DLMReader
filereader("ex1.csv", dtformat = Dict(3 => dateformat"y-m-d"))
filereader("ex2.csv", dlmstr = "::")
filereader("ex3.csv", types = [Int, Int, Int], header = false, linebreak = ';', delimiter = '\n')
filereader("ex4.csv", fixed = Dict(1 => 1:4), header = false)
filereader("ex5.csv", delimiter = [';', ':', ','])
filereader("ex6.csv", delimiter = ' ', informat = Dict(2=>COMMA!), header = [:ID, :price, :quarter])
```

`COMMA!` is a built-in informat which removes the comma from numbers. If number contains dollar or sterling signs, it also removes them. The trimed text is sent to the parser for converting to a number.
