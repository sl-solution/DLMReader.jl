
function buff_parser(res, lbuff, cc, nd, current_line, ::Type{T}) where T <: Integer
    # val = Base.tryparse_internal(T, lbuff, cc, nd, 10, false)
    # # hasvalue, val = ccall(:jl_try_substrtod, Tuple{Bool, Float64},
    # # (Ptr{UInt8},Csize_t,Csize_t), lbuff.data, cc-1, nd - cc +1)
    # # hasvalue ? res[current_line[]] = T(val) : res[current_line[]] = missing
    # val === nothing ? res[current_line[]] = missing : res[current_line[]] = val
    (x, code, startpos, value_len, total_len) = Parsers.xparse(T, lbuff, cc, nd)
    code == 33 ? res[current_line[]] = x : x = missing
end

function buff_parser(res, lbuff, cc, nd, current_line, ::Type{T}) where T <: Real
    # hasvalue, val = ccall(:jl_try_substrtod, Tuple{Bool, Float64},
    # (Ptr{UInt8},Csize_t,Csize_t), lbuff, cc-1, nd - cc +1)
    # hasvalue ? res[current_line[]] = val : res[current_line[]] = missing
    (x, code, startpos, value_len, total_len) = Parsers.xparse(T, lbuff, cc, nd)
    code == 33 ? res[current_line[]] = x : x = missing
end
# function buff_parser(res, lbuff, cc, nd, current_line, ::Type{Float32})
#     # hasvalue, val = ccall(:jl_try_substrtof, Tuple{Bool, Float32},
#     # (Ptr{UInt8},Csize_t,Csize_t), lbuff.data, cc-1, nd - cc +1)
#     # hasvalue ? res[current_line[]] = val : res[current_line[]] = missing
#     (x, code, startpos, value_len, total_len) = Parsers.xparse(Float32, lbuff, cc, nd)
#     code == 33 ? res[current_line[]] = x : x = missing
# end
function buff_parser(res, lbuff, cc, nd, current_line, ::Type{String})
    # (x, code, startpos, value_len, total_len) = Parsers.xparse(String, lbuff, cc, nd, Parsers.Options(ignoreemptylines=true))
    # code == 33 ? res[current_line[]] = x : x = missing
    l = nd - cc + 1
    l == 0 ? res[current_line[]] = missing : res[current_line[]] = unsafe_string(pointer(lbuff, cc), l)
end
# function buff_parser(res, lbuff, cc, nd, current_line, ::Type{T}) where T <: InlineString
#     (x, code, startpos, value_len, total_len) = Parsers.xparse(T, lbuff, cc, nd, Parsers.Options())
#     code == 33 ? res[current_line[]] = x : x = missing
# end
#
function (::Type{T})(buf::Vector{UInt8}, pos, len) where {T <: InlineString}
   if T === InlineString1
       sizeof(x) == 1 || WeakRefStrings.stringtoolong(T, sizeof(x))
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
    res[current_line[]] = T(lbuff, cc, nd-cc+1)
end
function buff_parser(res, lbuff, cc, nd, current_line, char_buff, ::Type{T}) where T <: Characters
    res[current_line[]] = T(lbuff, char_buff, cc, nd)
end
