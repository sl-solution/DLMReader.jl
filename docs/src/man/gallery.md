# Gallery

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