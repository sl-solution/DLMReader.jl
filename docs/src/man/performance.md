# Performance tips

This section contains some performance tips which can improve the experience of working with DLMReader. These tips are specially important when reading a huge file.

## Avoid using String type for large data sets

Using `String` causes garbage collection and it must be avoided when possible. 

## Pass `types` for very wide files

By default, `filereader` uses 20 lines of the input file to guess the types of each column. For very wide files, this is not very efficient, and passing the `types` keyword argument or setting a lower number for `gussingrows` can significantly improve the performance.

```julia
julia> using InMemoryDatasets

julia> ds = Dataset(rand([1.1,2.2,3.4], 100, 100000), :auto);

julia> @time filewriter("_tmp.csv", ds, buffsize = 2^25);
  1.378465 seconds (54.90 M allocations: 2.547 GiB, 19.67% gc time)

julia> @time ds = filereader("_tmp.csv", buffsize = 2^21, lsize = 2^20, types = fill(Float64, 10^5));
  1.326470 seconds (999.87 k allocations: 183.719 MiB)

julia> @time ds = filereader("_tmp.csv", buffsize = 2^21, lsize = 2^20, guessingrows = 2);
  2.012463 seconds (4.20 M allocations: 291.914 MiB)
```

## Use `informat` to improve performance

In many cases using `informat` can improve the performance of reading huge files. For instances, if there are two columns in the input file which both are `Date` but with different `DataFormat`, using `informat` to convert them into the same `DateFormat` improves the performance,

```julia
julia> function DINFMT!(x)
           replace!(x, "/" => "-")
       end
julia> register_informat(DINFMT!)
  [ Info: Informat DINFMT! has been registered
  
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
  1.378465 seconds (54.90 M allocations: 2.547 GiB, 19.67% gc time)

julia> @time filewriter("_tmp.csv", ds, buffsize = 2^25, lsize = 500000);
  0.214730 seconds (9.80 M allocations: 516.580 MiB)
```
