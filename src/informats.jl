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

function NUM_NA!(x, lo, hi)
    flag = true
    for i in lo+1:hi
        if x.data[i] == 0x20
            continue
        elseif x.data[i-1] == UInt8('N') && x.data[i] == UInt('A')
            flag &= true
        elseif x.data[i-1] == UInt8('n') && x.data[i] == UInt('a')
            flag &= true
        else
            flag = false
        end
    end
    if !(x.data[lo] in (UInt8('N'), UInt8('n'), 0x20))
        flag = false
    end
    # should we check the last character
    if flag
        @simd for i in lo:hi
            x.data[i] = 0x20
        end
        x.data[lo] = UInt8('.')
    end
    nothing
end


        
