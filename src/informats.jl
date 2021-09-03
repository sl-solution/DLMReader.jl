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

# needs more work
function NUM_NA!(x, lo, hi)
    seen = false
    cnt = lo
    while true
        if x.data[cnt] == 0x20
            cnt += 1
        elseif x.data[cnt] in (UInt8('N'), UInt8('n'))
            if cnt < hi
                if x.data[cnt+1] in (UInt8('A'), UInt8('a'))
                    seen = true
                    cnt += 2
                else
                    seen = false
                    cnt += 2
                end
            else
                seen = false
                cnt += 1
            end
        else
            seen = false
            break
        end
        cnt > hi && break
    end


    if seen
        @simd for i in lo:hi
            x.data[i] = 0x20
        end
        x.data[lo] = UInt8('.')
    end
    nothing
end


        
