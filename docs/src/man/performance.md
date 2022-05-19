# Performance tips

This section contains some performance tips which can improve the experience of working with DLMReader. These tips are specially important when reading a huge file.

## Avoid using String type for large data sets

Using `String` causes garbage collection and it must be avoided when possible. 

## Use `informat` to improve performance

In many cases using `informat` can improve the performance of reading huge files. For instances, if there are two columns in the input file which both are `Date` but with different `DataFormat`, using `informat` to convert them into the same `DateFormat` improves the performance,

```julia
julia> function _date_infmt!(x, lo, hi)
           for i in lo:hi
               if x.data[i] == UInt('/')
                   x.data[i] = UInt('-')
               end
           end
           lo, hi
       end
julia> DINFMT! = Informat(_date_infmt!)
julia> ds = filereader(IOBuffer("""date1,date2
       2020-1-1,2020/1/1
       2020-2-2,2020/2/2
       """), types = [Date, Date], informat = Dict(2 => DINFMT!))
2×2 Dataset
 Row │ date1       date2      
     │ identity    identity   
     │ Date?       Date?      
─────┼────────────────────────
   1 │ 2020-01-01  2020-01-01
   2 │ 2020-02-02  2020-02-02
```

## Passing `lsize` can improve writing speed

When the input data set contains many columns with float types, passing `lsize` can improve the performance significantly. This is due to the fact that the `filewriter` is very conservative when converting floats to string. In the following example we can have a rough idea about how many characters exists in each row of the data set, thus, passing our estimate to the `filewriter` function improves the performance.

```julia
julia> using InMemoryDatasets

julia> ds = Dataset(rand([1.1,2.2,3.4], 100, 100000), :auto);

julia> @time filewriter("_tmp.csv", ds, buffsize = 2^25);
  7.943416 seconds (486.82 M allocations: 22.139 GiB, 36.77% gc time)

julia> @time filewriter("_tmp.csv", ds, buffsize = 2^25, lsize = 500000);
  0.207178 seconds (9.70 M allocations: 513.528 MiB)
```
