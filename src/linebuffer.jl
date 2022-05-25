
struct LineBuffer <: AbstractString
    data::Vector{UInt8}
end

function Base.iterate(s::LineBuffer, i::Int=1)
    i > length(s.data) && return nothing
    return (Char(s.data[i]), i + 1)
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
struct SUBSTRING <: AbstractString
    string::LineBuffer
    lo::Int
    hi::Int
end

# unsafe 
_SUBSTRING_(s::LineBuffer, r) = SUBSTRING(s, r.start, r.stop)
_SUBSTRING_(s::SUBSTRING, r) = SUBSTRING(s.string, s.lo+r.start-1, s.lo+r.stop-1)

Base.length(s::SUBSTRING) = s.hi - s.lo + 1
_checkbounds_(s::SUBSTRING, r::UnitRange{<:Integer})  = !isempty(r) && (r.start >= 1 && r.stop <= length(s))
_checkbounds_(s::SUBSTRING, r::Integer) = r <= length(s)

function Base.iterate(s::SUBSTRING, i::Int=1)
    i > length(s) && return nothing
    return (Char(s.string.data[s.lo+i-1]), i + 1)
end

function Base.isequal(s::SUBSTRING, x::String)
    length(s) != ncodeunits(x) && return false
    for (c1, c2) in zip(codeunits(s), codeunits(x))
        if c1 != c2
            return false
        end
    end
    return true
end
function Base.setindex!(s::SUBSTRING, x::String)
    if length(s) == ncodeunits(x)
        s.string.data[s.lo:s.hi] .= codeunits(x)
    elseif length(s) > ncodeunits(x)
        s.string.data[s.lo:s.lo+ncodeunits(x)-1] .= codeunits(x)
        for i in s.lo+ncodeunits(x):s.hi
            s.string.data[i] = 0x20
        end
    else
        s.string.data[s.lo:s.hi] .= view(codeunits(x), 1:length(s))
    end
    s
end

function Base.setindex!(s::SUBSTRING, x::String, r::UnitRange{<:Integer})
    setindex!(_SUBSTRING_(s, r), x)
    s
end

function Base.replace!(s::SUBSTRING, rp::Pair{String, String}; count::Integer = typemax(Int))
    o = rp.first
    d = rp.second
    o_c = codeunits(o)
    o_c_l = length(o_c)
    lo = s.lo
    hi = s.hi
    i = lo
    cnt = 0
    while true
        if isequal(_SUBSTRING_(s.string, i:i+o_c_l-1), o)
            setindex!(_SUBSTRING_(s.string, i:i+o_c_l-1), d)
            i += o_c_l
            cnt += 1
            cnt >= count && break
        else
            i += 1
        end
        i > hi-o_c_l+1 && break
    end
    s
end

function Base.occursin(o::String, s::SUBSTRING)::Bool
    length(s) < ncodeunits(o) && return false
    o_c = codeunits(o)
    o_c_l = length(o_c)
    lo = s.lo
    hi = s.hi
    i = lo
    while true
        if isequal(_SUBSTRING_(s.string, i:i+o_c_l-1), o)
            return true
        else
            i += 1
        end
        i > hi-o_c_l+1 && break
    end
    return false
end

Base.contains(s::SUBSTRING, o::String) = occursin(o, s)

function remove!(s::SUBSTRING, o::String)
    o_c = codeunits(o)
    o_c_l = length(o_c)
    lo = s.lo
    hi = s.hi
    i = hi
    idx = hi
    while true
        if isequal(_SUBSTRING_(s.string, i-o_c_l+1:i), o)
            i -= o_c_l
        else
            s.string.data[idx] = s.string.data[i]
            idx -= 1
            i -= 1
        end
        i < lo+o_c_l-1 && break
    end
    _SUBSTRING_(s.string, idx+1:hi)
end

function Base.getindex(s::LineBuffer, r::UnitRange{<:Integer})
    #use default checkbounds
    checkbounds(s, r)
    SUBSTRING(s, r.start, r.stop)
end
function Base.getindex(s::SUBSTRING, r::UnitRange{<:Integer})
    _checkbounds_(s, r)
    SUBSTRING(s.string, s.lo+r.start-1, s.lo+r.stop-1)
end

Base.codeunit(::SUBSTRING) = UInt8
function Base.codeunit(x::SUBSTRING, i::Integer)
    _checkbounds_(x, i)
    x.string.data[x.lo+i-1]
end
Base.ncodeunits(s::SUBSTRING) = length(s)

Base.isvalid(s::SUBSTRING, i::Int) = _checkbounds_(s, i)

# TODO: avoid allocation in occursin with Regex - probably needs more work
function Base.occursin(r::Regex, s::SUBSTRING; offset::Integer=0)
    Base.compile(r)
    return Base.PCRE.exec_r(r.regex, s, offset, r.match_options)
end

function Base.PCRE.exec(re, subject::SUBSTRING, offset, options, match_data)
    rc = ccall((:pcre2_match_8, Base.PCRE.PCRE_LIB), Cint,
               (Ptr{Cvoid}, Ptr{UInt8}, Csize_t, Csize_t, UInt32, Ptr{Cvoid}, Ptr{Cvoid}),
               re, pointer(subject.string.data, subject.lo), ncodeunits(subject), offset, options, match_data, Base.PCRE.get_local_match_context())
    # rc == -1 means no match, -2 means partial match.
    rc < -2 && error("PCRE.exec error: $(err_message(rc))")
    return rc >= 0
end

# minimum type definition for parsing TimeType data

struct DT{N} <: AbstractString
    data::Vector{UInt8}
end

strlength(s::DT{N}) where {N} = N
function allocateDT(::Type{DT{N}}, len) where {N}
    DT{N}(fill(0x00, N * len))
end
