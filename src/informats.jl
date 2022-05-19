abstract type Informats end
struct Informat{F} <: Informats
    f::F
    Informat{F}(f) where F = new{F}(f)
    Informat(f) = new{Core.Typeof(f)}(f)
end


(c::Informats)(x, lo, hi) = c.f(x, lo, hi)

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


function (c::ComposedInformat)(x,lo,hi)
    l,h = c.inner(x, lo, hi)
    c.outer(x, l, h)
end

Base.:(∘)(f::Informats) = f
Base.:(∘)(f::Informats, g::Informats) = ComposedInformat(f, g)
Base.:(∘)(f::Informats, g::Informats, h...) = ∘(f ∘ g, h...)


### line informat - informat that is applied to whole line before passing it for parsing
_lineinfmt_default(x, lo, hi) = (lo, hi)
LINEINFORMAT_DEFAULT = Informat(_lineinfmt_default)
# This file contains some popular informats
# This is experimental currently

Base.@propagate_inbounds function _strip!_infmt(x, lo, hi)
    for i in lo:hi
        if x.data[i] != 0x20
            lo = i
            break
        end
    end
    for i in hi:-1:lo
        if x.data[i] != 0x20
            hi = i
            break
        end
    end
    lo, hi
end

STRIP! = Informat(_strip!_infmt)

# In general any function defined as informat must have these specifications:
# * it must take three positional arguments, x, lo, hi, where x is a custom structure and x.data is a vector of UInt8
# * function can change the values of x.data but only within lo:hi
# * function must do the operations in place and return lo,hi or revised lo,hi


function _comma!_infmt(x, lo, hi)
    cnt = hi
    for i in hi:-1:lo
        if !(x.data[i] in (UInt8(','), UInt8('$'), UInt8('£')))
            x.data[cnt] = x.data[i]
            cnt -= 1
            cnt < lo && break
        end
    end
    # for i in lo:cnt
    #     x.data[i] = 0x20
    # end
    # fill!(view(x.data, lo:cnt), 0x20)
    cnt+1,hi
end
COMMA! = Informat(_comma!_infmt)

function _commax!_infmt(x, lo, hi)
    cnt = hi
    for i in hi:-1:lo
        if !(x.data[i] == (UInt8('.'))) #  TODO we should take care of('€') it is not UInt8
            if x.data[i] == UInt8(',')
                x.data[cnt] = UInt8('.')
            else
                x.data[cnt] = x.data[i]
            end
            cnt -= 1
            cnt < lo && break
        end
    end
    for i in cnt+3:hi
        if x.data[i] == 0xac && x.data[i-1] == 0x82 && x.data[i-2] == 0xe2
            fill!(view(x.data, i-2:i), 0x20)
        end
    end
    cnt+1,hi
end
COMMAX! = Informat(_commax!_infmt)

# treats NA,na,Na,nA,... as missing value for numeric columns
function _na!_infmt(x, lo, hi)
    lo, hi = _strip!_infmt(x, lo, hi)
    flag = false
    if hi-lo+1 == 2
        if x.data[lo] in (UInt8('N'), UInt8('n')) && x.data[hi] in (UInt8('A'), UInt8('a'))
            flag = true
        end
    end

    if flag
        x.data[lo] = 0x20
        return lo,lo
        # fill!(view(x.data, lo:hi), 0x20)
    end
    lo,hi
end
NA! = Informat(_na!_infmt)

Base.@propagate_inbounds function _bool!_infmt(x, lo, hi)
    lo, hi = _strip!_infmt(x, lo, hi)
    if length(lo:hi) == 1
        if x.data[lo] in (0x54, 0x74, 0x31)
            x.data[lo] = 0x31
        elseif x.data[lo] in (0x46, 0x66, 0x30)
            x.data[lo] = 0x30
        end
    elseif length(lo:hi) == 4
        if x.data[lo] in (0x54, 0x74) && x.data[lo+1] in (0x52,0x72) && x.data[lo+2] in (0x55, 0x75) && x.data[lo+3] in (0x45, 0x65)
            x.data[lo] = 0x31
            # x.data[lo+1] = 0x20
            # x.data[lo+2] = 0x20
            # x.data[lo+3] = 0x20
            fill!(view(x.data, lo+1:lo+3), 0x20)
        end
    elseif length(lo:hi) == 5
        if x.data[lo] in (0x46, 0x66) && x.data[lo+1] in (0x41,0x61) && x.data[lo+2] in (0x4c, 0x6c) && x.data[lo+3] in (0x53, 0x73) && x.data[lo+4] in (0x45, 0x65)
            x.data[lo] = 0x30
            # x.data[lo+1] = 0x20
            # x.data[lo+2] = 0x20
            # x.data[lo+3] = 0x20
            # x.data[lo+4] = 0x20
            fill!(view(x.data, lo+1:lo+4), 0x20)
        end
    end
    lo,hi
end
BOOL! = Informat(_bool!_infmt)

function _acc!_infmt(x, lo, hi)
    for i in lo:hi
        if x.data[i] == UInt8('(')
            x.data[i] = UInt8('-')
            for j in hi:-1:i+1
                if x.data[j] == UInt8(')')
                    x.data[j] = 0x20
                    break
                end
            end
            break         
        end
    end
    lo, hi
end
ACC! = Informat(_acc!_infmt)

function _compress!_infmt(x, lo, hi)
    lo, hi = _strip!_infmt(x, lo, hi)
    cnt = hi
    for i in hi:-1:lo
        if x.data[i] != 0x20
            x.data[cnt] = x.data[i]
            cnt -= 1
            cnt < lo && break
        end
    end
    cnt+1,hi
end
COMPRESS! = Informat(_compress!_infmt)