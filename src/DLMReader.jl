module DLMReader

using InMemoryDatasets
using UUIDs
using Reexport
@reexport using Dates, InlineStrings

export 
    filereader,
    filewriter,
    # informats
    register_informat, 

    COMMA!, # remove comma and dollar
    COMMAX!, # same as COMMA! but for euro
    NA!, # treats na as missing
    BOOL!, # treats true false as 1 0
    STRIP!, # removes leading and trailing blanks
    ACC!,  # treats (numbers) as negative
    COMPRESS!, # compresses blanks

    #manipulating text
    remove!



include("linebuffer.jl")
include("util.jl")
include("informats.jl")
include("parsers.jl")
include("reader.jl")
include("writer.jl")

# needs more works
include("precompile.jl")
function __init__()
    # register build-in informats
    for infmt in DLMReader_buildin_informats
        f_ptr = eval(:(@cfunction((inx,lo,hi)->begin; x = SUBSTRING(LineBuffer(inx), lo, hi);_newsub_ = $(infmt)(x); _newsub_.lo, _newsub_.hi; end, Tuple{Int, Int}, (Vector{UInt8}, Int, Int))))
        push!(DLMReader_Registered_Informats, Symbol(nameof(infmt)) => f_ptr)
    end
end
end
