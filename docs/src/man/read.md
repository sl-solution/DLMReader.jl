# Introduction

The `DLMReader` package has the `filereader` and `filerwriter` functions for reading and writing delimited files, respectively. They have a few keyword arguments which we explain each of them in this section.

# `filereader`

User must pass the file name as the first argument of `filereader` to read a delimited file into `Julia`, i.e. `filereader(path; ...)`. The `filereader` function assumes that the observations are separated by comma and the first line of the input file contains the columns' name, additionally, it assumes that the strings are not quoted. It scans the first 20 lines of the input file to detect `Int64` and `Float64` columns, and use `String` as the default type when the detection goes wrong. Thus, for a well-formatted csv file, user does not need to use any keyword argument. However, the `filereader` function provides some keyword arguments to give user extra flexibility for reading complex delimited files.

## Keyword arguments

* [types](#types)
* [delimiter](#delimiter)
* [dlmstr](#dlmstr)
* [ignorerepeated](#ignorerepeated)
* [header](#header)
* [linebreak](#linebreak)
* [guessingrows](#guessingrows)
* [fixed](#fixed)
* [quotechar](#quotechar)
* [escapechar](#escapechar)
* [dtformat](#dtformat)
* [int_base](#intbase)
* [informat](#informat)
* [skipto](#skipto)
* [limit](#limit)
* [multiple_obs](#multipleobs)
* [line_informat](#lineinformat)
* [buffsize](#buffsize)
* [lsize](#lsize)
* [string_trim](#stringtrim)
* [makeunique](#makeunique)
* [emptycolname](#emptycolname)
* [warn](#warn)
* [eolwarn](#eolwarn)
* [threads](#threads)

### `types` 

User can pass the types of each column of the input file by using the `types` keyword argument. User may pass a vector of types which includes every type of each column, or may pass a dictionary of types for few selected columns.

**Default:** auto detection

```julia
julia> ds = filereader(IOBuffer("""x1,x2
       12,13
       1,2
       """), types = [Int, Float64])
2×2 Dataset
 Row │ x1        x2       
     │ identity  identity 
     │ Int64?    Float64? 
─────┼────────────────────
   1 │       12      13.0
   2 │        1       2.0
```

### `delimiter`

To change the default delimiter, user must pass the `delimiter` keyword argument. The `delimiter` keyword argument only accept `Char` as delimiter. Additionally, user can pass a vector of `Char` which causes `filereader` to use them as alternative delimiters.

**Default:** comma

```julia
julia> ds = filereader(IOBuffer("""x1;x2
       12;13
       1;2
       """), delimiter = ';')
2×2 Dataset
 Row │ x1        x2       
     │ identity  identity 
     │ Int64?    Int64?   
─────┼────────────────────
   1 │       12        13
   2 │        1         2
```

### `dlmstr`

This keyword argument is used to pass a string as the delimiter for values.

**Default:** `nothing`

```julia
julia> ds = filereader(IOBuffer("""x1|:|x2
       12|:|13
       1|:|2
       """), dlmstr = "|:|" )
2×2 Dataset
 Row │ x1        x2       
     │ identity  identity 
     │ Int64?    Int64?   
─────┼────────────────────
   1 │       12        13
   2 │        1         2
```

### `ignorerepeated`

If it is set as `true`, repeated delimiters will be ignored.

**Default:** `false`

```julia
julia> ds = filereader(IOBuffer("""x1,,x2
       12,13
       1,,,,2
       """), ignorerepeated = true)
2×2 Dataset
 Row │ x1        x2       
     │ identity  identity 
     │ Int64?    Int64?   
─────┼────────────────────
   1 │       12        13
   2 │        1         2
```

### `header`

User must set this as `false` if the first line of the input file is not the column header. Additionally, user can pass a vector of columns' name, which will be used as the columns' header.

**Default:** `true`

```julia
julia> ds = filereader(IOBuffer("""
       12,13
       1,2
       """), header = [:Col1, :Col2])
2×2 Dataset
 Row │ Col1      Col2     
     │ identity  identity 
     │ Int64?    Int64?   
─────┼────────────────────
   1 │       12        13
   2 │        1         2
```

### `linebreak`

The `filereader` function use the value of this option as line separator. It can accept a `Char` or a vector of `Char` where the length of the vector is less than or equal two. For some rare cases user may need to pass this option to assist `filereader` in reading the input file.

**Default:** auto detection

```julia
julia> ds = filereader(IOBuffer("""
       x1,x2;12,13;1,2;"""), linebreak = ';')
2×2 Dataset
 Row │ x1        x2       
     │ identity  identity 
     │ Int64?    Int64?   
─────┼────────────────────
   1 │       12        13
   2 │        1         2
```

### `guessingrows`

This provide the number of lines to be used for types detection. The `filereader` function will detect the types of the column more accurately if user increase this value, however, it costs more computation time.

**Default:** 20

### `fixed`

This option is used for reading fixed width files. User must pass a dictionary of columns' locations (as a range) for reading a fixed width file.

**Default:** `nothing`

```julia
julia> ds = filereader(IOBuffer("""
       12
       34
       """), fixed = Dict(1=>1:1, 2=>2:2), header = false)
2×2 Dataset
 Row │ x1        x2       
     │ identity  identity 
     │ Int64?    Int64?   
─────┼────────────────────
   1 │        1         2
   2 │        3         4
```

### `quotechar`

If the texts are quoted in the input file, user must pass the quoted character via this keyword argument.

**Default:** `nothing` (the `filereader` assumes the texts are not quoted)

```julia
julia> ds = filereader(IOBuffer("""x1,x2
       "12",13
       "1",2
       """), quotechar = '"')
2×2 Dataset
 Row │ x1        x2       
     │ identity  identity 
     │ Int64?    Int64?   
─────┼────────────────────
   1 │       12        13
   2 │        1         2
```

### `escapechar`

Declaring the escape char for quoted text.

**Default:** `nothing` (the `filereader` assumes the text are not quoted)

### `dtformat`

User must pass the date format of DataTime columns if they are different from the standard format. The `dtformat` keyword argument accept a dictionary of values.

**Default:** `nothing`

```julia
julia> ds = filereader(IOBuffer("""date1,date2
       2020-1-1,2020/1/1
       2020-2-2,2020/2/2
       """), dtformat = Dict(1 => dateformat"y-m-d", 2 => dateformat"y/m/d"))
2×2 Dataset
 Row │ date1       date2      
     │ identity    identity   
     │ Date?       Date?      
─────┼────────────────────────
   1 │ 2020-01-01  2020-01-01
   2 │ 2020-02-02  2020-02-02
```

### `int_base`

The `filereader` can read integers with different bases. User can pass this information for a specific column. The value of bases must be passed as a dictionary, e.g. `Dict(1 => (Int32, 2))`.

**Default:** `nothing`

```julia
julia> ds = filereader(IOBuffer("""x1,x2
       100,100
       101,101
       """), int_base = Dict(1 => (Int, 2)))
2×2 Dataset
 Row │ x1        x2       
     │ identity  identity 
     │ Int64?    Int64?   
─────┼────────────────────
   1 │        4       100
   2 │        5       101
```

### `informat`

User can pass a dictionary which provides the information of the `informat` of selected columns.

**Default:** `nothing`

```julia
julia> ds = filereader(IOBuffer("""x1,x2
       NA,12
       1,NA
       """), informat = Dict(1:2 .=> NA!))
2×2 Dataset
 Row │ x1        x2       
     │ identity  identity 
     │ Int64?    Int64?   
─────┼────────────────────
   1 │  missing        12
   2 │        1   missing 
```

### `skipto`

It can be used to start reading a file from specific location.

**Default:** 1

```julia
julia> ds = filereader(IOBuffer("""COL1, COL2
       1,2
       2,3
       3,4
       """), skipto = 3, header = false)
2×2 Dataset
 Row │ x1        x2       
     │ identity  identity 
     │ Int64?    Int64?   
─────┼────────────────────
   1 │        2         3
   2 │        3         4
```

### `limit`

It can be used to limit the number of observations read from the input file.

**Default:** `Inf`

```julia
julia> ds = filereader(IOBuffer("""COL1, COL2
       1,2
       2,3
       3,4
       """), limit = 1)
1×2 Dataset
 Row │ COL1      COL2     
     │ identity  identity 
     │ Int64?    Int64?   
─────┼────────────────────
   1 │        1         2
```

### `multiple_obs`

If it is set as `true`, the `filereader` function assumes there are more than one observation in each line of the input file.

**Default:** `false`

```julia
julia> ds = filereader(IOBuffer("""1,2,3,4,5
       6,7
       """), multiple_obs = true, header = [:x1, :x2], types = [Int, Int])
4×2 Dataset
 Row │ x1        x2       
     │ identity  identity 
     │ Int64?    Int64?   
─────┼────────────────────
   1 │        1         2
   2 │        3         4
   3 │        5         6
   4 │        7   missing 
```

### `line_informat`

User can provide line informat via this keyword argument.

**Default:** `nothing`

### `buffsize`

User can provide any positive number for the buffer size. Each thread allocates the amount of `buffsize` and reads the values from the input file into it.

**Default:** 2^16

### `lsize`

It indicated the line buffer size for reading the input files. For very wide table use may need to manually adjust this option. Its value must be less than `buffsize`.

**Default:** 2^15

### `string_trim`

Setting this as `true` will trim the trailing blanks of strings before storing them into the output data set.

> `DLMReader` shipped with the `STRIP!` informat which can be used to strip (removing leading and trailing blanks) any raw text before parsing.

**Default:** `false`

```julia
julia> ds = filereader(IOBuffer("""x1,x2
       "    fdh  ",df
       "dkhfd    ",dfadf
       """), quotechar = '"', string_trim = true)
2×2 Dataset
 Row │ x1        x2       
     │ identity  identity 
     │ String?   String?  
─────┼────────────────────
   1 │     fdh   df
   2 │ dkhfd     dfadf

julia> ds[:, :x1]
2-element Vector{Union{Missing, String}}:
 "    fdh"
 "dkhfd"

julia> ds = filereader(IOBuffer("""x1,x2,x3
       1,   2020-2-2   , " ff  "
       2,2020-1-1,"343"
       """), types = Dict(2 => Date), quotechar = '"', informat = Dict(2:3 .=> STRIP!))
2×3 Dataset
 Row │ x1        x2          x3       
     │ identity  identity    identity 
     │ Int64?    Date?       String?  
─────┼────────────────────────────────
   1 │        1  2020-02-02  ff
   2 │        2  2020-01-01  343

julia> ds[:, :x3]
2-element Vector{Union{Missing, String}}:
 "ff"
 "343"
```

### `makeunique`

If there are non-unique columns' names, this can resolve it by adding a suffix to the names.

**Default:** `false`

```julia
julia> ds = filereader(IOBuffer("""x,x
       1,2
       """), makeunique = true)
1×2 Dataset
 Row │ x         x_1      
     │ identity  identity 
     │ Int64?    Int64?   
─────┼────────────────────
   1 │        1         2
```

### `emptycolname`

If it is set to `true`, it generates a column name for columns with empty name.

**Default:** `false`

```julia
julia> ds = filereader(IOBuffer("""x,
       1,2
       """), emptycolname = true)
1×2 Dataset
 Row │ x         NONAME1  
     │ identity  identity 
     │ Int64?    Int64?   
─────┼────────────────────
   1 │        1         2
```

### `warn`

Control the maximum number of warning and information. Setting it to 0 will suppress warnings and information during reading the input file.

**Default:** 20

### `eolwarn`

Control if the end-of-line character warning should be shown.

**Default:** `true`

### `threads`

For large files, the `filereader` function exploits all threads. However, this can be switch off by setting this argument as `false`.

**Default:** `true`


# `filewriter`

The `filewriter` function writes a data set into disk. Behind the scene, it uses `byrow` function from [InMemoryDatasets.jl](https://github.com/sl-solution/InMemoryDatasets.jl) to efficiently convert each row of the input data set into `UInt8`. The first argument of the `filewriter` must be a filename and the second argument must be the passed data set.

## Keyword arguments

* delimiter
* quotechar
* mapformats
* append
* header
* buffsize
* lsize
* threads
### `delimiter`

By default, `filewriter` uses comma as delimiter, however, user can pass any other `Char` (or a vector of `Char`) via the `delimiter` keyword argument.

**Default:** comma

### `quotechar`

The `filewriter` function does not quote values, if this is desired, the quote `Char` must be passed via the `quotechar` keyword argument.

**Default:** `nothing`

### `mapformats`

Setting this as `true` causes `filewriter` to write the formatted values.

**Default:** `false`

### `append`

Setting this as `true` causes `filewriter` to append values to the end of the input file.

**Default:** `false`

### `header`

The `filewriter` function writes column names in the output file, however, this can be prevented by setting `header = false`.

**Default:** `true`

### `buffsize`

This option controls the buffer size. 

**Default:** 2^24

### `lsize`

This option controls the line size for writing values.

**Default:** auto detection

### `threads`

If set `true`, `filewriter` exploits all threads.

**Default:** `true`
