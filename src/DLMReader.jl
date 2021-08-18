module DLMReader

using WeakRefStrings
export filereader

include("linebuffer.jl")
include("util.jl")
include("parsers.jl")
include("reader.jl")

end
