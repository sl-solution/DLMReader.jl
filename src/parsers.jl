# too many allocations for time type, probably we need another strategy for this
function buff_parser(res, lbuff, cc, nd, current_line, df, ::Type{T}) where  T <: TimeType
    flag = 0
    if cc > nd
        val = nothing
    else
        val = Dates.tryparsenext_internal(T, lbuff, cc, nd, df, false)
    end

    if val === nothing
        @simd for i in cc:nd
            @inbounds if (lbuff.data[i] != 0x20 && lbuff.data[i] != 0x2e)
                flag = 1

            end
        end
        res[current_line[]] = missing
    else
        res[current_line[]] = T(val[1]...)
    end
    flag
end


function buff_parser(res, lbuff, cc, nd, current_line, ::Type{T}) where T <: Integer
    val = Base.tryparse_internal(T, lbuff, cc, nd, 10, false)
    flag = 0
    # hasvalue, val = ccall(:jl_try_substrtod, Tuple{Bool, Float64},
    # (Ptr{UInt8},Csize_t,Csize_t), lbuff, cc-1, nd - cc +1)
    # hasvalue ? res[current_line[]] = T(val) : res[current_line[]] = missing
    if val === nothing
        @simd for i in cc:nd
            @inbounds if (lbuff.data[i] != 0x20 && lbuff.data[i] != 0x2e)
                flag = 1

            end
        end
        res[current_line[]] = missing
    else
        res[current_line[]] = val
    end
    flag
    # (x, code, startpos, value_len, total_len) = Parsers.xparse(T, lbuff, cc, nd)
    # code == 33 ? res[current_line[]] = x : x = missing
end
using Parsers
function buff_parser(res, lbuff, cc, nd, current_line, ::Type{T}) where T <: Real
    hasvalue, val = ccall(:jl_try_substrtod, Tuple{Bool, Float64},
    (Ptr{UInt8},Csize_t,Csize_t), lbuff, cc-1, nd - cc +1)
    flag = 0
    if hasvalue
        res[current_line[]] = val
    else
        @simd for i in cc:nd
            @inbounds if (lbuff[i] != 0x20 && lbuff[i] != 0x2e)
                flag = 1

            end
        end
        res[current_line[]] = missing
    end
    flag
    # RES = Parsers.xparse(T, lbuff, cc, nd)
    # RES.code == 33 ? res[current_line[]] = RES.val : res[current_line[]] = missing
    # return 0
end
function buff_parser(res, lbuff, cc, nd, current_line, ::Type{Float32})
    hasvalue, val = ccall(:jl_try_substrtof, Tuple{Bool, Float32},
    (Ptr{UInt8},Csize_t,Csize_t), lbuff, cc-1, nd - cc +1)
    flag = 0
    if hasvalue
        res[current_line[]] = val
    else
        @simd for i in cc:nd
            @inbounds if (lbuff[i] != 0x20 && lbuff[i] != 0x2e)
                flag = 1

            end
        end
        res[current_line[]] = missing
    end
    flag
    # (x, code, startpos, value_len, total_len) = Parsers.xparse(Float32, lbuff, cc, nd)
    # code == 33 ? res[current_line[]] = x : x = missing
end
function buff_parser(res, lbuff, cc, nd, current_line, ::Type{String})
    # (x, code, startpos, value_len, total_len) = Parsers.xparse(String, lbuff, cc, nd, Parsers.Options(ignoreemptylines=true))
    # code == 33 ? res[current_line[]] = x : x = missing
    l = nd - cc + 1
    cnt = 0
    for i in cc:nd
        cnt += lbuff[i] == 0x20
    end
    l == 0 || l == cnt ? res[current_line[]] = missing : res[current_line[]] = unsafe_string(pointer(lbuff, cc), l)
    return 0

end
# function buff_parser(res, lbuff, cc, nd, current_line, ::Type{T}) where T <: InlineString
#     (x, code, startpos, value_len, total_len) = Parsers.xparse(T, lbuff, cc, nd, Parsers.Options())
#     code == 33 ? res[current_line[]] = x : x = missing
# end
#
function (::Type{T})(buf::Vector{UInt8}, pos, len) where {T <: InlineString}
   if T === InlineString1
       len == 1 || WeakRefStrings.stringtoolong(T, sizeof(x))
       return Base.bitcast(InlineString1, buf[pos])
   else
       length(buf) < len && WeakRefStrings.buftoosmall()
       len < sizeof(T) || WeakRefStrings.stringtoolong(T, len)
       y = GC.@preserve buf unsafe_load(convert(Ptr{T}, pointer(buf, pos)))
       sz = 8 * (sizeof(T) - len)
       return Base.or_int(Base.shl_int(Base.lshr_int(WeakRefStrings._bswap(y), sz), sz), Base.zext_int(T, UInt8(len)))
   end
end

function buff_parser(res, lbuff, cc, nd, current_line, ::Type{T}) where T <: InlineString
    if cc>nd
        res[current_line[]] = missing
    else
        res[current_line[]] = T(lbuff, cc, nd-cc+1)
    end
    return 0
end
function buff_parser(res, lbuff, cc, nd, current_line, char_buff, ::Type{T}) where T <: Characters
    if cc>nd
        res[current_line[]] = missing
    else
        res[current_line[]] = T(lbuff, char_buff, cc, nd)
    end
    return 0
end

function buff_parser(res, lbuff, cc, nd, current_line, char_buff, ::Type{T}) where T <: DT
    if cc>nd
        nothing
    else
        copyto!(res, crrent_line[], lbuff, cc, min(strlength(T), nd - cc +1))
    end
    return 0
end
