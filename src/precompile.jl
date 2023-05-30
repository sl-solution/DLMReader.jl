function warmup()

   dir = joinpath(dirname(pathof(DLMReader)), "..", "test", "csvfiles")
   ds = filereader(joinpath(dir, "repeat1.csv"), ignorerepeated = true, header = true, quotechar = '"', delimiter = '\t')
  
   ds = filereader(IOBuffer("""x1;x2
      12;13
      1;2
      """), delimiter = ';')
   ds = filereader(IOBuffer("""x1|:|x2
      12|:|13
      1|:|2
      """), dlmstr = "|:|" )
   ds = filereader(IOBuffer("""x1,,x2
      12,13
      1,,,,2
      """), ignorerepeated = true)
   ds = filereader(IOBuffer("""
      12,13
      1,2
      """), header = [:Col1, :Col2])
   ds = filereader(IOBuffer("""
      x1,x2;12,13;1,2;"""), linebreak = ';')
   ds = filereader(IOBuffer("""
      12
      34
      """), fixed = Dict(1=>1:1, 2=>2:2), header = false)
   ds = filereader(IOBuffer("""x1,x2
      "12",13
      "1",2
      """), quotechar = '"')
   ds = filereader(IOBuffer("""date1,date2
      2020-1-1,2020/1/1
      2020-2-2,2020/2/2
      """), dtformat = Dict(1 => dateformat"y-m-d", 2 => dateformat"y/m/d"))
   ds = filereader(IOBuffer("""x1,x2
      100,100
      101,101
      """), int_base = Dict(1 => 2))
  
   ds = filereader(IOBuffer("""COL1, COL2
      1,2
      2,3
      3,4
      """), skipto = 3, header = false)
   ds = filereader(IOBuffer("""COL1, COL2
      1,2
      2,3
      3,4
      """), limit = 1)
   ds = filereader(IOBuffer("""1,2,3,4,5
      6,7
      """), multiple_obs = true, header = [:x1, :x2], types = [Int, Int])
   ds = filereader(IOBuffer("""x1,x2
      "    fdh  ",df
      "dkhfd    ",dfadf
      """), quotechar = '"', string_trim = true)
  
   ds = filereader(IOBuffer("""x,x
      1,2
      """), makeunique = true)
   ds = filereader(IOBuffer("""x,
      1,2
      """), emptycolname = true)
   ds = filereader(IOBuffer("1,2,3,4,5\n6,7,8\n10\n"),
               header = [:x1, :x2],
               types = [Int, Int],
               multiple_obs = true)
   ds = filereader(IOBuffer(""" name1 name2 avg1 avg2  y
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
   

    ds = filereader(joinpath(dir, "repeat1.csv"), ignorerepeated = true, header = true, quotechar = '"', delimiter = '\t', threshold=0)
  
   ds = filereader(IOBuffer("""x1;x2
      12;13
      1;2
      """), delimiter = ';', threshold=0)
   ds = filereader(IOBuffer("""x1|:|x2
      12|:|13
      1|:|2
      """), dlmstr = "|:|", threshold=0 )
   ds = filereader(IOBuffer("""x1,,x2
      12,13
      1,,,,2
      """), ignorerepeated = true)
   ds = filereader(IOBuffer("""
      12,13
      1,2
      """), header = [:Col1, :Col2], threshold=0)
   ds = filereader(IOBuffer("""
      x1,x2;12,13;1,2;"""), linebreak = ';', threshold=0)
   ds = filereader(IOBuffer("""
      12
      34
      """), fixed = Dict(1=>1:1, 2=>2:2), header = false, threshold=0)
   ds = filereader(IOBuffer("""x1,x2
      "12",13
      "1",2
      """), quotechar = '"', threshold=0)
   ds = filereader(IOBuffer("""date1,date2
      2020-1-1,2020/1/1
      2020-2-2,2020/2/2
      """), dtformat = Dict(1 => dateformat"y-m-d", 2 => dateformat"y/m/d"), threshold=0)
   ds = filereader(IOBuffer("""x1,x2
      100,100
      101,101
      """), int_base = Dict(1 => 2), threshold=0)
  
   ds = filereader(IOBuffer("""COL1, COL2
      1,2
      2,3
      3,4
      """), skipto = 3, header = false, threshold=0)
   ds = filereader(IOBuffer("""COL1, COL2
      1,2
      2,3
      3,4
      """), limit = 1, threshold=0)
   ds = filereader(IOBuffer("""1,2,3,4,5
      6,7
      """), multiple_obs = true, header = [:x1, :x2], types = [Int, Int], threshold=0)
   ds = filereader(IOBuffer("""x1,x2
      "    fdh  ",df
      "dkhfd    ",dfadf
      """), quotechar = '"', string_trim = true, threshold=0)
  
   ds = filereader(IOBuffer("""x,x
      1,2
      """), makeunique = true, threshold=0)
   ds = filereader(IOBuffer("""x,
      1,2
      """), emptycolname = true, threshold=0)
   ds = filereader(IOBuffer("1,2,3,4,5\n6,7,8\n10\n"),
               header = [:x1, :x2],
               types = [Int, Int],
               multiple_obs = true, threshold=0)
   ds = filereader(IOBuffer(""" name1 name2 avg1 avg2  y
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
   """), delimiter = ' ', ignorerepeated = true, emptycolname = true, threshold=0)
   

   nothing
end

# since we are using Parsers under windows - see issue #5 / probably it would be safe for Julia > 1.8
if !Base.Sys.iswindows()
   precompile(Tuple{typeof(DLMReader.detect_types), Base.GenericIOBuffer{Array{UInt8, 1}}, Int64, Int64, Base.Dict{Int64, DataType}, Array{UInt8, 1}, Array{UInt8, 1}, Bool, Array{Symbol, 1}, Int64, Base.Dict{Int64, Base.UnitRange{Int64}}, Base.Dict{Int64, Dates.DateFormat{S, T} where T<:Tuple where S}, Bool, Int64, Int64, Nothing, Nothing, Nothing, Bool, Int64, Int64, Nothing})

   precompile(Tuple{typeof(DLMReader.detect_types), String, Int64, Int64, Base.Dict{Int64, DataType}, Array{UInt8, 1}, Array{UInt8, 1}, Bool, Array{Symbol, 1}, Int64, Base.Dict{Int64, Base.UnitRange{Int64}}, Base.Dict{Int64, Dates.DateFormat{S, T} where T<:Tuple where S}, Bool, Int64, Int64, Nothing, Nothing, Nothing, Bool, Int64, Int64, Nothing})


   precompile(Tuple{typeof(DLMReader.distribute_file_no_parse), Base.GenericIOBuffer{Array{UInt8, 1}}, Int64, Int64, Array{DataType, 1}, Array{UInt8, 1}, Array{UInt8, 1}, Bool, Array{Symbol, 1}, Bool, Int64, Nothing, Int64, Array{Dates.DateFormat{S, T} where T<:Tuple where S, 1}, Array{Array{UInt8, 1}, 1}, Int64, Bool, Nothing, Nothing, Nothing, Int64, Bool, Nothing, Bool, Bool, Bool, Bool, Int64, Int64, Nothing})

   precompile(Tuple{typeof(DLMReader.distribute_file_no_parse), String, Int64, Int64, Array{DataType, 1}, Array{UInt8, 1}, Array{UInt8, 1}, Bool, Array{Symbol, 1}, Bool, Int64, Nothing, Int64, Array{Dates.DateFormat{S, T} where T<:Tuple where S, 1}, Array{Array{UInt8, 1}, 1}, Int64, Bool, Nothing, Nothing, Nothing, Int64, Bool, Nothing, Bool, Bool, Bool, Bool, Int64, Int64, Nothing})

   precompile(Tuple{typeof(DLMReader.filereader), Base.GenericIOBuffer{Array{UInt8, 1}}})
   precompile(Tuple{typeof(DLMReader.filereader), String})
end