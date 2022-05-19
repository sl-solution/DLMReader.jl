module DLMReader

using InMemoryDatasets
using InlineStrings
using Dates
using UUIDs

export 
    filereader,
    filewriter,
    # informats
    Informats,
    Informat,

    COMMA!, # remove comma and dollar
    COMMAX!, # same as COMMA! but for euro
    NA!, # treats na as missing
    BOOL!, # treats true false as 1 0
    STRIP!, # removes leading and trailing blanks
    ACC!,  # treats (numbers) as negative
    COMPRESS! # compresses blanks

include("linebuffer.jl")
include("util.jl")
include("informats.jl")
include("parsers.jl")
include("reader.jl")
include("writer.jl")

# needs more works
include("precompile.jl")
end
