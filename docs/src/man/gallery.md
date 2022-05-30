# Gallery

* multiple observation per line:

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
```

* Reading computer outputs: 

```julia
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

* Removing `(.*?)` and dealing with `£`:

```julia
julia> function INFMT!(x)
           remove!(x, findfirst(r"\(.*?\)", x))
       end
           
INFMT! (generic function with 1 method)

julia> register_informat(INFMT!)
[ Info: Informat INFMT! has been registered

julia> function RM£!(x)
         remove!(x, "£")
      end
julia> register_informat(RM£!)
[ Info: Informat RM£! has been registered

julia> filereader(IOBuffer("""x1;x2
            1(comment);£12,000.00
            2;£(100.00)
            3;£(10,000.00)
       """), delimiter = ';', informat = Dict(1 => INFMT!, 2 => RM£! ∘ COMMA! ∘ ACC!))
3×2 Dataset
 Row │ x1        x2       
     │ identity  identity 
     │ Int64?    Float64? 
─────┼────────────────────
   1 │        1   12000.0
   2 │        2    -100.0
   3 │        3  -10000.0
```