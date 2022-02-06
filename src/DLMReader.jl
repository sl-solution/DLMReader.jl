module DLMReader

using InMemoryDatasets
using Reexport
@reexport using Dates, InlineStrings
export filereader,
    filewriter,
    # informats
    COMMA!,
    COMMAX!,
    NUM_NA!,
    CHAR_NA!,
    BOOL!,
    STRIP!

include("linebuffer.jl")
include("util.jl")
include("informats.jl")
include("parsers.jl")
include("reader.jl")
include("writer.jl")

# needs work
# include("precompile.jl")


end
