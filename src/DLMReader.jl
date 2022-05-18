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

    COMMA!,
    COMMAX!,
    NA!,
    BOOL!,
    STRIP!

include("linebuffer.jl")
include("util.jl")
include("informats.jl")
include("parsers.jl")
include("reader.jl")
include("writer.jl")

# needs more works
include("precompile.jl")
end
