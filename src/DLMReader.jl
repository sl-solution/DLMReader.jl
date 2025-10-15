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

# see https://github.com/sl-solution/DLMReader.jl/issues/5
if Base.Sys.iswindows()
    function typeparser(::Type{T}, x::Vector{UInt8}, lo::Int, hi::Int) where T <: Real
        val = Parsers.xparse(T, x, lo, hi)
        if val.code == 33
            return true, val.val
        else
            return false, val.val
        end
    end
else
    typeparser(::Type{Float64}, x::Vector{UInt8}, lo::Int, hi::Int) = ccall(:jl_try_substrtod, Tuple{Bool, Float64},(Ptr{UInt8},Csize_t,Csize_t), x, lo-1, hi - lo + 1)

    typeparser(::Type{Float32}, x::Vector{UInt8}, lo::Int, hi::Int) = ccall(:jl_try_substrtof, Tuple{Bool, Float32},(Ptr{UInt8},Csize_t,Csize_t), x, lo-1, hi - lo + 1)
end


include("linebuffer.jl")
include("util.jl")
include("informats.jl")
include("parsers.jl")
include("parse_io.jl")
include("reader.jl")
include("writer.jl")

# needs more works
include("precompile.jl")
if VERSION >= v"1.9.0" 
    DLMReader.warmup()
end

end
