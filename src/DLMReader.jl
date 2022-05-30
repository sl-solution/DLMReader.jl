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
    register_informat(NA!; quiet = true)
    register_informat(COMMA!; quiet = true)
    register_informat(COMMAX!; quiet = true)
    register_informat(STRIP!; quiet = true)
    register_informat(ACC!; quiet = true)
    register_informat(COMPRESS!; quiet = true)
    register_informat(BOOL!; quiet = true)   
end
end
