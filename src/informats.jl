abstract type Informats end
struct Informat{F} <: Informats
    f::F
    function Informat{F}(f) where F
        @assert Core.Compiler.return_type(f, (SUBSTRING{LineBuffer}, )) == SUBSTRING{LineBuffer} "informat must return its input or a subset of its input"
        new{F}(f)
    end
    function Informat(f)
        @assert Core.Compiler.return_type(f, (SUBSTRING{LineBuffer},)) == SUBSTRING{LineBuffer} "informat must return its input or a subset of its input"
        new{Core.Typeof(f)}(f)
    end
end


(c::Informats)(x) = c.f(x)

# The following functions are minimum requirement for allowing something like Dict(1:3 .=> NA!)
Base.length(::Informats) = 1
Base.iterate(x::Informats) = (x, nothing)
Base.iterate(x::Informats, ::Nothing) = nothing

# composed informat
struct ComposedInformat{O,I} <: Informats
    outer::O
    inner::I
    ComposedInformat{O, I}(outer, inner) where {O, I} = new{O, I}(outer, inner)
    ComposedInformat(outer, inner) = new{Core.Typeof(outer),Core.Typeof(inner)}(outer, inner)
end


(c::ComposedInformat)(x) = c.outer(c.inner(x))

Base.:(∘)(f::Informats) = f
Base.:(∘)(f::Informats, g::Informats) = ComposedInformat(f, g)
Base.:(∘)(f::Informats, g::Informats, h...) = ∘(f ∘ g, h...)


### line informat - informat that is applied to whole line before passing it for parsing
_lineinfmt_default(x) = x
LINEINFORMAT_DEFAULT = Informat(_lineinfmt_default)
# This file contains some popular informats

Base.@propagate_inbounds function _strip!_infmt(x)
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

STRIP! = Informat(_strip!_infmt)

# In general any function defined as informat must have these specifications:
# * it must take three positional arguments, x, lo, hi, where x is a custom structure and x.data is a vector of UInt8
# * function can change the values of x.data but only within lo:hi
# * function must do the operations in place and return lo,hi or revised lo,hi


function _comma!_infmt(x)
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
    
    _SUBSTRING_(x.string, cnt+1:hi)
end
COMMA! = Informat(_comma!_infmt)

function _commax!_infmt(x)
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
    _SUBSTRING_(x.string, cnt+1:hi)
end
COMMAX! = Informat(_commax!_infmt)

# treats NA,na,Na,nA,... as missing value for numeric columns
function _na!_infmt(x)
    lo = x.lo
    hi = x.hi
    _newsub_ = _strip!_infmt(x)
    lo = _newsub_.lo
    hi = _newsub_.hi
    flag = false
    if hi - lo + 1 == 2
        if x.string.data[lo] in (UInt8('N'), UInt8('n')) && x.string.data[hi] in (UInt8('A'), UInt8('a'))
            flag = true
        end
    end
    if flag
        x.string.data[lo] = 0x20
        return _SUBSTRING_(x.string, lo:lo)
    end
    _SUBSTRING_(x.string, lo:hi)
end
NA! = Informat(_na!_infmt)

Base.@propagate_inbounds function _bool!_infmt(x)

    _newsub_ = _strip!_infmt(x)
    lo = _newsub_.lo
    hi = _newsub_.hi
    if length(lo:hi) == 1
        if x.string.data[lo] in (0x54, 0x74, 0x31)
            x.string.data[lo] = 0x31
        elseif x.string.data[lo] in (0x46, 0x66, 0x30)
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
BOOL! = Informat(_bool!_infmt)

function _acc!_infmt(x)
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
ACC! = Informat(_acc!_infmt)

function _compress!_infmt(x)
    _newsub_ = _strip!_infmt(x)
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
    _SUBSTRING_(x.string, cnt+1:hi)
end
COMPRESS! = Informat(_compress!_infmt)