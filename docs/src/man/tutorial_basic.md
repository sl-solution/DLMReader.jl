# Tutorial - Basics

This section provides a tutorial for using the `DLMReader` package to read a delimited file into `Julia`. To start using the package enter the following expression in a `Julia` session

```julia
julia> using DLMReader
```

> If you have not installed the package yet, you will be prompt to do it so.

## Reading a csv file

The `tutorial_1.csv` file is available as part of the `DLMReader` package and the following expression creates a file reference to its location,

```julia
julia> fname = joinpath(dirname(pathof(DLMReader)),
                                "..", "docs", "src", "assets", "tutorial_1.csv"
                            );
```

The `filereader` function is an exported function for reading delimited files into `Julia`. By default, the `filereader` function uses comma to separate values in a file, however, the delimiter of `tutorial_file` is "`;`", so we pass this to the `filereader` function via the `delimiter` keyword argument.

```julia
julia> tutorial = filereader(fname, delimiter = ';')
3×4 Dataset
 Row │ x1        x2        x3|value  date       
     │ identity  identity  identity  identity   
     │ Int64?    String?   String?   String?    
─────┼──────────────────────────────────────────
   1 │        1  2,30      ab|2      2022-01-02
   2 │       10  -2,10     cd|3      2022-19-20
   3 │        4  1,34      dd|       2022-02-13
```

> Note that you should pass the file delimiter as `Char` to the `delimiter` keyword arguments. 

By default, the `filereader` function assumes that the first line of the file contains the column names, and it uses this to create column name for the output data set as shown in this example.

The output data set is a `Dataset` which is a special type for working with tabular data in `Julia`, see the [InMemoryDatasets.jl](https://github.com/sl-solution/InMemoryDatasets.jl) package for more information about working with tabular data in `Julia`.

From the output data set, we observe that the third column is actually a mix of two columns which are separated by `|`. This means that our delimited file is using alternative delimiters for separating values, so we should provide this information to the `filereader` function to help it correctly parse the input file. To use alternative delimiters we must pass a vector of delimiters to the `delimiter` keyword argument:

```julia
julia> tutorial = filereader(fname, delimiter = [';','|'])
3×5 Dataset
 Row │ x1        x2        x3        value     date       
     │ identity  identity  identity  identity  identity   
     │ Int64?    String?   String?   Int64?    String?    
─────┼────────────────────────────────────────────────────
   1 │        1  2,30      ab               2  2022-01-02
   2 │       10  -2,10     cd               3  2022-19-20
   3 │        4  1,34      dd         missing  2022-02-13
```

Note that by passing `[';', '|']` as delimiter, `filereader` correctly reads the `:x3` and `:value` columns into `Julia`.

## Dealing with Date and Time

The last column of the `tutorial_1.csv` file is a `Date` type, however, it is read as `String`. This is the default behaviour of `filereader`. User may force the type of a specific column by passing a vector or a `Dict` as the `types` keyword argument. If user is willing to specify every column's type, s/he should use a vector of types with the same length of the number of columns as the value of the `types` keyword argument, e.g. in the above example `[Int, String, String, Int, Date]` would be fine, however, since we are only interested to correct the type of the fifth column, we can pass it in `Dict` to the `types` keyword argument:

```julia
julia> tutorial = filereader(fname, delimiter = [';','|'], types = Dict(5 => Date))
┌ Warning: There are problems with parsing file at line 3 (observation 2) : 
│ Column 5 : date : Read from buffer ("2022-19-20")
│ the values are set as missing.
│ MORE DETAILS: 
│ x1::Int64 = 10, x2::String = -2,10, x3::String = cd, value::Int64 = 3, date::Date = missing
│ 10;-2,10;cd|3;2022-19-20
└ @ DLMReader ...
3×5 Dataset
 Row │ x1        x2        x3        value     date       
     │ identity  identity  identity  identity  identity   
     │ Int64?    String?   String?   Int64?    Date?      
─────┼────────────────────────────────────────────────────
   1 │        1  2,30      ab               2  2022-01-02
   2 │       10  -2,10     cd               3  missing    
   3 │        4  1,34      dd         missing  2022-02-13
```

By default, the `filereader` function assumes that the column with the `Date` type are in the standard format, i.e. `yyyy-mm-dd`, and it will try to parse each value using the date format, however, if a value is not parsable `filereader` parses it as `missing`, and it shows a warning message to indicate that the parser fails to parse the specific value and provide some information about this. If the value should be treated as `missing`, user may ignore the warning message. For instance, in the above example, the issue is due to the fact that `19` is not a correct value for a month, so it must be a data entry error.

If values for date(time) are not represented as `yyyy-mm-dd` format, user can use the `dtformat` keyword argument to provide the right date format of a specific column. User must pass a dictionary of date format for specifying the date format:

```julia
julia> tutorial = filereader(fname, delimiter = [';','|'], types = Dict(5 => Date), dtformat = Dict(5 => dateformat"y-m-d"));
```

## Using "informats"

The `DLMReader` package provides special functionality, called `informat`, to allow modification of the raw text before the parsing phase, i.e. `informat` is a special function which will be called on the raw text of a value before sending the text to the parser. The `DLMReader` package is shipped with some predefined informats, however, power users can define their own informats for special purposes.

We are going to use one of the predefined informats to parse the second column of `tutorial_1.csv` file. The second column of `tutorial_1.csv` file uses "`,`" as decimal point in numbers, this is a common practice in some european countries. To parse this column correctly, we can call the `COMMAX!` informat before parsing its values. The `COMMAX!` informat converts "`,`" to decimal points, and removes "`.`" (thousand separator) and "`€`" (U+20AC) from the numbers.

```julia
julia> tutorial = filereader(fname, delimiter = [';','|'], types = Dict(5 => Date), informat = Dict(2 => COMMAX!))
┌ Warning: There are problems with parsing file at line 3 (observation 2) :  
│ Column 5 : date : Read from buffer ("2022-19-20")
│ the values are set as missing.
│ MORE DETAILS: 
│ x1::Int64 = 10, x2::Float64 = -2.1, x3::String = cd, value::Int64 = 3, date::Date = missing
│ 10;-2.10;cd|3;2022-19-20
└ @ DLMReader ...
3×5 Dataset
 Row │ x1        x2        x3        value     date       
     │ identity  identity  identity  identity  identity   
     │ Int64?    Float64?  String?   Int64?    Date?      
─────┼────────────────────────────────────────────────────
   1 │        1      2.3   ab               2  2022-01-02
   2 │       10     -2.1   cd               3  missing    
   3 │        4      1.34  dd         missing  2022-02-13
```

## Writing a data set to disk

The `DLMReader` package provides the `filewriter` function for writing a data set as a flat file into disk. The function uses comma as default delimiter, however, the user can pass any other delimiter via the `delimiter` keyword argument.

```julia
julia> filewriter("t_file.csv", tutorial)
```