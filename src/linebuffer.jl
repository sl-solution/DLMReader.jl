
struct LineBuffer <: AbstractString
    data::Vector{UInt8}
end

function Base.iterate(s::LineBuffer, i::Int = 1)
    i > length(s.data) && return nothing
    return (Char(s.data[i]), i+1)
end

Base.lastindex(s::LineBuffer) = length(s.data)

Base.getindex(s::LineBuffer, i::Int) = s.data[i]

Base.sizeof(s::LineBuffer) = sizeof(s.data)

Base.length(s::LineBuffer) = length(s.data)

Base.ncodeunits(s::LineBuffer) = length(s.data)

Base.codeunit(::LineBuffer) = UInt8
Base.codeunit(s::LineBuffer, i::Integer) = s.data[i]

Base.isvalid(s::LineBuffer, i::Int) = checkbounds(Bool, s, i)

# minimum type defination for parsing TimeType data

struct DT{N} <: AbstractString
    data::Vector{UInt8}
end

strlength(s::DT{N}) where N = N
function allocateDT(::Type{DT{N}}, len) where N
    DT{N}(fill(0x00, N*len))
end
