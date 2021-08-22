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
