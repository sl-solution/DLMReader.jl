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
    #STRIP!
    f_ptr = @cfunction(STRIP!, Tuple{Int, Int}, (Vector{UInt8}, Int, Int))
    push!(DLMReader_Registered_Informats, :STRIP! => f_ptr)

    #COMMA!
    f_ptr = @cfunction(COMMA!, Tuple{Int, Int}, (Vector{UInt8}, Int, Int))
    push!(DLMReader_Registered_Informats, :COMMA! => f_ptr)

    #COMMAX!
    f_ptr = @cfunction(COMMAX!, Tuple{Int, Int}, (Vector{UInt8}, Int, Int))
    push!(DLMReader_Registered_Informats, :COMMAX! => f_ptr)

    #NA!
    f_ptr = @cfunction(NA!, Tuple{Int, Int}, (Vector{UInt8}, Int, Int))
    push!(DLMReader_Registered_Informats, :NA! => f_ptr)

    #BOOL!
    f_ptr = @cfunction(BOOL!, Tuple{Int, Int}, (Vector{UInt8}, Int, Int))
    push!(DLMReader_Registered_Informats, :BOOL! => f_ptr)

    #ACC!
    f_ptr = @cfunction(ACC!, Tuple{Int, Int}, (Vector{UInt8}, Int, Int))
    push!(DLMReader_Registered_Informats, :ACC! => f_ptr)

    #COMPRESS!
    f_ptr = @cfunction(COMPRESS!, Tuple{Int, Int}, (Vector{UInt8}, Int, Int))
    push!(DLMReader_Registered_Informats, :COMPRESS! => f_ptr)


end
end
