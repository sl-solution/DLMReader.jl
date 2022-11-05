abstract type DLMERRORS end

# showing the first 20 columns with problems
struct DLMERRORS_PARSE <: DLMERRORS
    message::String
    function DLMERRORS_PARSE(buff, cols, res, track_problems_1, track_problems_2)
        loc = findall(track_problems_1)
        txt = "\n"
        for i in 1:min(length(loc), 20)
            txt *= "Column " * string(loc[i]) * " : " * string(cols[loc[i]]) * "::$(string(nonmissingtype(eltype(res[loc[i]]))))" 
            txt *= " : Read from buffer (\"" * unsafe_string(pointer(buff, track_problems_2[i].start), length(track_problems_2[i])) * "\")"
            txt *= "\n"
        end
        new(txt)
    end
end
struct DLMERRORS_LINE <: DLMERRORS
    message::String
    function DLMERRORS_LINE(buff, l_st, l_en, line_number, row_number, more)
        new("There might be $(more ? "more" : "less") observations in the input file at line $line_number (observation $row_number) than the number of columns in the output dataset.\n $(unsafe_string(pointer(buff, l_st), l_en - l_st + 1))")
    end
end

struct DLMERRORS_BUFFER <: DLMERRORS
    message::String
    function DLMERRORS_BUFFER(buff, l_st, l_en, res, cur_l, col)
        txt = "\n"
        last_col = min(length(col), 100)
        for j in 1:last_col
            txt *= string(col[j])
            txt *= "::" * string(nonmissingtype(eltype(res[j])))
            txt *= " = "
            txt *= string(res[j][cur_l])
            if j < last_col
                txt *= ", "
            else
                if last_col < length(col)
                    txt *= " ...(some warning messages are omitted) \n"
                else
                    txt *= "\n"
                end
            end
        end
        no_bytes = l_en - l_st + 1

        txt *= unsafe_string(pointer(buff, l_st), min(1000, no_bytes))
        if no_bytes > 1000
            txt *= " ...[the line buffer is truncated]"
        end
        new(txt)
    end
end

struct DLMERRORS_PARSE_ERROR <: DLMERRORS
    message::String
    function DLMERRORS_PARSE_ERROR(buff, l_st, l_en, res, cur_l, col, track_problems_1, track_problems_2, line_number, multiple_obs)
        # when multiple_obs = true, it is difficult to print out the line info
        if multiple_obs
            new("There are problems with parsing the input file for observation $cur_l : $(DLMERRORS_PARSE(buff, col, res, track_problems_1, track_problems_2).message) the values are set as missing.\n")
        else
            new("There are problems with parsing the input file at line $line_number (observation $cur_l) : $(DLMERRORS_PARSE(buff, col, res, track_problems_1, track_problems_2).message) the values are set as missing.\nMORE DETAILS: $(DLMERRORS_BUFFER(buff, l_st, l_en, res, cur_l, col).message)\n")
        end
    end
end

Base.show(io::IO, ::MIME"text/plain", err::DLMERRORS_PARSE_ERROR) = show(IOContext(io, :limit => true, :compact => true), "text/plain", err.message)
Base.show(io::IO, ::MIME"text/plain", err::DLMERRORS_LINE) = show(IOContext(io, :limit => true), "text/plain", err.message)

@noinline function PRINT_ERROR_TYPES_COLUMNS(x::Int, y::Int)::String
    string("Number of columns ", x, " and number of column names ", y, " are not matched")
end
@noinline function PRINT_ERROR_LINEBREAK(linebreak::Vector{UInt8})::String
    string("It is difficult to reach end of lines, either linebreak (current value : ",  Char.(linebreak), ") is not detected properly or `lsize` and/or `buffsize` are too small.")
end

function OUR_OPEN(path::Union{AbstractString, IOBuffer}; kwargs...)
    if path isa AbstractString
        open(path; kwargs...)
    elseif path isa IOBuffer
        path.readable = true
        path.writable = false
        path.seekable = true
        path.size = length(path.data)
        seek(path,0)
        # OUR_IOBUFF(path.data, 0)
    end
end

FILESIZE(f) = filesize(f)
FILESIZE(f::IOBuffer) = f.size

CLOSE(f) = close(f)
CLOSE(x::IOBuffer) = seek(x, 0)


function allocatecol_for_res(T, s)
    InMemoryDatasets._missings(T, s)
end

function  _our_resize!(x, n)
    resize!(x, n)
    fill!(x, missing)    
end

# it significantly improves the performance for very wide tables
function _resize_res_barrier!(res::Vector{<:AbstractVector}, types::Vector{DataType}, n::Int, threads::Bool)
    InMemoryDatasets.@_threadsfor threads for j in 1:length(res)
        @inbounds if types[j] === Int64
            _our_resize!(res[j]::Vector{Union{Missing,Int64}}, n)
        elseif types[j] === Float64
            _our_resize!(res[j]::Vector{Union{Missing,Float64}}, n)
        elseif types[j] === Bool
            _our_resize!(res[j]::Vector{Union{Missing,Bool}}, n)
        elseif types[j] === Date
            _our_resize!(res[j]::Vector{Union{Missing,Date}}, n)
        elseif types[j] === DateTime
            _our_resize!(res[j]::Vector{Union{Missing,DateTime}}, n)
        elseif types[j] === String
            _our_resize!(res[j]::Vector{Union{Missing,String}}, n)
        elseif types[j] === Int32
            _our_resize!(res[j]::Vector{Union{Missing,Int32}}, n)
        elseif types[j] === Float32
            _our_resize!(res[j]::Vector{Union{Missing,Float32}}, n)
        elseif types[j] === Int8
            _our_resize!(res[j]::Vector{Union{Missing,Int8}}, n)
        elseif types[j] === Int16
            _our_resize!(res[j]::Vector{Union{Missing,Int16}}, n)
        elseif types[j] === String1
            _our_resize!(res[j]::Vector{Union{Missing,String1}}, n)
        elseif types[j] === String3
            _our_resize!(res[j]::Vector{Union{Missing,String3}}, n)
        elseif types[j] === String7
            _our_resize!(res[j]::Vector{Union{Missing,String7}}, n)
        elseif types[j] === String15
            _our_resize!(res[j]::Vector{Union{Missing,String15}}, n)
        elseif types[j] === Characters{3}
            _our_resize!(res[j]::Vector{Union{Missing,Characters{3}}}, n)
        elseif types[j] === Characters{5}
            _our_resize!(res[j]::Vector{Union{Missing,Characters{5}}}, n)
        elseif types[j] === Characters{8}
            _our_resize!(res[j]::Vector{Union{Missing,Characters{8}}}, n)
        elseif types[j] === Characters{10}
            _our_resize!(res[j]::Vector{Union{Missing,Characters{10}}}, n)
        elseif types[j] === Characters{11}
            _our_resize!(res[j]::Vector{Union{Missing,Characters{11}}}, n)
        elseif types[j] === Characters{12}
            _our_resize!(res[j]::Vector{Union{Missing,Characters{12}}}, n)
        elseif types[j] === Characters{13}
            _our_resize!(res[j]::Vector{Union{Missing,Characters{13}}}, n)
        elseif types[j] === Characters{14}
            _our_resize!(res[j]::Vector{Union{Missing,Characters{14}}}, n)
        elseif types[j] === Characters{15}
            _our_resize!(res[j]::Vector{Union{Missing,Characters{15}}}, n)
        elseif types[j] === Characters{1}
            _our_resize!(res[j]::Vector{Union{Missing,Characters{1}}}, n)
        elseif types[j] === Characters{2}
            _our_resize!(res[j]::Vector{Union{Missing,Characters{2}}}, n)
        elseif types[j] === Characters{4}
            _our_resize!(res[j]::Vector{Union{Missing,Characters{4}}}, n)
        elseif types[j] === Characters{6}
            _our_resize!(res[j]::Vector{Union{Missing,Characters{6}}}, n)
        elseif types[j] === Characters{7}
            _our_resize!(res[j]::Vector{Union{Missing,Characters{7}}}, n)
        elseif types[j] === Characters{9}
            _our_resize!(res[j]::Vector{Union{Missing,Characters{9}}}, n)
        elseif types[j] === Characters{16}
            _our_resize!(res[j]::Vector{Union{Missing,Characters{16}}}, n)
        elseif types[j] === Time
            _our_resize!(res[j]::Vector{Union{Missing,Time}}, n)
        elseif types[j] === String31
            _our_resize!(res[j]::Vector{Union{Missing,String31}}, n)
        elseif types[j] === String63
            _our_resize!(res[j]::Vector{Union{Missing,String63}}, n)
        elseif types[j] === String127
            _our_resize!(res[j]::Vector{Union{Missing,String127}}, n)
        elseif types[j] === String255
            _our_resize!(res[j]::Vector{Union{Missing,String255}}, n)
        elseif types[j] === UInt8
            _our_resize!(res[j]::Vector{Union{Missing,UInt8}}, n)
        elseif types[j] === UInt16
            _our_resize!(res[j]::Vector{Union{Missing,UInt16}}, n)
        elseif types[j] === UInt32
            _our_resize!(res[j]::Vector{Union{Missing,UInt32}}, n)
        elseif types[j] === UInt64
            _our_resize!(res[j]::Vector{Union{Missing,UInt64}}, n)
        elseif types[j] === Int128
            _our_resize!(res[j]::Vector{Union{Missing,Int128}}, n)
        elseif types[j] === UInt128
            _our_resize!(res[j]::Vector{Union{Missing,UInt128}}, n)
        elseif types[j] === BigFloat
            _our_resize!(res[j]::Vector{Union{Missing,BigFloat}}, n)
        elseif types[j] === UUID
            _our_resize!(res[j]::Vector{Union{Missing,UUID}}, n)
        elseif types[j] === Symbol
            _our_resize!(res[j]::Vector{Union{Missing,Symbol}}, n)
        else # others are string
            _our_resize!(res[j]::Vector{Union{Missing,String}}, n)
        end
    end
end


@noinline function guess_eol_char(path)::Vector{UInt8}
    f = OUR_OPEN(path, read = true)

    LF = UInt8('\n')
    CR = UInt8('\r')

    a = Vector{UInt8}(undef, 8192)
    while !eof(f)
        nb = readbytes!(f, a)
        for i in 1:nb
            if a[i] == LF && i>1 && a[i-1] == CR
                CLOSE(f)
                return [CR, LF]
            elseif a[i] == LF
                CLOSE(f)
                return [LF]
            elseif a[i] == CR
                CLOSE(f)
                return [CR]
            end
        end
    end
    CLOSE(f)
    throw(ArgumentError("end of line is not detectable, set the `linebreak` argument manually"))
end


@noinline function read_multiple_lines(path, lo::Int, hi::Int, eol::Vector{UInt8}, howmany::Int)
    f = OUR_OPEN(path, read = true)
    cnt = 0
    try
        _tmp_line = Vector{UInt8}(undef, 8192)

        seek(f, max(0, lo - 1))

        eol_first = first(eol)
        eol_last = last(eol)
        eol_len = length(eol)


        l_len = 0
        _cond1_ = false
        _cond2_ = false
        while !eof(f)
            nb = readbytes!(f, _tmp_line)
            cur_position = position(f)
            if cur_position > hi
                last_nb = nb - (cur_position - hi)
            else
                last_nb = nb
            end
            i = 1
            while true
                # or i in eol_len:last_nb
                l_len += 1
                if _tmp_line[i] == eol_first
                    _cond1_ = true
                end
                if _tmp_line[i] == eol_last
                    _cond2_ = true
                end
                if _cond1_ && _cond2_
                    cnt += 1
                    if cnt >= howmany
                        CLOSE(f)
                        return (l_len, lo+l_len)
                    end
                    _cond1_ = false
                    _cond2_ = false
                end
                if _cond2_ && !_cond1_
                    _cond2_ = false
                end
                i += 1
                i > last_nb && break
            end
        end
        CLOSE(f)
        # length of line and position of file at the end of line
        # (l_len, lo+l_len)
        throw(ArgumentError("There are fewer than $(howmany) lines in the input file."))
    catch e
        CLOSE(f)
        rethrow(e)
    end
end

function read_one_line(path, lo::Int, hi::Int, eol::Vector{UInt8})::Tuple{Int, Int}
    f = OUR_OPEN(path, read = true)
    try
        _tmp_line = Vector{UInt8}(undef, 8192)

        seek(f, max(0, lo - 1))

        eol_first = first(eol)
        eol_last = last(eol)
        eol_len = length(eol)


        l_len = 0
        reached_eol = false
        while !eof(f)
            nb = readbytes!(f, _tmp_line)
            cur_position = position(f)
            if cur_position > hi
                last_nb = nb - (cur_position - hi)
            else
                last_nb = nb
            end
            l_len += eol_len-1
            for i in eol_len:last_nb
                l_len += 1
                if _tmp_line[i] == eol_last && _tmp_line[i - eol_len + 1] == eol_first
                    reached_eol = true
                    break
                end
            end
            reached_eol && break
        end
        CLOSE(f)
        # length of line and position of file at the end of line
        (l_len, lo+l_len-1)
    catch e
        CLOSE(f)
        rethrow(e)
    end
end

@noinline function estimate_linesize(path, eol::Vector{UInt8}, lsize::Int, lo::Int; guessingrows::Int = 20)::Int
    f = OUR_OPEN(path, read = true)
    try
        seek(f, max(0, lo-1))
        _tmp_line = Vector{UInt8}(undef, lsize*guessingrows)
        line_estimate = 0
        cnt = 1
        cnt_read_bytes = readbytes!(f, _tmp_line)
        eol_first = first(eol)
        eol_last = last(eol)
        eol_len = length(eol)

        l_len = 0
        for i in eol_len:cnt_read_bytes
            if _tmp_line[i] == eol_last && _tmp_line[i - eol_len + 1] == eol_first
                if l_len > line_estimate
                    line_estimate = l_len
                end
                cnt += 1
                cnt > guessingrows && break
                l_len = 0
            end
            l_len += 1
        end
        line_estimate
    catch e
        CLOSE(f)
        rethrow(e)
    end
end

@noinline function dist_calc(f, path, fs::Int, skip_bytes::Int, nt::Int, eol::Vector{UInt8}, eol_len::Int, eol_last::UInt8, eol_first::UInt8, limit::Int)
    cz = div(fs-skip_bytes, nt)
    lo = [(i-1)*cz+skip_bytes+1 for i in 1:nt]
    hi = [i*cz+skip_bytes for i in 1:nt]
    hi[end] = fs
    # lo[1] += skip_bytes
    cur_value = Vector{UInt8}(undef, eol_len)
    for i in 1:length(hi)-1
        seek(f, hi[i] - eol_len)
        for k in 1:eol_len
            cur_value[k] = read(f, UInt8)
        end
        if last(cur_value) != eol_last || first(cur_value) != eol_first
            while true
                if eol_len == 2
                    seek(f, position(f) - 1)
                end
                read!(f, cur_value)
                last(cur_value) == eol_last && first(cur_value) == eol_first && break
            end
            hi[i] = position(f)
            lo[i+1] = hi[i] + 1
        end
    end

    ns = fill(1, nt)
    if nt > 1
        Threads.@threads for i in 1:nt
            ns[i] = count_lines_of_file(path, lo[i], hi[i], eol)
        end
    else
        for i in 1:nt
            ns[i] = count_lines_of_file(path, lo[i], hi[i], eol; limit = limit)
        end
    end

    line_hi = cumsum(ns)
    if issorted(line_hi)
        last_chunk_to_read = searchsortedfirst(line_hi, limit)
    else
        throw(ArgumentError("The current buffer size and line size are too small increase them by setting `lsize` and `buffsize`"))
    end
   
    line_lo = [1; line_hi[1:end] .+ 1]
    line_lo, line_hi, lo, hi, ns, last_chunk_to_read
end

@noinline function count_lines_of_file(path, lo::Int, hi::Int, eol::Vector{UInt8}; limit::Int = typemax(Int))::Int
    f = OUR_OPEN(path, read = true)
    eol_last = last(eol)
    eol_first = first(eol)
    eol_len = length(eol)

    a = Vector{UInt8}(undef, 8192)
    nl = nb = 0
    cur_position = lo
    seek(f, max(0, lo-1))
    @inbounds while !eof(f) && cur_position <= hi
        nb = readbytes!(f, a)
        cur_position = position(f)
        if cur_position > hi
            last_nb = nb - (cur_position - hi)
        else
            last_nb = nb
        end
        if eol_len == 2 && cur_position != hi
            seek(f, cur_position - 1)
        end
        for i=eol_len:last_nb
            nl += (a[i] == eol_last && a[i - eol_len + 1] == eol_first)
            nl > limit && break
        end
        nl > limit && break
    end
    if eof(f) && nb > 0 && (a[nb] != eol_last || a[nb - eol_len + 1] != eol_first)
        nl += 1 # final line is not terminated with eol
    end
    CLOSE(f)
    nl
end

@noinline function skipto_fun(path, fsize, eol::Vector{UInt8}, skipto::Int)
    l_length = 0
    f_pos = 0
    if skipto != 1
        l_length, f_pos = read_multiple_lines(path, f_pos, fsize, eol, skipto-1)
    else
        f_pos = 0
    end
    l_length, f_pos
end

# correct type inference - only for DLMReader_Registered_Informats
@inline function get_informat_ptr(d::Dict{Symbol, Ptr{Nothing}}, s::Symbol)::Ptr{Nothing}
    d[s]
end

# correct type inference - only for error tracking
function change_true_tracker!(x::BitVector, j::Int)
    x[j] = true
    nothing
end
function change_loc_tracker!(x::Vector{UnitRange{Int}}, cur::Int, lo::Int, hi::Int)
    x[cur] = lo:hi
    nothing
end

@inline function find_end_of_line(buff::Vector{UInt8}, lo::Int, hi::Int, eol::Vector{UInt8})::Int
    eol_len = length(eol)
    last_eol = last(eol)
    first_eol = first(eol)

    @inbounds for i in (lo+eol_len-1):hi
        buff[i] == last_eol && buff[i - eol_len + 1] == first_eol && return i - eol_len
    end
    # couldn't find line break characters
    return hi
end

@inline function find_next_delim(buffer::Vector{UInt8}, lo::Int, hi::Int, dlm::Vector{UInt8}, dlmstr::Bool, ignorerepeated::Bool)::Tuple{Int, Int, Int}
    if dlmstr
        dlmstr_len = length(dlm)
        dlmstr_last = last(dlm)
        @inbounds for i in lo+dlmstr_len-1:hi
            if buffer[i] == dlmstr_last

                flag = true
                for j in 1:dlmstr_len-1
                    if buffer[i - j] != dlm[dlmstr_len - j]
                        flag = false
                        break
                    end
                end
                flag && return i,0,0
            end
        end
    else
        i = lo
        new_hi = hi
        @inbounds while true
            if buffer[i] in dlm
                new_hi = i-1
                while ignorerepeated
                    i += 1
                    i > hi && return i-1,0,new_hi
                    !(buffer[i] in dlm) && return i-1,0,new_hi
                end
                return i,0,0
            end
            i += 1
            i > hi && break
        end
    end
    return 0,0,0
end

# this needs refactoring
function find_next_delim(buffer::Vector{UInt8}, lo::Int, hi::Int, dlm::Vector{UInt8}, dlmstr::Bool, qut::UInt8, qutesc::UInt8, ignorerepeated::Bool)::Tuple{Int, Int, Int}
    new_lo = 0
    new_hi = 0
    if !dlmstr || length(dlm) == 1
        i = lo
        @inbounds while true
            if buffer[i] == qut
                if i>lo# && buffer[i-1] != qutesc
                    eoq_loc = find_next_quote(buffer, i+1, hi, qut, qutesc)
                    eoq_loc == 0 && return 0,0,0
                    new_lo = i+1
                    new_hi = eoq_loc-1
                    i = eoq_loc + 1
                elseif i == lo
                    eoq_loc = find_next_quote(buffer, i+1, hi, qut, qutesc)
                    eoq_loc == 0 && return 0,0,0
                    new_lo = i+1
                    new_hi = eoq_loc-1
                    i = eoq_loc + 1
                end
            end
            if buffer[i] in dlm
                if new_hi == 0
                    new_hi = i-1
                end
                while ignorerepeated
                    i += 1
                    i > hi && return i-1,new_lo, new_hi
                    !(buffer[i] in dlm) && return i-1,new_lo, new_hi
                end
                return i,new_lo,new_hi
            end
            i += 1
            i > hi && return 0,new_lo, new_hi
        end
    else
        dlmstr_len = length(dlm)
        dlmstr_last = last(dlm)
        i = lo
        # take care of the first few values
        @inbounds while true
            if buffer[i] == qut
                if i>lo #&& buffer[i-1] != qutesc
                    i > lo+dlmstr_len-1 && break
                    eoq_loc = find_next_quote(buffer, i+1, hi, qut, qutesc)
                    eoq_loc == 0 && return 0,0,0
                    new_lo = i+1
                    new_hi = eoq_loc-1
                    i = eoq_loc + 1
                elseif i == lo
                    eoq_loc = find_next_quote(buffer, i+1, hi, qut, qutesc)
                    eoq_loc == 0 && return 0,0,0
                    new_lo = i+1
                    new_hi = eoq_loc-1
                    i = eoq_loc + 1
                end
            end
            i += 1
            (i > lo+dlmstr_len-1 || i > hi) && break
        end
        i > hi && return 0,new_lo, new_hi
        @inbounds while true #for i in lo+dlmstr_len-1:hi
            if buffer[i] == qut
                eoq_loc = find_next_quote(buffer, i+1, hi, qut, qutesc)
                eoq_loc == 0 && return 0,0,0
                new_lo = i+1
                new_hi = eoq_loc-1
                i = eoq_loc + 1
            end

            if buffer[i] == dlmstr_last
                flag = true
                for j in 1:dlmstr_len-1
                    if buffer[i - j] != dlm[dlmstr_len - j]
                        flag = false
                        break
                    end
                end
                flag && return i, new_lo, new_hi
            end
            i += 1
            i > hi && return 0,0,0
        end
    end
    return 0,0,0
end

function find_next_quote(buffer::Vector{UInt8}, lo::Int, hi::Int, qut::UInt8, qutesc::UInt8)::Int
    @inbounds if qut !== qutesc
        for i in lo:hi
            buffer[i] == qut && buffer[i-1] != qutesc && return i
        end
    else
        q_cnt = 0
        for i in lo:hi-1
            if buffer[i] == qut
                q_cnt += 1
                if buffer[i+1] == qut

                else
                    isodd(q_cnt) && return i
                end
            end
        end
        buffer[hi] == qut && return hi
    end
    0
end

function clean_escapechar!(buffer::Vector{UInt8}, lo::Int, hi::Int, qut::UInt8)::Tuple{Int, Int}
    cnt = hi
    i = hi
    @inbounds while true
        if buffer[i] === qut
            buffer[cnt] = buffer[i]
            i -= 2
        else
            buffer[cnt] = buffer[i]
            i -= 1
        end
        cnt -= 1
        (cnt < lo || i < lo) && break
    end
    cnt+1, hi
end

@noinline function determine_nt(path::Union{AbstractString, IOBuffer}, f_pos::Int, end_of_read::Int, buffsize::Int, threads::Bool, lsize_estimate::Int, limit::Int)::Int
    skip_bytes = f_pos
    fs = end_of_read
    _check_nt_possible_size = div(fs - skip_bytes, buffsize)
    if !threads || fs - skip_bytes < 10^6 || div(fs - skip_bytes, Threads.nthreads()) < lsize_estimate || path isa IOBuffer || big(limit) * lsize_estimate < 10^7
        nt = 1
    else
        if _check_nt_possible_size > 0
            nt = min(Threads.nthreads(), _check_nt_possible_size)
        else
            nt = 1
        end
    end
    nt
end

# x is a vector that contains the location of buffer for parsing
@noinline function r_type_guess(x::Vector, buffer::LineBuffer, informat::Union{Nothing, Vector{Ptr{Nothing}}})
    if informat !== nothing
        apply_informat!(x, buffer, informat)
    end
    current_type = Int
    found, g_t = istype_detected(x, buffer, current_type)
    found && return g_t
    found, g_t = istype_detected(x, buffer, g_t)
    if found
        return g_t
    else
        return String
    end
end
@noinline function apply_informat!(x::Vector, buffer::LineBuffer, informat::Vector{Ptr{Nothing}})
    for xval in x
        if xval[1] != 0
            new_lo = xval[1]
            new_hi = xval[2]
            for ptrs in informat
                (new_lo, new_hi) = ccall(ptrs, Tuple{Int, Int}, (Vector{UInt8}, Int, Int), buffer.data, new_lo, new_hi)
            end
            xval = (new_lo, new_hi)
        end
    end
    nothing
end

@noinline function istype_detected(x::Vector, buffer::LineBuffer, ::Type{Int})::Tuple{Bool, DataType}
    cnt_missing = 0
    found = true
    for xval in x
        if xval[1] != 0
            val = tryparse(Int, view(buffer, xval[1]:xval[2]))
            if val === nothing
                for i in xval[1]:xval[2]
                    @inbounds if (buffer.data[i] != 0x20 && buffer.data[i] != 0x2e)
                        found = false    
                    end
                end
                cnt_missing += 1
            end
            !found && return false, Float64
        else
            cnt_missing += 1
        end
    end
    cnt_missing == length(x) && return true, String
    return true, Int
end

@noinline function istype_detected(x::Vector, buffer::LineBuffer, ::Type{Float64})::Tuple{Bool, DataType}
    cnt_missing = 0
    found = true
    for xval in x
        if xval[1] != 0
            # hasvalue, val = ccall(:jl_try_substrtod, Tuple{Bool, Float64}, (Ptr{UInt8},Csize_t,Csize_t), buffer.data, xval[1]-1, xval[2] - xval[1] +1)
            # val = InlineStrings.Parsers.xparse(Float64, buffer.data, Int(xval[1]), Int(xval[2]))
            hasvalue, val = typeparser(Float64, buffer.data, Int(xval[1]), Int(xval[2]))
            if !hasvalue
                for i in xval[1]:xval[2]
                    @inbounds if (buffer.data[i] != 0x20 && buffer.data[i] != 0x2e)
                        found = false    
                    end
                end
                cnt_missing += 1
            end
            !found && return false, String
        else
            cnt_missing += 1
        end
    end
    cnt_missing == length(x) && return true, String
    return true, Float64
end

@noinline function fill_column_name!(colnames::Vector{Symbol},
    header::Bool,
    path::Union{AbstractString, IOBuffer},
    start_of_read::Int,
    end_of_read::Int,
    n_cols::Int,
    linebreak::Vector{UInt8},
    delimiter::Vector{UInt8},
    buffsize::Int,
    fixed::Union{Nothing, Vector{UnitRange{Int}}},
    dlmstr::Bool,
    escapechar::Union{Nothing, UInt8},
    quotechar::Union{Nothing, UInt8},
    ignorerepeated::Bool,
    skipto::Int,
    limit::Int,
    line_informat::Union{Nothing, Vector{Ptr{Nothing}}},
    emptycolname::Bool
    )

    total_line_skipped = skipto - 1 + Int(header)
    if !header && isempty(colnames)
        append!(colnames, [Symbol("x" * string(k)) for k in 1:n_cols])
    elseif header
        _lvarnames, f_pos = read_one_line(path, start_of_read+1, end_of_read, linebreak)
        # one_extra column to keep the start and end of the line for warning reporting
        res = Matrix{Tuple{UInt32, UInt32}}(undef, 1, n_cols+1)

        # check that returned buffer has not been reused inside readfile_chunk_no_parse
        @assert f_pos - start_of_read + 1 < buffsize "the input file is very wide, you must increase the buffsize/lsize"
        cnt_read_bytes, buffer = readfile_chunk_no_parse!(res, 1, path, n_cols, start_of_read+1, f_pos, colnames, delimiter, linebreak, buffsize, fixed, dlmstr, escapechar, quotechar, 0, false, ignorerepeated , false, limit, line_informat, total_line_skipped)
        cnter = 1
        for i in 1:n_cols
            if res[1, i][1] == 0 || res[1, i][1] > res[1, i][2]
                if emptycolname
                    push!(colnames, Symbol("NONAME"*string(cnter)))
                    cnter += 1
                else
                    throw(ArgumentError("the column name inference is not valid, if the file is very wide, increase `buffsize` and `lsize`, otherwise, setting `header = false` or `emptycolname = true` may resolve the issue."))
                end
            else
                newsub = STRIP!(_SUBSTRING_(buffer, res[1,i][1]:res[1,i][2]))
                if isequal(newsub, " ")
                    if emptycolname
                        push!(colnames, Symbol("NONAME"*string(cnter)))
                        cnter += 1
                    else
                        throw(ArgumentError("the column name inference is not valid, if the file is very wide, increase `buffsize` and `lsize`, otherwise, setting `header = false` or `emptycolname = true` may resolve the issue."))
                    end
                else
                    push!(colnames, Create_Symbol(newsub.string.data, newsub.lo, newsub.hi))
                end            
            end    
        end
    end
    nothing
end

function Create_Symbol(a::Vector{UInt8}, st::Int, en::Int)
    return ccall(:jl_symbol_n, Ref{Symbol}, (Ptr{UInt8}, Int),
                 pointer(a, st), en-st+1)
end

_todate(s::AbstractString) = DateFormat(s)
_todate(s::DateFormat) = s
_todate(::Any) = throw(ArgumentError("DateFormat must be a string or a DateFormat"))

@noinline function allocate_charbuff_df(types::Vector{DataType}, dtformat::Dict{Int, <:DateFormat}, fixed_dtformat)
    charbuff = Vector{UInt8}[]
    if !isempty(dtformat)
        dtfmt = Vector{valtype(dtformat)}()
    else
        dtfmt = Vector{typeof(_todate(fixed_dtformat))}()
    end
    for j in 1:length(types)
        if types[j] <: Characters
            if types[j] == Characters
                types[j] = Characters{8}
                push!(charbuff, Vector{UInt8}(undef, 8))
            else
                types[j] = Characters{sizeof(types[j])}
                push!(charbuff, Vector{UInt8}(undef, sizeof(types[j])))
            end
        elseif types[j] <: TimeType
            if !isempty(dtformat)
                push!(dtfmt, _todate(get(dtformat, j, ISODateFormat)))
            else
                push!(dtfmt, _todate(fixed_dtformat))
            end
        end
    end
    charbuff, dtfmt
end

function parse_eachrow(problems::Vector{Bool}, ::Type{T}, x::Vector, buffer::LineBuffer, idx::Matrix{Tuple{UInt32, UInt32}}, j::Int, informat::Union{Nothing, Vector{Ptr{Nothing}}}, df, char_buff, int_bases::Int, string_trim::Bool, threads::Bool) where T
    InMemoryDatasets.@_threadsfor threads for i in 1:length(x)
        if idx[i, j][1] == 0
            x[i] =  missing
        else
            new_lo::Int = idx[i,j][1]
            new_hi::Int = idx[i,j][2]
            if informat !== nothing
                # if informat !== nothing, it is a pointer
                for ptrs in informat
                    (new_lo, new_hi) = ccall(ptrs, Tuple{Int, Int}, (Vector{UInt8}, Int, Int), buffer.data, new_lo, new_hi)
                end
                idx[i,j] = (new_lo, new_hi)
            end
            if char_buff !== nothing
                charbuff = char_buff[Threads.threadid()]
            else
                charbuff = nothing
            end

            x[i] = buff_parser_ind(problems, i, buffer, Int(new_lo), Int(new_hi), df, charbuff, int_bases, string_trim, T)
        end
    end
    nothing
end

# this function is used for error reporting
# we don't need to apply informat in this case, because in the first round informat has been already applied
@noinline function parse_one_row(outds, row_number, types, buffer::LineBuffer, idx::Matrix{Tuple{UInt32, UInt32}}, informat, dtformat, char_buff::Vector{Vector{UInt8}}, int_bases, string_trim)
    dt_cnt::Int = 1
    c_cnt::Int = 1
    track_problems_1 = falses(ncol(outds))
    track_problems_2 = [0:0 for _ in 1:20]
    problems = Bool[false]
    track_cnter = 1
    for j in 1:length(types)
        if types[j] <: TimeType
            df = dtformat[dt_cnt]
            dt_cnt+=1
        else
            df = nothing
        end
        if types[j] <: Characters
            charbuff = char_buff[c_cnt]
            c_cnt += 1
        else
            charbuff = nothing
        end
       
        if int_bases !== nothing
            int_base = get(int_bases, j, 10)
        else
            int_base = 10
        end
        if idx[row_number, j][1] != 0
            new_lo = idx[row_number,j][1]
            new_hi = idx[row_number,j][2]
            problems[1] = false
            res = buff_parser_ind(problems, 1, buffer, Int(new_lo), Int(new_hi), df, charbuff, int_base, string_trim, types[j])
            if problems[1]
                track_problems_1[j] = true
                if track_cnter < 21
                    track_problems_2[track_cnter] = Int(new_lo):Int(new_hi)
                    track_cnter += 1
                end
            end
        end
    end
    track_problems_1, track_problems_2
end

function parse_eachrow_of_dataset!(outds::Dataset, types::Vector{DataType}, buffer::LineBuffer, res_idx::Matrix{Tuple{UInt32, UInt32}}, informat::Union{Nothing, Dict{Int, Vector{Ptr{Nothing}}}}, dtformat, char_buff::Vector{Vector{UInt8}}, int_bases::Union{Nothing, Dict{Int, Int}}, string_trim::Bool, threads::Bool, warn::Int, total_line_skipped::Int, multiple_obs::Bool)
    dt_cnt::Int = 1
    c_cnt::Int = 1
    problems = zeros(Bool, nrow(outds))
    for i in 1:length(types)
        if types[i] <: TimeType
            df = dtformat[dt_cnt]
            dt_cnt+=1
        else
            df = nothing
        end
        if types[i] <: Characters
            charbuff::Vector{UInt8} = char_buff[c_cnt]
            charbuff_threads = [deepcopy(charbuff) for _ in 1:Threads.nthreads()]
            c_cnt += 1
        else
            charbuff_threads = nothing
        end
        if informat !== nothing
            infmt = get(informat, i, nothing)
        else
            infmt = nothing
        end
        if int_bases !== nothing
            int_base = get(int_bases, i, 10)
        else
            int_base = 10
        end
        parse_eachrow(problems, types[i], InMemoryDatasets._columns(outds)[i], buffer, res_idx, i, infmt, df, charbuff_threads, int_base, string_trim, threads)
    end
    # the last column contains the information about the line start and end location
    if any(problems)
        cnt_error = 1
        err_index = 0
        while true
            cnt_error > warn && break
            err_index = findnext(problems, err_index+1)
            if err_index === nothing
                break
            else
                track_problems_1, track_problems_2 = parse_one_row(outds, err_index, types, buffer, res_idx, informat, dtformat, char_buff, int_bases, string_trim)
                @warn DLMERRORS_PARSE_ERROR(buffer.data, res_idx[err_index, length(types)+1][1],res_idx[err_index, length(types)+1][2], InMemoryDatasets._columns(outds), err_index, propertynames(outds), track_problems_1, track_problems_2, err_index + total_line_skipped, multiple_obs).message
            end
            cnt_error += 1
        end
    end

    nothing
end
