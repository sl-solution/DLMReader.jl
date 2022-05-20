
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


# preparing some tools which allow user to define Informat easier

# we need fast sub-string type for LineBuffer
struct SUBSTRING{LineBuffer} <: AbstractString
    string::LineBuffer
    offset::Int
    ncodeunits::Int
end

function Base.iterate(s::SUBSTRING{LineBuffer}, i::Int = 1)
    i > s.ncodeunits && return nothing
    return (Char(s.string.data[s.offset+i]), i+1)
end

function _EQ_(s::SUBSTRING{LineBuffer}, x)
    s.ncodeunits != ncodeunits(x) && return false
    for (c1, c2) in zip(codeunits(s), codeunits(x))
        if c1 != c2 
            return false
        end
    end
    return true
end
function _SET!_(s::SUBSTRING{LineBuffer}, x)
    if s.ncodeunits >= ncodeunits(x)
        s.string.data[s.offset+1:s.offset+ncodeunits(x)] .= codeunits(x)
    end
    s
end

function Base.getindex(s::LineBuffer, r::UnitRange{<:Integer})
    checkbounds(s, r)
    SUBSTRING{LineBuffer}(s, r.start-1, length(r))
end
function Base.getindex(s::SUBSTRING{LineBuffer}, r::UnitRange{<:Integer})
    checkbounds(s, r)
    SUBSTRING{LineBuffer}(s.string, s.offset+r.start-1, length(r))
end

Base.codeunit(::SUBSTRING{LineBuffer}) = UInt8
function Base.codeunit(x::SUBSTRING{LineBuffer}, i::Integer)
    checkbounds(x, i)
    x.string.data[x.offset+i]
end
Base.ncodeunits(s::SUBSTRING{LineBuffer}) = s.ncodeunits

Base.isvalid(s::SUBSTRING{LineBuffer}, i::Int) = checkbounds(Bool, s, i)


# minimum type definition for parsing TimeType data

struct DT{N} <: AbstractString
    data::Vector{UInt8}
end

strlength(s::DT{N}) where N = N
function allocateDT(::Type{DT{N}}, len) where N
    DT{N}(fill(0x00, N*len))
end
