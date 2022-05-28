global DLMReader_Registered_Informats = Dict{Symbol, Ptr{Nothing}}()


function register_informat(f; quiet = false)
    @assert Core.Compiler.return_type(f, Tuple{SUBSTRING}) == SUBSTRING "informat must return its input or a subset of its input"
    
    f_ptr = eval(:(@cfunction((inx,lo,hi)->begin; x = SUBSTRING(LineBuffer(inx), lo, hi);_newsub_ = $(f)(x); _newsub_.lo, _newsub_.hi; end, Tuple{Int, Int}, (Vector{UInt8}, Int, Int))))
    flag = false
    if haskey(DLMReader_Registered_Informats, Symbol(nameof(f)))
        flag = true
    end
    push!(DLMReader_Registered_Informats, Symbol(nameof(f)) => f_ptr)
    if flag
        @warn "Informat $(nameof(f)) has been overridden"
    end
    if !quiet
        @info "Informat $(nameof(f)) has been registered"
    end
    nothing
end

function _get_ptr_informat!(out::Vector{Ptr{Nothing}}, d, f)
    id = Symbol(f)
    if haskey(d, id)
        push!(out, d[id])
    else
        throw(ArgumentError("informat $id is not defined"))
    end
    out
end
function _get_ptr_informat!(out::Vector{Ptr{Nothing}}, d, f::ComposedFunction)
    _get_ptr_informat!(out, d, f.inner)
    _get_ptr_informat!(out, d, f.outer)
end

# help users debug informats
function test(f, s::String)
    f(SUBSTRING(LineBuffer(collect(codeunits(s))), 1, ncodeunits(s)))
end

### line informat - informat that is applied to whole line before passing it for parsing
# This file contains some popular informats

Base.@propagate_inbounds function STRIP!(x)
    lo = x.lo
    hi = x.hi
    for i in lo:hi
        if x.string.data[i] != 0x20
            lo = i
            break
        end
    end
    for i in hi:-1:lo
        if x.string.data[i] != 0x20
            hi = i
            break
        end
    end
    
    _SUBSTRING_(x.string, lo:hi)
end


# In general any function defined as informat must have these specifications:
# * it must take three positional arguments, x, lo, hi, where x is a custom structure and x.data is a vector of UInt8
# * function can change the values of x.data but only within lo:hi
# * function must do the operations in place and return lo,hi or revised lo,hi


function COMMA!(x)
    lo = x.lo
    hi = x.hi
    cnt = hi
    for i in hi:-1:lo
        if !(x.string.data[i] in (UInt8(','), UInt8('$'), UInt8('£')))
            x.string.data[cnt] = x.string.data[i]
            cnt -= 1
            cnt < lo && break
        end
    end

    # to show meaningful errors
    fill!(view(x.string.data, lo:cnt), 0x20)
    
    _SUBSTRING_(x.string, cnt+1:hi)
end

function COMMAX!(x)
    lo = x.lo
    hi = x.hi
    cnt = hi
    for i in hi:-1:lo
        if !(x.string.data[i] == (UInt8('.'))) 
            if x.string.data[i] == UInt8(',')
                x.string.data[cnt] = UInt8('.')
            else
                x.string.data[cnt] = x.string.data[i]
            end
            cnt -= 1
            cnt < lo && break
        end
    end
    for i in cnt+3:hi
        if x.string.data[i] == 0xac && x.string.data[i-1] == 0x82 && x.string.data[i-2] == 0xe2
            fill!(view(x.string.data, i-2:i), 0x20)
        end
    end

    fill!(view(x.string.data, lo:cnt), 0x20)
    
    _SUBSTRING_(x.string, cnt+1:hi)
end

# treats NA,na,Na,nA,... as missing value for numeric columns
function NA!(x)
    lo = x.lo
    hi = x.hi
    _newsub_ = STRIP!(x)
    lo = _newsub_.lo
    hi = _newsub_.hi
    flag = false
    if hi - lo + 1 == 2
        if x.string.data[lo] in (UInt8('N'), UInt8('n')) && x.string.data[hi] in (UInt8('A'), UInt8('a'))
            flag = true
        end
    end
    if flag
        fill!(view(x.string.data, lo:hi), 0x20)
    end
    _SUBSTRING_(x.string, lo:hi)
end

Base.@propagate_inbounds function BOOL!(x)

    _newsub_ = STRIP!(x)
    lo = _newsub_.lo
    hi = _newsub_.hi
    if length(lo:hi) == 1
        if x.string.data[lo] in (0x54, 0x74)
            x.string.data[lo] = 0x31
        elseif x.string.data[lo] in (0x46, 0x66)
            x.string.data[lo] = 0x30
        end
    elseif length(lo:hi) == 4
        if x.string.data[lo] in (0x54, 0x74) && x.string.data[lo+1] in (0x52,0x72) && x.string.data[lo+2] in (0x55, 0x75) && x.string.data[lo+3] in (0x45, 0x65)
            x.string.data[lo] = 0x31
            fill!(view(x.string.data, lo+1:lo+3), 0x20)
        end
    elseif length(lo:hi) == 5
        if x.string.data[lo] in (0x46, 0x66) && x.string.data[lo+1] in (0x41,0x61) && x.string.data[lo+2] in (0x4c, 0x6c) && x.string.data[lo+3] in (0x53, 0x73) && x.string.data[lo+4] in (0x45, 0x65)
            x.string.data[lo] = 0x30
            fill!(view(x.string.data, lo+1:lo+4), 0x20)
        end
    end
    _SUBSTRING_(x.string, lo:hi)
end

function ACC!(x)
    lo = x.lo
    hi = x.hi
    for i in lo:hi
        if x.string.data[i] == UInt8('(')
            x.string.data[i] = UInt8('-')
            for j in hi:-1:i+1
                if x.string.data[j] == UInt8(')')
                    x.string.data[j] = 0x20
                    break
                end
            end
            break         
        end
    end
    _SUBSTRING_(x.string, lo:hi)
end

function COMPRESS!(x)
    _newsub_ = STRIP!(x)
    lo = _newsub_.lo
    hi = _newsub_.hi
    cnt = hi
    for i in hi:-1:lo
        if x.string.data[i] != 0x20
            x.string.data[cnt] = x.string.data[i]
            cnt -= 1
            cnt < lo && break
        end
    end
    fill!(view(x.string.data, lo:cnt), 0x20)
    _SUBSTRING_(x.string, cnt+1:hi)
end
