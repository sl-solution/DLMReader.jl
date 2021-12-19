# This file contains some popular informats
# This is experimental currently

# In general any function defined as informat must have these specification:
# * it must take three positional argument, x, lo, hi, where x is a custom structure and x.data is a vector of UInt8
# * function can change the values of x.data but only within lo:hi
# * function must do the operations in place and return nothing


function COMMA!(x, lo, hi)
    cnt = hi
    for i in hi:-1:lo
        if !(x.data[i] in (UInt8(','), UInt8('$'), UInt8('£')))
            x.data[cnt] = x.data[i]
            cnt -= 1
            cnt < lo && break
        end
    end
    for i in lo:cnt
        x.data[i] = 0x20
    end
    nothing
end
function COMMAX!(x, lo, hi)
    cnt = hi
    for i in hi:-1:lo
        if !(x.data[i] in (UInt8('.'))) #  TODO we should take care of('€') it is not UInt8
            if x.data[i] == UInt8(',')
                x.data[cnt] = UInt8('.')
            else
                x.data[cnt] = x.data[i]
            end
            cnt -= 1
            cnt < lo && break
        end
    end
    for i in lo:cnt
        x.data[i] = 0x20
    end
    nothing
end

# treats NA,na,Na,nA,... as missing value for numeric columns
function NUM_NA!(x, lo, hi)
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
    flag = false
    if hi-lo+1 == 2
        if x.data[lo] in (UInt8('N'), UInt8('n')) && x.data[hi] in (UInt8('A'), UInt8('a'))
            flag = true
        end
    end



    if flag
        for i in lo:hi
            x.data[i] = 0x20
        end
        x.data[lo] = UInt8('.')
    end
    nothing
end

function CHAR_NA!(x, lo, hi)
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
    flag = false
    if hi-lo+1 == 2
        if x.data[lo] in (UInt8('N'), UInt8('n')) && x.data[hi] in (UInt8('A'), UInt8('a'))
            flag = true
        end
    end



    if flag
        for i in lo:hi
            x.data[i] = 0x20
        end
        # x.data[lo] = UInt8('.')
    end
    nothing
end

Base.@propagate_inbounds function BOOL!(x, lo, hi)
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
    if length(lo:hi) == 1
        if x.data[lo] in (0x54, 0x74, 0x31)
            x.data[lo] = 0x31
        elseif x.data[lo] in (0x46, 0x66, 0x30)
            x.data[lo] = 0x30
        end
    elseif length(lo:hi) == 4
        if x.data[lo] in (0x54, 0x74) && x.data[lo+1] in (0x52,0x72) && x.data[lo+2] in (0x55, 0x75) && x.data[lo+3] in (0x45, 0x65)
            x.data[lo] = 0x31
            x.data[lo+1] = 0x20
            x.data[lo+2] = 0x20
            x.data[lo+3] = 0x20
        end
    elseif length(lo:hi) == 5
        if x.data[lo] in (0x46, 0x66) && x.data[lo+1] in (0x41,0x61) && x.data[lo+2] in (0x4c, 0x6c) && x.data[lo+3] in (0x53, 0x73) && x.data[lo+4] in (0x45, 0x65)
            x.data[lo] = 0x30
            x.data[lo+1] = 0x20
            x.data[lo+2] = 0x20
            x.data[lo+3] = 0x20
            x.data[lo+4] = 0x20
        end
    end
    nothing
end
