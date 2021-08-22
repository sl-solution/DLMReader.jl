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

function find_next_delim(buffer, lo, hi, dlm, dlmstr)
    if dlmstr === nothing
        @inbounds for i in lo:hi
            buffer[i] in dlm && return i
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
                flag && return i
            end
        end
    end
    return 0
end


# when eol is \r\n
@inline function find_next_delim_or_end_of_line(buffer, field_start, dlm, eol::Vector{UInt8})
    @inbounds for i in field_start:length(buffer)
        if buffer[i] in dlm
            return false, i
        elseif buffer[i] == eol[1] && buffer[i+1] == eol[2]
            return true, i+1
        end
    end
    return true, length(buffer)
end

@inline function check_if_a_buffer_has_end_of_line(buff, lo, hi, eol::UInt8)
    for i in lo:hi
        buff[i] == eol && return true,i
    end
    return false,0
end
@inline function check_if_a_buffer_has_end_of_line(buff, lo, hi, eol::Vector{UInt8})
    for i in lo:hi-1
        buff[i] == eol[1] && buff[i+1] == eol[2]  && return true,i
    end
    return false,0
end



# function move_cursor(eol_reached, dlm_pos, dlm, eol)
#     eol_reached ? return dlm_pos+length(eol) : return dlm_pos + length(dlm)
# end


@inline function _find_how_many_dlm(headerl, dlm)
    cnt = 1
    for c in headerl
        c in dlm ? cnt += 1 : nothing
    end
    cnt
end

tryparse_with_missing(T, x) = ismissing(x) ? nothing : tryparse(T, x)

function count_lines_of_file(path, lo, hi, eol)
    f = open(path, "r")
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
        end
    end
    if eof(f) && nb > 0 && (a[nb] != eol_last || a[nb - eol_len + 1] != eol_first)
        nl += 1 # final line is not terminated with eol
    end
    close(f)
    nl
end


function estimate_linesize(path, eol, lsize; guessingrows = 20)
    f = open(path, "r")
    try
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
        close(f)
        rethrow(e)
    end
end

function read_one_line(path, lo, hi, eol)
    f = open(path, "r")
    try
        _tmp_line = Vector{UInt8}(undef, 8192)

        seek(f, max(0, lo - 1))

        eol_first = first(eol)
        eol_last = last(eol)
        eol_len = length(eol)

        f_pos = 0

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
            for i in eol_len:last_nb
                if _tmp_line[i] == eol_last && _tmp_line[i - eol_len + 1] == eol_first
                    l_len = i
                    reached_eol = true
                    break
                end
            end
            reached_eol && break
        end
        close(f)
        # length of line and position of file at the end of line
        (l_len, lo+l_len-1)
    catch e
        close(f)
        rethrow(e)
    end
end


function _generate_colname_based(path, eol, lo, hi, lsize, types, delimiter, linebreak, buffsize, colwidth, dlmstr)
    _lvarnames, f_pos = read_one_line(path, lo, hi, eol)
    _varnames = [Vector{Union{String, Missing}}(undef, 1) for _ in 1:length(types)]
    readfile_chunk!(_varnames, 1,1, [], path, repeat([String], length(types)), 1, lo, f_pos; delimiter = delimiter, linebreak = linebreak, buffsize = buffsize, fixed = colwidth, dlmstr = dlmstr)
    varnames = Vector{String}(undef, length(types))
    for i in 1:length(_varnames)
        ismissing(_varnames[i][1]) && throw(ArgumentError("the variable name inference is not valid, setting `header = false` may solve the issue."))
        varnames[i] = _varnames[i][1]
    end
    f_pos, Symbol.(strip.(varnames))
end

function guess_eol_char(path)
    f = open(path, "r")

    LF = UInt8('\n')
    CR = UInt8('\r')

    a = Vector{UInt8}(undef, 8192)
    while !eof(f)
        nb = readbytes!(f, a)
        for i in 1:nb
            if a[i] == LF && a[i-1] == CR
                close(f)
                return ['\r', '\n']
            elseif a[i] == LF
                close(f)
                return '\n'
            end
        end
    end
    close(f)
    throw(ArgumentError("end of line is not detectable, set `linebreak` argument manually"))
end


_todate(s::AbstractString) = DateFormat(s)
_todate(s::DateFormat) = s
_todate(::Any) = throw(ArgumentError("DateFormat must be a string or a DateFormat"))


# line breaks can be \r \n or any other thing?
function line_break_finder(buff, lo, hi, linebreaks)
end
