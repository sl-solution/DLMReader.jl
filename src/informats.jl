# This file contains some popular informats
# This is experimental currently

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
        if !(x.data[i] in (UInt8('.'), UInt8('€')))
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


        
