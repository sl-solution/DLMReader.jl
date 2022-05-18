using DLMReader, InMemoryDatasets, InlineStrings, Dates
using Test
dir = joinpath(dirname(pathof(DLMReader)), "..", "test", "csvfiles")
@testset "general usage" begin
    ds = filereader(IOBuffer("a,b\n1,,,2\n3,,,,,,,4\n"), ignorerepeated = true, header = true)
    @test ds == Dataset(a=[1,3], b=[2,4])
    ds = filereader(IOBuffer("a,b\n1,,,2\n3,,,,,,,4.1\n"), ignorerepeated = true, header = true)
    @test ds == Dataset(a=[1,3], b=[2,4.1])
    ds = filereader(IOBuffer("""a,b\n1,,,"HL, WORLD"\n3,,,,,,,"XY"\n"""), ignorerepeated = true, header = true, quotechar = '"')
    @test ds == Dataset(a = [1,3], b = ["HL, WORLD", "XY"])
    ds = filereader(IOBuffer("""a\tb\n1\t\t\t"HL, WORLD"\n3\t\t\t\t\t\t\t"XY"\n"""), ignorerepeated = true, header = true, quotechar = '"', delimiter = '\t')
    @test ds == Dataset(a = [1,3], b = ["HL, WORLD", "XY"])
    ds = filereader(joinpath(dir, "repeat1.csv"), ignorerepeated = true, header = true, quotechar = '"', delimiter = '\t')
    @test ds == Dataset(a = [1,3], b = ["HL, \"WORLD\"", "XY"])
    ds = filereader(joinpath(dir, "repeat2.csv"), ignorerepeated = true, header = true, quotechar = '"', escapechar = '"', delimiter = '\t')
    @test ds == Dataset(a = [1,3], b = ["HL, \"WORLD\"", "XY"])
    ds = filereader(IOBuffer("a,b\n1,2\n"), header = false)
    @test ds == Dataset(x1=["a","1"], x2=["b","2"])
    ds = filereader(joinpath(dir, "d2.csv"), dtformat = Dict(3=>dateformat"y-m-d"), informat = Dict(3=>NA!))
    DATE(x) = Date(x)
    DATE(::Missing) = missing
    @test ds == Dataset(a = [1,2,2,1], b=[2,3,4,2], c = DATE.([missing, "2001-01-02", "2020-04-02", "2000-12-01"]))
    ds = filereader(joinpath(dir, "dlmstr.csv"), dlmstr = "::")
    @test ds == Dataset(a=[12,12], b=[1345,13], C=[15,15], DD=[15,1])
    ds = filereader(joinpath(dir, "dollar.csv"), header = false, delimiter = ' ', informat = Dict(2=>COMMA!))
    @test ds == Dataset(x1 =["id1","id2","id3"], x2=[2000000,34000, missing], x3=[3,4,1])
    ds = filereader(joinpath(dir, "dollar2.csv"), header = false, delimiter=';', informat = Dict(1:2 .=> COMMA!))
    @test ds == Dataset(x1=[1000, 123000,1000], x2=[2000,2,2000], x3=["Hi", "Boy", "Hi"])
    ds = filereader(joinpath(dir, "multi.dat"), delimiter = [',',':',';'])
    @test ds == Dataset(x1=[1,2], x2=[2,4],x3=[123,4], x4=[3,5])
    ds = filereader(joinpath(dir, "t.txt"), dlmstr = "::;;:", quotechar = '"', escapechar = '"', header = false)
    @test ds == Dataset(x1 =["this is tha\" and this", "th\"at\"", missing], x2=[23,25,544],x3=[45,35,454])
    ds = Dataset(x1 = "id" .* string.(rand(1:10, 10000)), x2 = rand(1:100000, 10000), x3 = 1:10000)
    map!(ds, x->rand()<.1 ? missing : x, 1:2)
    _tmp_file = tempname()
    filewriter(_tmp_file, ds, header = false)
    ds2 = filereader(_tmp_file, types = [String, Int, Int], header =false)
    @test ds == ds2
    for i in 1:100
        r_loc = rand(1:10000)
        ds3 = filereader(_tmp_file, types = [String, Int, Int], header =false, skipto = r_loc, limit = 5000)
        @test ds3[1, 3] == r_loc
        @test ds3[end, 3] == min(r_loc+5000-1, nrow(ds))
    end
    ds = filereader(joinpath(dir, "euro.csv"), header = false, delimiter=';', informat = Dict(2 => COMMAX!))
    @test ds == Dataset([Union{Missing, String}["a", "b", "c", "f", "l", "g"], Union{Missing, Float64}[100.0, 34343.0, 343.34, missing, 123343.0, 3434.0], Union{Missing, Int64}[1, 2, missing, 12, 2, 1]], :auto)
end

@testset "multiple observations per line" begin
    ds = filereader(IOBuffer("a,b\n1,2\n"), header = false, multiple_obs = true, types = [String, String])
    @test ds == Dataset(x1=["a","1"], x2=["b","2"])
    ds = filereader(joinpath(dir, "t.txt"), dlmstr = "::;;:", quotechar = '"', escapechar = '"', header = false, multiple_obs = true, types = [String, Int, Int])
    @test ds == Dataset(x1 =["this is tha\" and this", "th\"at\"", missing], x2=[23,25,544],x3=[45,35,454])
    ds = filereader(IOBuffer("""a\tb\n1\t\t\t"HL, WORLD"\n3\t\t\t\t\t\t\t"XY"\n"""), ignorerepeated = true, header = false, quotechar = '"', delimiter = '\t', types = [String, String], multiple_obs = true)
    @test ds == Dataset(x1 = ["a","1","3"], x2 = ["b", "HL, WORLD", "XY"])
    @test_throws ArgumentError filereader(IOBuffer("""a\tb\n1\t\t\t"HL, WORLD"\n3\t\t\t\t\t\t\t"XY"\n"""), ignorerepeated = true, header = true, quotechar = '"', delimiter = '\t', types = [String, String], multiple_obs = true)
    ds = filereader(joinpath(dir, "multi2.dat"), types = [Int, Int], delimiter = [',', ';'], header = false, multiple_obs = true)
    @test ds == Dataset(x1=[1,123,4,4,5], x2=[2,3,2,4,missing])
    ds = filereader(joinpath(dir, "multi2.dat"), types = [Int, Float64], delimiter = [',', ';'], header = false, multiple_obs = true)
    @test ds == Dataset(x1=[1,123,4,4,5], x2=[2,3,2,4,missing])
    @test eltype(ds[:,2]) <: Union{Missing, Float64}

    ds = filereader(joinpath(dir, "test1.csv"), types = [Int32, Int32, Date, Float32, Characters{2}], multiple_obs=true, informat = Dict(1:5 .=> NA!), header=[:x1, :x2, :x3, :x4, :x5], quotechar = '"')
    @test ds == Dataset([Union{Missing, Int32}[12, 1, 2, missing], Union{Missing, Int32}[12, 2, 4, missing], Union{Missing, Date}[Date("2020-01-01"), Date("2012-01-02"), Date("2005-01-01"), Date("2005-01-01")], Union{Missing, Float32}[1.2f0, 2.3f0, 1.3f0, 1.3f0], Union{Missing, Characters{2, UInt8}}["a1", "a2", "a3", missing]], [:x1, :x2, :x3, :x4, :x5])
    ds = filereader(joinpath(dir, "test1.csv"), types = [Int32, Int32, Date, Float32, String3], multiple_obs=true, informat = Dict(1:5 .=> NA!), header=[:x1, :x2, :x3, :x4, :x5], quotechar = '"')
    @test ds == Dataset([Union{Missing, Int32}[12, 1, 2, missing], Union{Missing, Int32}[12, 2, 4, missing], Union{Missing, Date}[Date("2020-01-01"), Date("2012-01-02"), Date("2005-01-01"), Date("2005-01-01")], Union{Missing, Float32}[1.2f0, 2.3f0, 1.3f0, 1.3f0], Union{Missing, Characters{2, UInt8}}["a1", "a2", "a3", missing]], [:x1, :x2, :x3, :x4, :x5])
    ds = filereader(joinpath(dir, "test1.csv"), types = [Int32, Int32, Date, Float32, String], multiple_obs=true, informat = Dict(1:5 .=> NA!), header=[:x1, :x2, :x3, :x4, :x5], quotechar = '"')
    @test ds == Dataset([Union{Missing, Int32}[12, 1, 2, missing], Union{Missing, Int32}[12, 2, 4, missing], Union{Missing, Date}[Date("2020-01-01"), Date("2012-01-02"), Date("2005-01-01"), Date("2005-01-01")], Union{Missing, Float32}[1.2f0, 2.3f0, 1.3f0, 1.3f0], Union{Missing, Characters{2, UInt8}}["a1", "a2", "a3", missing]], [:x1, :x2, :x3, :x4, :x5])
end
