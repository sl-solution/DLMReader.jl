function buff_parser(res, lbuff::LineBuffer, cc::Int, nd::Int, current_line::Int, df, ::Type{T}) where  T <: TimeType
    flag = 0
    if cc > nd
        val = nothing
    else
        val = Dates.tryparsenext_internal(T, lbuff, cc, nd, df, false)
    end

    if val === nothing
        for i in cc:nd
            @inbounds if (lbuff.data[i] != 0x20 && lbuff.data[i] != 0x2e)
                flag = 1

            end
        end
        res[current_line] = missing
    else
        if Dates.validargs(T, val[1]...) === nothing
            res[current_line] = T(val[1]...)
        else
            res[current_line] = missing
            flag = 1
        end
    end
    flag
end


function buff_parser(res, lbuff::LineBuffer, cc::Int, nd::Int, current_line::Int, ::Type{T}; base::Int = 10) where T <: Integer
    val = Base.tryparse_internal(T, lbuff, cc, nd, base, false)
    flag = 0
    if val === nothing
        for i in cc:nd
            @inbounds if (lbuff.data[i] != 0x20 && lbuff.data[i] != 0x2e)
                flag = 1

            end
        end
        res[current_line] = missing
    else
        res[current_line] = val
    end
    flag
end
function buff_parser(res, lbuff::Vector{UInt8}, cc::Int, nd::Int, current_line::Int, ::Type{T}) where T <: Real
    # hasvalue, val = ccall(:jl_try_substrtod, Tuple{Bool, Float64},
    # (Ptr{UInt8},Csize_t,Csize_t), lbuff, cc-1, nd - cc +1)
    # related to DLMReader issue #5
    # val = InlineStrings.Parsers.xparse(T, lbuff, cc, nd)
    hasvalue, val = typeparser(T, lbuff, cc, nd)
    flag = 0
    if hasvalue
        res[current_line] = val
    else
        for i in cc:nd
            @inbounds if (lbuff[i] != 0x20 && lbuff[i] != 0x2e)
                flag = 1

            end
        end
        res[current_line] = missing
    end
    flag
end
# function buff_parser(res, lbuff, cc, nd, current_line, ::Type{Float32})
#     hasvalue, val = ccall(:jl_try_substrtof, Tuple{Bool, Float32},
#     (Ptr{UInt8},Csize_t,Csize_t), lbuff, cc-1, nd - cc +1)
#     flag = 0
#     if hasvalue
#         res[current_line] = val
#     else
#         for i in cc:nd
#             @inbounds if (lbuff[i] != 0x20 && lbuff[i] != 0x2e)
#                 flag = 1

#             end
#         end
#         res[current_line] = missing
#     end
#     flag
# end

function buff_parser(res, lbuff::Vector{UInt8}, cc::Int, nd::Int, current_line::Int, ::Type{BigFloat})
    newlo = cc
    newhi = nd
    for i in cc:nd
        lbuff[i] == 0x20 ? newlo += 1 : break
    end
    for i in nd:-1:newlo
        lbuff[i] == 0x20 ? newhi -= 1 : break
    end
    if newhi-newlo+1 == 0
        res[current_line] = missing
        return 0
    end
    z = BigFloat(precision=Base.MPFR.DEFAULT_PRECISION[])
    err = ccall((:mpfr_set_str, :libmpfr), Int32, (Ref{BigFloat}, Cstring, Int32, Base.MPFR.MPFRRoundingMode), z, SubString(lbuff, newlo, newhi), 0, Base.MPFR.ROUNDING_MODE[])
    if err == 0
        res[current_line] = z
        return 0
    else
        res[current_line] = missing
        return 1
    end
end

function buff_parser(res, lbuff, cc, nd, current_line, ::Type{String})
    l = nd - cc + 1
    cnt = 0
    for i in cc:nd
        cnt += lbuff[i] === 0x20
    end
    l == 0 || l == cnt ? res[current_line] = missing : res[current_line] = unsafe_string(pointer(lbuff, cc), l)
    return 0

end

function buff_parser(res, lbuff, cc, nd, current_line, trim, ::Type{String})
    newlo = cc
    newhi = nd
    for i in nd:-1:cc
        lbuff[i] == 0x20 ? newhi -= 1 : break
    end
    l = newhi - newlo + 1
    l == 0 ? res[current_line] = missing : res[current_line] = unsafe_string(pointer(lbuff, cc), l)
    return 0
end


function buff_parser(res, lbuff, cc, nd, current_line, ::Type{Bool})
    flag = 0
    newlo = cc
    newhi = nd
    for i in cc:nd
        lbuff[i] == 0x20 ? newlo += 1 : break
    end
    for i in nd:-1:newlo
        lbuff[i] == 0x20 ? newhi -= 1 : break
    end
    if length(newlo:newhi) == 1
        if lbuff[newlo] == 0x30
            res[current_line] = false
        elseif lbuff[newlo] == 0x31
            res[current_line] = true
        else
            res[current_line] = missing
            flag = 1
        end
    elseif length(newlo:newhi) == 0
        res[current_line] = missing
    else
        res[current_line] = missing
        flag = 1
    end

    return flag

end

function buff_parser(res, lbuff, cc, nd, current_line, ::Type{T}) where T <: InlineString
    if cc>nd
        res[current_line] = missing
    else
        l = nd - cc + 1
        cnt = 0
        for i in cc:nd
            cnt += lbuff[i] === 0x20
        end
        l == cnt ? res[current_line] = missing : res[current_line] = T(lbuff, cc, nd-cc+1)
    end
    return 0
end


function buff_parser(res, lbuff, cc, nd, current_line, char_buff, ::Type{T}) where T <: Characters
    if cc>nd
        res[current_line] = missing
    else
        l = nd - cc + 1
        cnt = 0
        for i in cc:nd
            cnt += lbuff[i] === 0x20
        end
        l == cnt ? res[current_line] = missing : res[current_line] = T(lbuff, char_buff, cc, nd)
    end
    return 0
end


function buff_parser(res, buffer, cc, nd, current_line, ::Type{T}) where T <: UUID
    flag = 0
    if cc>nd
        res[current_line] = missing
    else
        val = Base.tryparse(UUID, view(buffer, cc:nd))
        if val === nothing
            for i in cc:nd
                @inbounds if (buffer.data[i] != 0x20 && buffer.data[i] != 0x2e)
                    flag = 1
                end
            end
            res[current_line] = missing
        else
            res[current_line] = val
        end
        flag
    end
end


function buff_parser(res, lbuff, cc, nd, current_line, char_buff, ::Type{T}) where T <: DT
    if cc>nd
        nothing
    else
        copyto!(res, crrent_line, lbuff, cc, min(strlength(T), nd - cc +1))
    end
    return 0
end

### for byrow 

function buff_parser_ind(problems, p_idx, lbuff, cc, nd, df, charbuff, base, trim, ::Type{T}) where  T <: TimeType
    flag = false
    if cc > nd
        val = nothing
    else
        val = Dates.tryparsenext_internal(T, lbuff, cc, nd, df, false)
    end

    if val === nothing
        for i in cc:nd
            @inbounds if (lbuff.data[i] != 0x20 && lbuff.data[i] != 0x2e)
                flag = true
            end
        end
        res = missing
    else
        if Dates.validargs(T, val[1]...) === nothing
            res = T(val[1]...)
        else
            res =  missing
            flag = true
        end
    end
    problems[p_idx] |= flag
    res
    # flag
end


function buff_parser_ind(problems, p_idx, lbuff::LineBuffer, cc::Int, nd::Int, df, charbuff, base::Int, trim, ::Type{T}) where T <: Integer
    val = Base.tryparse_internal(T, lbuff, cc, nd, base, false)
    flag = false
    if val === nothing
        for i in cc:nd
            @inbounds if (lbuff.data[i] != 0x20 && lbuff.data[i] != 0x2e)
                flag = true
            end
        end
        res = missing
    else
        res = val
    end
    problems[p_idx] |= flag
    res
end
function buff_parser_ind(problems, p_idx, lbuff, cc, nd, df, charbuff, base, trim, ::Type{T}) where T <: Real
    # hasvalue, val = ccall(:jl_try_substrtod, Tuple{Bool, Float64},
    # (Ptr{UInt8},Csize_t,Csize_t), lbuff, cc-1, nd - cc +1)
    # related to DLMReader issue #5
    # val = InlineStrings.Parsers.xparse(T, lbuff.data, cc, nd)
    hasvalue, val = typeparser(T, lbuff.data, cc, nd)
    flag = false
    if hasvalue
        res = val
    else
        for i in cc:nd
            @inbounds if (lbuff.data[i] != 0x20 && lbuff.data[i] != 0x2e)
                flag = true
            end
        end
        res = missing
    end
    problems[p_idx] |= flag
    res
end

function buff_parser_ind(problems, p_idx, lbuff, cc, nd, df, charbuff, base, trim, ::Type{BigFloat})
    flag = false
    newlo = cc
    newhi = nd
    for i in cc:nd
        lbuff[i] == 0x20 ? newlo += 1 : break
    end
    for i in nd:-1:newlo
        lbuff[i] == 0x20 ? newhi -= 1 : break
    end
    if newhi-newlo+1 == 0
        res = missing
    end
    z = BigFloat(precision=Base.MPFR.DEFAULT_PRECISION[])
    err = ccall((:mpfr_set_str, :libmpfr), Int32, (Ref{BigFloat}, Cstring, Int32, Base.MPFR.MPFRRoundingMode), z, SubString(lbuff, newlo, newhi), 0, Base.MPFR.ROUNDING_MODE[])
    if err == 0
        res = z
    else
        res = missing
        flag = true
    end
    problems[p_idx] |= flag
    res
end

function buff_parser_ind(problems, p_idx, lbuff, cc, nd, df, charbuff, base, trim, ::Type{String})
    if trim
        newlo = cc
        newhi = nd
        for i in nd:-1:cc
            lbuff.data[i] == 0x20 ? newhi -= 1 : break
        end
        l = newhi - newlo + 1
        if l == 0
            res = missing 
        else
            res = unsafe_string(pointer(lbuff.data, cc), l)
        end
    else
        l = nd - cc + 1
        cnt = 0
        for i in cc:nd
            cnt += lbuff.data[i] === 0x20
        end
        if l == 0 || l == cnt
            res = missing
        else
            res = unsafe_string(pointer(lbuff.data, cc), l)
        end
    end
    problems[p_idx] |= false
    res
end


function buff_parser_ind(problems, p_idx, lbuff, cc, nd, df, charbuff, base, trim, ::Type{Bool})
    flag = false
    newlo = cc
    newhi = nd
    for i in cc:nd
        lbuff.data[i] == 0x20 ? newlo += 1 : break
    end
    for i in nd:-1:newlo
        lbuff.data[i] == 0x20 ? newhi -= 1 : break
    end
    if length(newlo:newhi) == 1
        if lbuff.data[newlo] == 0x30
            res = false
        elseif lbuff.data[newlo] == 0x31
            res = true
        else
            res = missing
            flag = true
        end
    elseif length(newlo:newhi) == 0
       res = missing
    else
        res = missing
        flag = true
    end
    problems[p_idx] |= flag
    res
end

function buff_parser_ind(problems, p_idx, lbuff, cc, nd, df, charbuff, base, trim, ::Type{T}) where T <: InlineString
    if cc>nd
        res = missing
    else
        l = nd - cc + 1
        cnt = 0
        for i in cc:nd
            cnt += lbuff.data[i] === 0x20
        end
        if l == cnt
            res = missing 
        else
            res = T(lbuff.data, cc, nd-cc+1)
        end
    end
    problems[p_idx] |= false
    res
end


function buff_parser_ind(problems, p_idx, lbuff, cc, nd, df, charbuff, base, trim, ::Type{T}) where T <: Characters
    if cc>nd
        res = missing
    else
        l = nd - cc + 1
        cnt = 0
        for i in cc:nd
            cnt += lbuff.data[i] === 0x20
        end
        if l == cnt 
            res = missing
        else
            res = T(lbuff.data, charbuff, cc, nd)
        end
    end
    problems[p_idx] |= false
    res
end


function buff_parser_ind(problems, p_idx, buffer, cc, nd, df, charbuff, base, trim, ::Type{T}) where T <: UUID
    flag = false
    if cc>nd
        res = missing
    else
        val = Base.tryparse(UUID, view(buffer, cc:nd))
        if val === nothing
            for i in cc:nd
                @inbounds if (buffer.data[i] != 0x20 && buffer.data[i] != 0x2e)
                    flag = true
                end
            end
            res = missing
        else
            res = val
        end
    end
    problems[p_idx] |= flag
    res
end
