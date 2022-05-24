abstract type DLMERRORS end

# showing the first 20 columns with problems
struct DLMERRORS_PARSE <: DLMERRORS
    message::String
    function DLMERRORS_PARSE(buff, cols, res, track_problems)
        loc = findall(track_problems[1])
        txt = "\n"
        for i in 1:min(length(loc), 20)
            txt *= "Column " * string(loc[i]) * " : " * string(cols[loc[i]]) * "::$(string(nonmissingtype(eltype(res[loc[i]]))))" 
            txt *= " : Read from buffer (\"" * unsafe_string(pointer(buff, track_problems[2][i].start), length(track_problems[2][i])) * "\")"
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
    function DLMERRORS_PARSE_ERROR(buff, l_st, l_en, res, cur_l, col, track_problems, line_number)
        new("There are problems with parsing the input file at line $line_number (observation $cur_l) : $(DLMERRORS_PARSE(buff, col, res, track_problems).message) the values are set as missing.\nMORE DETAILS: $(DLMERRORS_BUFFER(buff, l_st, l_en, res, cur_l, col).message)\n")
    end
end

Base.show(io::IO, ::MIME"text/plain", err::DLMERRORS_PARSE_ERROR) = show(IOContext(io, :limit => true, :compact => true), "text/plain", err.message)
Base.show(io::IO, ::MIME"text/plain", err::DLMERRORS_LINE) = show(IOContext(io, :limit => true), "text/plain", err.message)

function allocatecol_for_res(T, s)
    InMemoryDatasets._missings(T, s)
end

function find_end_of_line(buff, lo, hi, eol)
    eol_len = length(eol)
    last_eol = last(eol)
    first_eol = first(eol)

    @inbounds for i in (lo+eol_len-1):hi
        buff[i] == last_eol && buff[i - eol_len + 1] == first_eol && return i - eol_len
    end
    # couldn't find line break characters
    return hi
end

function find_next_delim(buffer, lo, hi, dlm, dlmstr, ignorerepeated)
    if dlmstr === nothing
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
    else
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
    end
    return 0,0,0
end

# this needs refactoring
function find_next_delim(buffer, lo, hi, dlm, dlmstr, qut, qutesc, ignorerepeated)
    new_lo = 0
    new_hi = 0
    if dlmstr === nothing || length(dlm) == 1
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

function find_next_quote(buffer, lo, hi, qut, qutesc)
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

function clean_escapechar!(buffer, lo, hi, qut, qutesc)
    cnt = hi
    i = hi
    flag = false
    @inbounds while true
        if buffer[i] === qut
            buffer.data[cnt] = buffer.data[i]
            i -= 2
        else
            buffer.data[cnt] = buffer.data[i]
            i -= 1
        end
        cnt -= 1
        (cnt < lo || i < lo) && break
    end
    cnt+1, hi
end

# when eol is \r\n
function find_next_delim_or_end_of_line(buffer, field_start, dlm, eol::Vector{UInt8})
    @inbounds for i in field_start:length(buffer)
        if buffer[i] in dlm
            return false, i
        elseif buffer[i] == eol[1] && buffer[i+1] == eol[2]
            return true, i+1
        end
    end
    return true, length(buffer)
end

function check_if_a_buffer_has_end_of_line(buff, lo, hi, eol::UInt8)
    for i in lo:hi
        buff[i] == eol && return true,i
    end
    return false,0
end
function check_if_a_buffer_has_end_of_line(buff, lo, hi, eol::Vector{UInt8})
    for i in lo:hi-1
        buff[i] == eol[1] && buff[i+1] == eol[2]  && return true,i
    end
    return false,0
end


function dist_calc(f, path, fs, skip_bytes, nt, eol, eol_len, eol_last, eol_first, limit)
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


function _find_how_many_dlm(headerl, dlm)
    cnt = 1
    for c in headerl
        c in dlm ? cnt += 1 : nothing
    end
    cnt
end

function tryparse_with_missing(T, x, infmt)
    ismissing(x) && return 1
    _tmp = LineBuffer(collect(codeunits(x)))
    lo = 1
    hi = length(x)
    if infmt !== identity
        infmt(_SUBSTRING_(_tmp, lo:hi))
    end
    flag = true
    @simd for i in lo:hi
        @inbounds if (_tmp.data[i] == 0x20 || _tmp.data[i] == 0x2e)
            flag &= true
        else
            flag &= false
        end
    end
    flag && return 1
    ismissing(_tmp) ? 1 : Int(tryparse(T, _tmp) !== nothing)
end

function r_type_guess(x, infmt)
    T = Int
    flag = true
    for i in 1:length(x)
        res = tryparse_with_missing(T, x[i], infmt)
        if res == 0
            flag = false
            break
        end
    end
    flag && return T
    T = Float64
    flag = true
    for i in 1:length(x)
        res = tryparse_with_missing(T, x[i], infmt)
        if res == 0
            flag = false
            break
        end
    end
    flag && return T
    return String
end



function count_lines_of_file(path, lo, hi, eol; limit = typemax(Int))
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


function estimate_linesize(path, eol, lsize, lo; guessingrows = 20)
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

function read_one_line(path, lo, hi, eol)
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

# we assume eol is maximum 2 characters
function read_multiple_lines(path, lo, hi, eol, howmany)
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


function _generate_colname_based(path, eol, lo, hi, lsize, types, delimiter, linebreak, buffsize, colwidth, dlmstr, quotechar, escapechar, autogen, ignorerepeated, multiple_obs, line_informat, total_line_skipped)
    _lvarnames, f_pos = read_one_line(path, lo, hi, eol)
    _varnames = [Vector{Union{String, Missing}}(undef, 1) for _ in 1:length(types)]
    readfile_chunk!(_varnames, 1,1, [], path, repeat([String], length(types)), 1, lo, f_pos, nothing; delimiter = delimiter, linebreak = linebreak, buffsize = buffsize, fixed = colwidth, dlmstr = dlmstr, quotechar = quotechar, escapechar = escapechar, ignorerepeated = ignorerepeated, multiple_obs = multiple_obs, line_informat = line_informat, total_line_skipped = total_line_skipped)
    varnames = Vector{String}(undef, length(types))
    cnter = 1
    for i in 1:length(_varnames)

        if ismissing(_varnames[i][1])
            if autogen
                varnames[i] = "NONAME"*string(cnter)
                cnter += 1
            else
                throw(ArgumentError("the variable name inference is not valid, setting `header = false` may solve the issue."))
            end
        else
            varnames[i] = _varnames[i][1]
        end
    end
    f_pos, Symbol.(strip.(varnames))
end

function guess_eol_char(path)
    f = OUR_OPEN(path, read = true)

    LF = UInt8('\n')
    CR = UInt8('\r')

    a = Vector{UInt8}(undef, 8192)
    while !eof(f)
        nb = readbytes!(f, a)
        for i in 1:nb
            if a[i] == LF && i>1 && a[i-1] == CR
                CLOSE(f)
                return ['\r', '\n']
            elseif a[i] == LF
                CLOSE(f)
                return '\n'
            end
        end
    end
    CLOSE(f)
    throw(ArgumentError("end of line is not detectable, set `linebreak` argument manually"))
end


_todate(s::AbstractString) = DateFormat(s)
_todate(s::DateFormat) = s
_todate(::Any) = throw(ArgumentError("DateFormat must be a string or a DateFormat"))

function OUR_OPEN(path; kwargs...)
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

# correct type inference - only for DLMReader_Registered_Informats
@inline function get_informat_ptr(d::Dict{Symbol, Ptr{Nothing}}, s::Symbol)::Ptr{Nothing}
    d[s]
end