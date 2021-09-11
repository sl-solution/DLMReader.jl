module DLMReader

using InMemoryDatasets
using WeakRefStrings
using Reexport
@reexport using Dates
export filereader,
    # informats
    COMMA!,
    COMMAX!,
    NUM_NA!

include("linebuffer.jl")
include("util.jl")
include("informats.jl")
include("parsers.jl")
include("reader.jl")
# needs work
# include("precompile.jl")


end
