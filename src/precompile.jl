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
   
   nothing
end
