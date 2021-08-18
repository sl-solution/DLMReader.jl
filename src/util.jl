@inline function find_next_delim_or_end_of_line(buffer, field_start, dlm, eol)
    @inbounds for i in field_start:length(buffer)
        if buffer[i] in dlm
            return false, i
        elseif buffer[i] == eol
            return true, i
        end
    end
    return true, length(buffer)
end


function count_lines_of_file(path, lo, hi, eol)
    f = open(path, "r")
    a = Vector{UInt8}(undef, 8192)
    nl = nb = 0
    cur_position = lo
    seek(f, lo-1)
    while !eof(f) && cur_position <= hi
        nb = readbytes!(f, a)
        cur_position = position(f)
        if cur_position > hi
            last_nb = nb - (cur_position - hi)
        else
            last_nb = nb
        end
        @simd for i=1:last_nb
            @inbounds nl += a[i] == eol
        end
    end
    if eof(f) && nb > 0 && a[nb] != eol
        nl += 1 # final line is not terminated with eol
    end
    close(f)
    nl
end


function estimate_linesize(path; guessingrows = 20)
    line_estimate = 0
    cnt = 1
    for l in eachline(path)
        if length(l) > line_estimate
            line_estimate = length(l)
        end
        cnt += 1
        cnt > guessingrows && break
    end
    line_estimate
end
