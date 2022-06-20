# Tutorial - Advanced

This section provides an advanced introduction for using the `DLMReader` package to read a delimited file into `Julia`. To start using the package enter the following expression in a `Julia` session,

```julia
julia> using DLMReader
```

> If you have not installed the package yet, you will be prompt to do it so.

## Reading the yellow taxi file

The `yellow_subset.csv` file is a small subset of taxi movements in New York city in 2010. 

```julia
julia> taxi_file = joinpath(dirname(pathof(DLMReader)),
                                "..", "docs", "src", "assets", "yellow_subset.csv"
                            );
```

In this tutorial we use the `filereader` function to read this file into `Julia`. At the first attempt we directly use the `filereader` function to read this data into `Julia`, however, since the file can be huge we only limit our parsing to few observations (examining the structure of the input file).

```julia
julia> taxi = filereader(taxi_file, limit = 4)
┌ Info: There might be less observations in the input file at line 2 (observation 1) than the number of columns in the output dataset.
└  
4×18 Dataset
 Row │ vendor_id  pickup_datetime      dropoff_datetime     passenger_count  trip_distance  pickup_longitude  pickup_latitude  rate_code  store_and_fwd_flag  dropoff_longitude   ⋯
     │ identity   identity             identity             identity         identity       identity          identity         identity   identity            identity            ⋯
     │ String?    String?              String?              Int64?           Float64?       Float64?          Float64?         Int64?     Int64?              Float64?            ⋯
─────┼─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1 │ \r         missing              missing                      missing      missing        missing          missing         missing             missing       missing        ⋯
   2 │ CMT        2010-03-15 15:29:46  2010-03-15 15:34:09                1            0.8          -74.0047          40.7343          1                   0           -73.9936
   3 │ CMT        2010-03-15 11:44:31  2010-03-15 11:48:48                1            0.3          -73.9584          40.7729          1                   0           -73.9636
   4 │ CMT        2010-03-15 11:07:30  2010-03-15 11:21:39                2            2.2          -73.9574          40.78            1                   0           -73.9838
                                                                                                                                                                  8 columns omitted
```
Note the first row of the output data set is strange, and the output data set is truncated, thus, we cannot see the detected type of columns. We first fix the problem with the first observation. Since the first cell is filled with "`\r`" we should suspect that the end-of-line character for this file might be detected incorrectly. The `filereader` package allows user to pass the end-of-line character via the `linebreak` keyword argument. In general, "`\n`" is the end-of-line character for most delimited file, however, in some operating systems "`\r`", "`\r\n`", etc might be used for this purpose. Using trial and error (there are other ways rather than trial and error) we noticed that the end-of-line for this file is "`\r\n`", and there is an extra "`\n`" in the first line of the file which has puzzled the automatic detection. Thus, we rerun the code and pass the `linebreak` keyword argument to fix the first issue of this file,

```julia
julia> taxi = filereader(taxi_file, limit = 4, linebreak = ['\r','\n'])
4×18 Dataset
 Row │ vendor_id  pickup_datetime      dropoff_datetime     passenger_count  trip_distance  pickup_longitude  pickup_latitude  rate_code  store_and_fwd_flag  dropoff_longitude   ⋯
     │ identity   identity             identity             identity         identity       identity          identity         identity   identity            identity            ⋯
     │ String?    String?              String?              Int64?           Float64?       Float64?          Float64?         Int64?     Int64?              Float64?            ⋯
─────┼─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1 │ CMT        2010-03-15 15:29:46  2010-03-15 15:34:09                1            0.8          -74.0047          40.7343          1                   0           -73.9936   ⋯
   2 │ CMT        2010-03-15 11:44:31  2010-03-15 11:48:48                1            0.3          -73.9584          40.7729          1                   0           -73.9636
   3 │ CMT        2010-03-15 11:07:30  2010-03-15 11:21:39                2            2.2          -73.9574          40.78            1                   0           -73.9838
   4 │ CMT        2010-03-15 14:57:33  2010-03-15 15:10:26                1            4.1          -74.016           40.7151          1                   0           -73.9904
                                                                                                                                                                  8 columns omitted
```

## Passing data types

In general, providing the data type of columns improve the efficiency of reading delimited file. To provide such information, we look at the detected types in `taxi` and pass the right data types. To examine the detected types of a data set, we should use the `content` and `describe` functions from the `InMemoryDatasets` package.

```julia
julia> using InMemoryDatasets

julia> content(taxi)
4×18 Dataset
   Created: 2022-05-13T15:00:55.868
  Modified: 2022-05-13T15:00:55.868
      Info: 
-----------------------------------
Columns information 
┌─────┬────────────────────┬──────────┬─────────┐
│ Row │ col                │ format   │ eltype  │
├─────┼────────────────────┼──────────┼─────────┤
│   1 │ vendor_id          │ identity │ String  │
│   2 │ pickup_datetime    │ identity │ String  │
│   3 │ dropoff_datetime   │ identity │ String  │
│   4 │ passenger_count    │ identity │ Int64   │
│   5 │ trip_distance      │ identity │ Float64 │
│   6 │ pickup_longitude   │ identity │ Float64 │
│   7 │ pickup_latitude    │ identity │ Float64 │
│   8 │ rate_code          │ identity │ Int64   │
│   9 │ store_and_fwd_flag │ identity │ Int64   │
│  10 │ dropoff_longitude  │ identity │ Float64 │
│  11 │ dropoff_latitude   │ identity │ Float64 │
│  12 │ payment_type       │ identity │ String  │
│  13 │ fare_amount        │ identity │ Float64 │
│  14 │ surcharge          │ identity │ Int64   │
│  15 │ mta_tax            │ identity │ Float64 │
│  16 │ tip_amount         │ identity │ Int64   │
│  17 │ tolls_amount       │ identity │ Int64   │
│  18 │ total_amount \n    │ identity │ Float64 │
└─────┴────────────────────┴──────────┴─────────┘
```

Note that the type detection for some columns is incorrect, e.g. `pickup_datetime`, `dropoff_datetime`, `surcharge`, etc. In the next step we pass the incorrectly detected columns via the `types` and `dtformat` keyword arguments,

```julia
julia> taxi = filereader(taxi_file, limit = 4, linebreak = ['\r','\n'], 
                            types = Dict([14,16,17] .=> Float64), 
                            dtformat = Dict(2:3 .=> dateformat"y-m-d H:M:S"))
4×18 Dataset
 Row │ vendor_id  pickup_datetime      dropoff_datetime     passenger_count  trip_distance  pickup_longitude  pickup_latitude  rate_code  store_and_fwd_flag  dropoff_longitude   ⋯
     │ identity   identity             identity             identity         identity       identity          identity         identity   identity            identity            ⋯
     │ String?    DateTime?            DateTime?            Int64?           Float64?       Float64?          Float64?         Int64?     Int64?              Float64?            ⋯
─────┼─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1 │ CMT        2010-03-15T15:29:46  2010-03-15T15:34:09                1            0.8          -74.0047          40.7343          1                   0           -73.9936   ⋯
   2 │ CMT        2010-03-15T11:44:31  2010-03-15T11:48:48                1            0.3          -73.9584          40.7729          1                   0           -73.9636
   3 │ CMT        2010-03-15T11:07:30  2010-03-15T11:21:39                2            2.2          -73.9574          40.78            1                   0           -73.9838
   4 │ CMT        2010-03-15T14:57:33  2010-03-15T15:10:26                1            4.1          -74.016           40.7151          1                   0           -73.9904
                                                                                                                                                                  8 columns omitted
```

Passing the date format of the DataTime columns is sufficient for parsing their values. Thus, in the previous code, we only passed the `dtformat` keyword argument for the second and third column.

In the next step, we store the data types of the columns in an array and pass it to the `filereader` function to process the whole file. Note that for date values in non-standard form we need to pass the `dtformat` keyword argument.

```julia
julia> _tmp = content(taxi, output = true)[2];

julia> alltypes = identity.(_tmp[:, :eltype]);

julia> taxi = filereader(taxi_file, linebreak = ['\r','\n'], 
                            types = alltypes, 
                            dtformat = Dict(2:3 .=> dateformat"y-m-d H:M:S"))
┌ Info: There might be more observations in the input file at line 11 (observation 10) than the number of columns in the output dataset.
└  CMT,2010-03-15 15:35:04,2010-03-15 16:00:07,1,5.2000000000000002,-73.993639000000002,40.720208999999997,1,,,-73.946438000000001,40.778773999999999,Cas,16.100000000000001,0,0.5,0,0,16.600000000000001.
┌ Warning: There are problems with parsing the input file at line 11 (observation 10) : 
│ Column 13 : fare_amount::Float64 : Read from buffer ("Cas")
│  the values are set as missing.
│ MORE DETAILS: 
│ vendor_id::String = CMT, pickup_datetime::DateTime = 2010-03-15T15:35:04, dropoff_datetime::DateTime = 2010-03-15T16:00:07, passenger_count::Int64 = 1, trip_distance::Float64 = 5.2, pickup_longitude::Float64 = -73.993639, pickup_latitude::Float64 = 40.720209, rate_code::Int64 = 1, store_and_fwd_flag::Int64 = missing, dropoff_longitude::Float64 = missing, dropoff_latitude::Float64 = -73.946438, payment_type::String = 40.778773999999999, fare_amount::Float64 = missing, surcharge::Float64 = 16.1, mta_tax::Float64 = 0.0, tip_amount::Float64 = 0.5, tolls_amount::Float64 = 0.0, total_amount::Float64 = 0.0
│ CMT,2010-03-15 15:35:04,2010-03-15 16:00:07,1,5.2000000000000002,-73.993639000000002,40.720208999999997,1,,,-73.946438000000001,40.778773999999999,Cas,16.100000000000001,0,0.5,0,0,16.600000000000001
└ @ DLMReader ...
20×18 Dataset
 Row │ vendor_id  pickup_datetime      dropoff_datetime     passenger_count  trip_distance  pickup_longitude  pickup_latitude  rate_code  store_and_fwd_flag  dropoff_longitude   ⋯
     │ identity   identity             identity             identity         identity       identity          identity         identity   identity            identity            ⋯
     │ String?    DateTime?            DateTime?            Int64?           Float64?       Float64?          Float64?         Int64?     Int64?              Float64?            ⋯
─────┼─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1 │ CMT        2010-03-15T15:29:46  2010-03-15T15:34:09                1            0.8          -74.0047          40.7343          1                   0           -73.9936   ⋯
   2 │ CMT        2010-03-15T11:44:31  2010-03-15T11:48:48                1            0.3          -73.9584          40.7729          1                   0           -73.9636
  ⋮  │     ⋮               ⋮                    ⋮                  ⋮               ⋮               ⋮                 ⋮             ⋮              ⋮                   ⋮           ⋱
  19 │ CMT        2010-03-15T14:31:04  2010-03-15T14:40:03                1            0.9          -73.9977          40.7412          1                   0           -73.9834
  20 │ CMT        2010-03-15T12:20:25  2010-03-15T12:26:38                1            0.9          -73.9983          40.7454          1                   0           -73.9954
                                                                                                                                                      8 columns and 16 rows omitted
```

## Examining the warnings

The last code produces some `info` and `warning` messages which alert the existence of some issues in reading process. When the `filereader` reads all the columns but fails to reach the end of the line, it produce some `info` to alert user. The `Info` message contains the information about location of issue and the raw text of the input line. 

Additionally, when the `filereader` cannot parse a particular values, it provides some `warning` messages to help users to investigate the problem. The message contains the details and the location of the problem.

In the above example, we can see that the 11th line of the input file has an issue. An investigation reveals that the problem is due to extra "`,`" in place of missing values, i.e. near "`1,,,-73.946438000000001`". This causes a shift in values, thus, the `filereader` function fails to parse the value of the 13th column. This problem is a data entry problem and we cannot fix it unless there is a systematic pattern for such problems. Fortunately, for this specific file the patter is fixed for all lines so we can exploit some features of the `DLMReader` package to fix the issue.

To fix the aforementioned problem, we define a new informat which reads a line from the input file and modify its contents in-place and pass this to the `filereader` function via  `line_informat`.

The logic that we are going to follow is "replacing the second `,` in `,,,` with space". Note that this may not make sense for any other files, thus, user must search for a particular  pattern in each case.

The `line_informat` keyword argument accepts a registered informat which is a function with one positional argument, a special type of mutable string.

> Note that the `line_informat` informat is called on each line of the input file, thus, use low level programming to avoid any allocation.

> Note that the last column name has an extra '\n'. To fix it, user can call `rename!(taxi, "total_amount \n" => "total_amount")`.

```julia
julia> function LINFMT!(x)
            replace!(x, ",,," => ", ,")
        end
julia> register_informat(LINFMT!)
    [ Info: Informat LINFMT! has been registered

julia> taxi = filereader(taxi_file, linebreak = ['\r','\n'], 
                            types = alltypes,
                            dtformat = Dict(2:3 .=> dateformat"y-m-d H:M:S"), 
                            line_informat = LINFMT!)
20×18 Dataset
 Row │ vendor_id  pickup_datetime      dropoff_datetime     passenger_count  trip_distance  pickup_longitude  pickup_latitude  rate_code  store_and_fwd_flag  dropoff_longitude   ⋯
     │ identity   identity             identity             identity         identity       identity          identity         identity   identity            identity            ⋯
     │ String?    DateTime?            DateTime?            Int64?           Float64?       Float64?          Float64?         Int64?     Int64?              Float64?            ⋯
─────┼─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1 │ CMT        2010-03-15T15:29:46  2010-03-15T15:34:09                1            0.8          -74.0047          40.7343          1                   0           -73.9936   ⋯
   2 │ CMT        2010-03-15T11:44:31  2010-03-15T11:48:48                1            0.3          -73.9584          40.7729          1                   0           -73.9636
  ⋮  │     ⋮               ⋮                    ⋮                  ⋮               ⋮               ⋮                 ⋮             ⋮              ⋮                   ⋮           ⋱
  20 │ CMT        2010-03-15T12:20:25  2010-03-15T12:26:38                1            0.9          -73.9983          40.7454          1                   0           -73.9954
                                                                                                                                                      8 columns and 17 rows omitted

```

## Dealing with String columns

Columns with `String` type cause performance issue for large data sets. If those columns contains only a few unique values then we must convert the corresponding columns to `PooledArray`. However, if this is not possible we must read those columns into `Julia` as fixed-length string types. 

> User can read the columns as fixed-length string and convert them into `PooledArray` later.

To convert the columns with `String` type to `PooledArray`, user should use the `modify!` function from the `InMemoryDatasets` package,

```julia
julia> using PooledArrays

julia> modify!(taxi, names(taxi, AbstractString) => PooledArray);

julia> describe(taxi)
18×7 Dataset
 Row │ column              n         nmissing  mean      std        minimum              maximum             
     │ identity            identity  identity  identity  identity   identity             identity            
     │ String?             Any       Any       Any       Any        Any                  Any                 
─────┼───────────────────────────────────────────────────────────────────────────────────────────────────────
   1 │ vendor_id           20        0         nothing   nothing    CMT                  CMT
   2 │ pickup_datetime     20        0         nothing   nothing    2010-03-15T11:07:30  2010-03-15T15:35:04
   3 │ dropoff_datetime    20        0         nothing   nothing    2010-03-15T11:21:39  2010-03-15T16:00:07
   4 │ passenger_count     20        0         1.1       0.307794   1                    2
   5 │ trip_distance       20        0         2.11      2.15917    0.1                  9.2
   6 │ pickup_longitude    20        0         -73.9863  0.0186699  -74.016              -73.9574
   7 │ pickup_latitude     20        0         40.7486   0.022824   40.7151              40.7972
   8 │ rate_code           20        0         1.0       0.0        1                    1
   9 │ store_and_fwd_flag  19        1         0.0       0.0        0                    0
  10 │ dropoff_longitude   20        0         -73.9782  0.0154007  -74.0016             -73.9464
  11 │ dropoff_latitude    20        0         40.7603   0.0178604  40.7196              40.7838
  12 │ payment_type        20        0         nothing   nothing    Cas                  Cre
  13 │ fare_amount         20        0         8.44      5.62741    2.5                  27.7
  14 │ surcharge           20        0         0.0       0.0        0.0                  0.0
  15 │ mta_tax             20        0         0.5       0.0        0.5                  0.5
  16 │ tip_amount          20        0         0.368     0.830127   0.0                  3.0
  17 │ tolls_amount        20        0         0.0       0.0        0.0                  0.0
  18 │ total_amount        20        0         9.308     5.74365    3.0                  28.2

```