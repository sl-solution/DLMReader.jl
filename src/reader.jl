@inline function parse_data!(res, buffer, types, cc, en, current_line, char_buff, char_cnt, j)
        @inbounds if types[j] <: Int64
            buff_parser(res[j]::Vector{Union{Missing, Int64}}, buffer, cc, en, current_line, Int64)
        elseif types[j] <: Int32
            buff_parser(res[j]::Vector{Union{Missing, Int32}}, buffer, cc, en, current_line, Int32)
        elseif types[j] <: Int16
            buff_parser(res[j]::Vector{Union{Missing, Int16}}, buffer, cc, en, current_line, Int16)
        elseif types[j] <: Int8
            buff_parser(res[j]::Vector{Union{Missing, Int8}}, buffer, cc, en, current_line, Int8)
        elseif types[j] <: Float64
            buff_parser(res[j]::Vector{Union{Missing, Float64}}, buffer, cc, en, current_line, Float64)
        elseif types[j] <: Float32
            buff_parser(res[j]::Vector{Union{Missing, Float32}}, buffer, cc, en, current_line, Float32)
        elseif types[j] <: InlineString1
            buff_parser(res[j]::Vector{Union{Missing,InlineString1}}, buffer, cc, en, current_line,InlineString1)
        elseif types[j] <: InlineString3
            buff_parser(res[j]::Vector{Union{Missing,InlineString3}}, buffer, cc, en, current_line,InlineString3)
        elseif types[j] <: InlineString7
            buff_parser(res[j]::Vector{Union{Missing,InlineString7}}, buffer, cc, en, current_line,InlineString7)
        elseif types[j] <: InlineString15
            buff_parser(res[j]::Vector{Union{Missing,InlineString15}}, buffer, cc, en, current_line,InlineString15)
        elseif types[j] <: InlineString31
            buff_parser(res[j]::Vector{Union{Missing,InlineString31}}, buffer, cc, en, current_line,InlineString31)
        elseif types[j] <: InlineString63
            buff_parser(res[j]::Vector{Union{Missing,InlineString63}}, buffer, cc, en, current_line,InlineString63)
        elseif types[j] <: InlineString127
            buff_parser(res[j]::Vector{Union{Missing,InlineString127}}, buffer, cc, en, current_line,InlineString127)
        elseif types[j] <: InlineString255
            buff_parser(res[j]::Vector{Union{Missing,InlineString255}}, buffer, cc, en, current_line,InlineString255)
        elseif types[j] <: InlineString255
            buff_parser(res[j]::Vector{Union{Missing,InlineString255}}, buffer, cc, en, current_line,InlineString255)
        elseif types[j] <: Characters{1, UInt8}
            buff_parser(res[j]::Vector{Union{Missing,Characters{1, UInt8}}}, buffer, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{1, UInt8})
        elseif types[j] <: Characters{2, UInt8}
            buff_parser(res[j]::Vector{Union{Missing,Characters{2, UInt8}}}, buffer, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{2, UInt8})
        elseif types[j] <: Characters{3, UInt8}
            buff_parser(res[j]::Vector{Union{Missing,Characters{3, UInt8}}}, buffer, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{3, UInt8})
        elseif types[j] <: Characters{4, UInt8}
            buff_parser(res[j]::Vector{Union{Missing,Characters{4, UInt8}}}, buffer, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{4, UInt8})
        elseif types[j] <: Characters{5, UInt8}
            buff_parser(res[j]::Vector{Union{Missing,Characters{5, UInt8}}}, buffer, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{5, UInt8})
        elseif types[j] <: Characters{6, UInt8}
            buff_parser(res[j]::Vector{Union{Missing,Characters{6, UInt8}}}, buffer, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{6, UInt8})
        elseif types[j] <: Characters{7, UInt8}
            buff_parser(res[j]::Vector{Union{Missing,Characters{7, UInt8}}}, buffer, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{7, UInt8})
        elseif types[j] <: Characters{8, UInt8}
            buff_parser(res[j]::Vector{Union{Missing,Characters{8, UInt8}}}, buffer, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{8, UInt8})
        elseif types[j] <: Characters{9, UInt8}
            buff_parser(res[j]::Vector{Union{Missing,Characters{9, UInt8}}}, buffer, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{9, UInt8})
        elseif types[j] <: Characters{10, UInt8}
            buff_parser(res[j]::Vector{Union{Missing,Characters{10, UInt8}}}, buffer, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{10, UInt8})
        elseif types[j] <: Characters{11, UInt8}
            buff_parser(res[j]::Vector{Union{Missing,Characters{11, UInt8}}}, buffer, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{11, UInt8})
        elseif types[j] <: Characters{12, UInt8}
            buff_parser(res[j]::Vector{Union{Missing,Characters{12, UInt8}}}, buffer, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{12, UInt8})
        elseif types[j] <: Characters{13, UInt8}
            buff_parser(res[j]::Vector{Union{Missing,Characters{13, UInt8}}}, buffer, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{13, UInt8})
        elseif types[j] <: Characters{14, UInt8}
            buff_parser(res[j]::Vector{Union{Missing,Characters{14, UInt8}}}, buffer, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{14, UInt8})
        elseif types[j] <: Characters{15, UInt8}
            buff_parser(res[j]::Vector{Union{Missing,Characters{15, UInt8}}}, buffer, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{15, UInt8})
        elseif types[j] <: Characters{16, UInt8}
            buff_parser(res[j]::Vector{Union{Missing,Characters{16, UInt8}}}, buffer, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{16, UInt8})
        else # types[j] <: String
            buff_parser(res[j]::Vector{Union{Missing, String}}, buffer, cc, en, current_line, String)
        end
        nothing
end



@inline function _process_iobuff!(res, buffer, types, dlm, eol, cnt_read_bytes, buffsize, current_line, last_line, last_valid_buff, charbuff, fixed)
    cnt = 1
    cnt_buff = 1
    lastvalid = 0
    # not yet sure about line_start
    line_start = 1
    field_start = 1
    line_end = last_valid_buff
    current_cursor_position = 1
    j = 1
    char_cnt = 0
    @inbounds while current_cursor_position <= last_valid_buff
        if types[j] <: Characters
            char_cnt += 1
        end
        if fixed[j].start === 0
            eol_reached, dlm_pos = find_next_delim_or_end_of_line(buffer, field_start, dlm, eol)
            parse_data!(res, buffer, types, field_start, dlm_pos - 1, current_line, charbuff, char_cnt, j)
            field_start = dlm_pos + 1
        else
            offset = line_start - 1
            eol_reached, dlm_pos = buffer[fixed[j].stop + offset - 1] == eol, fixed[j].stop + offset
            parse_data!(res, buffer, types, fixed[j].start + offset, dlm_pos, current_line, charbuff, char_cnt, j)
            field_start = fixed[j].stop + offset + 1
        end

        j += 1
        if eol_reached
            current_line[] += 1
            line_start = field_start
            j = 1
            char_cnt = 0
        end
        current_cursor_position = field_start
    end


end
@inline function _process_iobuff!(res, buffer, types, dlm, eol, cnt_read_bytes, buffsize, current_line, last_line, last_valid_buff, charbuff)
    cnt = 1
    cnt_buff = 1
    lastvalid = 0
    # not yet sure about line_start
    line_start = 1
    field_start = 1
    line_end = last_valid_buff
    current_cursor_position = 1
    j = 1
    char_cnt = 0
    @inbounds while current_cursor_position <= last_valid_buff
        if types[j] <: Characters
            char_cnt += 1
        end
        eol_reached, dlm_pos = find_next_delim_or_end_of_line(buffer, field_start, dlm, eol)
        parse_data!(res, buffer, types, field_start, dlm_pos - 1, current_line, charbuff, char_cnt, j)
        field_start = dlm_pos + 1

        j += 1
        if eol_reached
            current_line[] += 1
            line_start = field_start
            j = 1
            char_cnt = 0
        end
        current_cursor_position = field_start
    end


end


# lo is the begining of the read and hi is the end of read. hi should be end of file or a linebreak
function readfile_chunk!(res, llo, lhi, charbuff, path, types, n, lo, hi; delimeter = ',', linebreak = '\n', lsize = 32000, buffsize = 2^16, fixed = 0:0)

    f = open(path, "r")

    dlm = UInt8.(delimeter)
    eol = UInt8(linebreak)
    buffsize > hi-lo+1 ? buffsize = hi-lo+1 : nothing

    # later we will use LineBuffer for this
    buffer = Vector{UInt8}(undef, buffsize)
    current_line = Ref{Int}(llo)
    last_line = false
    last_valid_buff = buffsize
    # position which reading should be started
    seek(f, lo - 1)

    # TODO we should have a strategy when line is to long
    @inbounds while true
        cnt_read_bytes = readbytes!(f, buffer)
        cur_position = position(f)

        if !eof(f) && cur_position <= hi
            if buffer[end] !== eol

                back_cnt = 0
                for i in buffsize:-1:1
                    last_valid_buff = i
                    buffer[i] == eol && break
                    back_cnt += 1
                end
                cur_position = position(f)
                seek(f, cur_position - back_cnt)
            else
                last_valid_buff = buffsize
            end
        elseif cur_position <= hi
            last_line = true
            if buffer[cnt_read_bytes] !== eol
                @warn "the last line is not ended with line break character"
                for i in cnt_read_bytes:-1:1
                    last_valid_buff = i
                    buffer[i] == eol && break
                end

            else
                last_valid_buff = cnt_read_bytes
            end
        else cur_position > hi
            last_line = true
            last_valid_buff = buffsize - (cur_position - hi)
        end
        if fixed == 0:0
            _process_iobuff!(res, buffer, types, dlm, eol, cnt_read_bytes, buffsize, current_line, last_line, last_valid_buff, charbuff)
        else
            _process_iobuff!(res, buffer, types, dlm, eol, cnt_read_bytes, buffsize, current_line, last_line, last_valid_buff, charbuff, fixed)
        end
        # we need to break at some point
        last_line && break
    end
    close(f)
    res
end


# main distributer
function distribute_file(path, types; delimeter = ',', linebreak = '\n', header = true, threads = true, guessingrows = 20, fixed = Dict{Int, UnitRange{Int}}(), buffsize = 2^16, quotation = nothing)
    lsize_estimate = estimate_linesize(path, guessingrows = guessingrows)
    if !isempty(fixed)
        colwidth = Vector{UnitRange{Int}}(undef, length(types))
        for i in 1:length(colwidth)
            colwidth[i] = get(fixed, i, 0:0)
        end
    else
        colwidth = 0:0
    end
    f = open(path, "r")

    # generating varnames
    varnames = :auto
    if header
        _lvarnames = length(readline(f, keep = true))
        _varnames = [Vector{Union{String, Missing}}(undef, 1) for _ in 1:length(types)]
        readfile_chunk!(_varnames, 1,1, [], path, repeat([String], length(types)), 1, 1, _lvarnames; delimeter = delimeter, linebreak = linebreak, buffsize = buffsize, fixed = colwidth)
        varnames = Vector{String}(undef, length(types))
        for i in 1:length(_varnames)
            varnames[i] = _varnames[i][1]
        end
        varnames = Symbol.(strip.(varnames))
    end

    # how many bytes we should skip - we should use this information to have a better distribution of file into nt chunks.
    skip_bytes = position(f)
    fs = filesize(f)
    initial_guess_for_row_num = fs/lsize_estimate
    if !threads || fs < 10^7 || div(fs, Threads.nthreads()) < lsize_estimate
        nt = 1
    else
        nt = Threads.nthreads()
    end


    charbuff = Vector{Vector{UInt8}}()
    for j in 1:length(types)
        if types[j] <: Characters
            if types[j] == Characters
                types[j] = Characters{8, UInt8}
                push!(charbuff, Vector{UInt8}(undef, 8))
            else
                types[j] = Characters{sizeof(types[j]), UInt8}
                push!(charbuff, Vector{UInt8}(undef, sizeof(types[j])))
            end
        end
    end
    charbuff = fill(charbuff, nt)


    cz = div(fs, nt)
    lo = [(i-1)*cz+1 for i in 1:nt]
    hi = [i*cz-1 for i in 1:nt]

    hi[end] = fs
    lo[1] += skip_bytes

    eol = UInt8(linebreak)
    for i in 1:length(hi)-1
        seek(f, hi[i])
        cur_value = read(f, UInt8)
        if cur_value !== eol
            while true
                cur_value = read(f, UInt8)
                cur_value == eol && break
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
            ns[i] = count_lines_of_file(path, lo[i], hi[i], eol)
        end
    end
    res = Any[Vector{Union{Missing, types[i]}}(undef, sum(ns)) for i in 1:length(types)]
    line_hi = cumsum(ns)
    line_lo = [1; line_hi[1:end] .+ 1]

    close(f)
    if nt > 1
        Threads.@threads for i in 1:nt
            readfile_chunk!(res, line_lo[i], line_hi[i], charbuff[i], path, types, ns[i], lo[i], hi[i]; delimeter = delimeter, linebreak = linebreak, lsize = lsize_estimate, buffsize = buffsize, fixed = colwidth)
        end
    else
        for i in 1:nt
            readfile_chunk!(res, line_lo[i], line_hi[i], charbuff[i], path, types, ns[i], lo[i], hi[i]; delimeter = delimeter, linebreak = linebreak, lsize = lsize_estimate, buffsize = buffsize, fixed = colwidth)
        end
    end
    Dataset(res, varnames, copycols = false)
end
