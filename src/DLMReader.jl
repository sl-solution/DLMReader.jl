module DLMReader

using InMemoryDatasets
using WeakRefStrings
using Reexport
@reexport using Dates
export filereader,
    # informats
    COMMA!,
    COMMAX!

include("linebuffer.jl")
include("util.jl")
include("informats.jl")
include("parsers.jl")
include("reader.jl")


end
