@inline function parse_data!(res, buffer, types, cc, en, current_line, char_buff, char_cnt, df, dt_cnt, j, informat)
        _infmt! = get(informat, j, identity)
        if _infmt! !== identity
            _infmt!(buffer, cc, en)
        end

        if types[j] <: Int64
            buff_parser(res[j]::Vector{Union{Missing, Int64}}, buffer, cc, en, current_line, Int64)
        elseif types[j] <: Float64
            buff_parser(res[j]::Vector{Union{Missing, Float64}}, buffer.data, cc, en, current_line, Float64)
        elseif types[j] <: Date
            buff_parser(res[j]::Vector{Union{Missing, Date}}, buffer, cc, en, current_line, df[dt_cnt], Date)
        elseif types[j] <: DateTime
            buff_parser(res[j]::Vector{Union{Missing, DateTime}}, buffer, cc, en, current_line, df[dt_cnt], DateTime)
        elseif types[j] <: String
            buff_parser(res[j]::Vector{Union{Missing, String}}, buffer.data, cc, en, current_line, String)
        elseif types[j] <: Int32
            buff_parser(res[j]::Vector{Union{Missing, Int32}}, buffer, cc, en, current_line, Int32)
        elseif types[j] <: Float32
            buff_parser(res[j]::Vector{Union{Missing, Float32}}, buffer.data, cc, en, current_line, Float32)
        elseif types[j] <: Int8
            buff_parser(res[j]::Vector{Union{Missing, Int8}}, buffer, cc, en, current_line, Int8)
        elseif types[j] <: Int16
            buff_parser(res[j]::Vector{Union{Missing, Int16}}, buffer, cc, en, current_line, Int16)
        # elseif types[j] <: DT
        #     buff_parser(res[j]::Vector{UInt8}, buffer.data, cc, en, current_line, DT)
        elseif types[j] <: InlineString1
            buff_parser(res[j]::Vector{Union{Missing,InlineString1}}, buffer.data, cc, en, current_line,InlineString1)
        elseif types[j] <: InlineString3
            buff_parser(res[j]::Vector{Union{Missing,InlineString3}}, buffer.data, cc, en, current_line,InlineString3)
        elseif types[j] <: InlineString7
            buff_parser(res[j]::Vector{Union{Missing,InlineString7}}, buffer.data, cc, en, current_line,InlineString7)
        elseif types[j] <: InlineString15
            buff_parser(res[j]::Vector{Union{Missing,InlineString15}}, buffer.data, cc, en, current_line,InlineString15)
        elseif types[j] <: Characters{3, UInt8}
            buff_parser(res[j]::Vector{Union{Missing,Characters{3, UInt8}}}, buffer.data, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{3, UInt8})
        elseif types[j] <: Characters{5, UInt8}
            buff_parser(res[j]::Vector{Union{Missing,Characters{5, UInt8}}}, buffer.data, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{5, UInt8})
        elseif types[j] <: Characters{8, UInt8}
            buff_parser(res[j]::Vector{Union{Missing,Characters{8, UInt8}}}, buffer.data, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{8, UInt8})
        elseif types[j] <: Characters{10, UInt8}
            buff_parser(res[j]::Vector{Union{Missing,Characters{10, UInt8}}}, buffer.data, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{10, UInt8})
        elseif types[j] <: Characters{11, UInt8}
            buff_parser(res[j]::Vector{Union{Missing,Characters{11, UInt8}}}, buffer.data, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{11, UInt8})
        elseif types[j] <: Characters{12, UInt8}
            buff_parser(res[j]::Vector{Union{Missing,Characters{12, UInt8}}}, buffer.data, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{12, UInt8})
        elseif types[j] <: Characters{13, UInt8}
            buff_parser(res[j]::Vector{Union{Missing,Characters{13, UInt8}}}, buffer.data, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{13, UInt8})
        elseif types[j] <: Characters{14, UInt8}
            buff_parser(res[j]::Vector{Union{Missing,Characters{14, UInt8}}}, buffer.data, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{14, UInt8})
        elseif types[j] <: Characters{15, UInt8}
            buff_parser(res[j]::Vector{Union{Missing,Characters{15, UInt8}}}, buffer.data, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{15, UInt8})
        elseif types[j] <: Characters{1, UInt8}
            buff_parser(res[j]::Vector{Union{Missing,Characters{1, UInt8}}}, buffer.data, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{1, UInt8})
        elseif types[j] <: Characters{2, UInt8}
            buff_parser(res[j]::Vector{Union{Missing,Characters{2, UInt8}}}, buffer.data, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{2, UInt8})
        elseif types[j] <: Characters{4, UInt8}
            buff_parser(res[j]::Vector{Union{Missing,Characters{4, UInt8}}}, buffer.data, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{4, UInt8})
        elseif types[j] <: Characters{6, UInt8}
            buff_parser(res[j]::Vector{Union{Missing,Characters{6, UInt8}}}, buffer.data, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{6, UInt8})
        elseif types[j] <: Characters{7, UInt8}
            buff_parser(res[j]::Vector{Union{Missing,Characters{7, UInt8}}}, buffer.data, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{7, UInt8})
        elseif types[j] <: Characters{9, UInt8}
            buff_parser(res[j]::Vector{Union{Missing,Characters{9, UInt8}}}, buffer.data, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{9, UInt8})
        elseif types[j] <: Characters{16, UInt8}
            buff_parser(res[j]::Vector{Union{Missing,Characters{16, UInt8}}}, buffer.data, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{16, UInt8})
        elseif types[j] <: Time
            buff_parser(res[j]::Vector{Union{Missing, Time}}, buffer, cc, en, current_line, df[dt_cnt], Time)
        elseif types[j] <: InlineString31
            buff_parser(res[j]::Vector{Union{Missing,InlineString31}}, buffer.data, cc, en, current_line,InlineString31)
        elseif types[j] <: InlineString63
            buff_parser(res[j]::Vector{Union{Missing,InlineString63}}, buffer.data, cc, en, current_line,InlineString63)
        elseif types[j] <: InlineString127
            buff_parser(res[j]::Vector{Union{Missing,InlineString127}}, buffer.data, cc, en, current_line,InlineString127)
        elseif types[j] <: InlineString255
            buff_parser(res[j]::Vector{Union{Missing,InlineString255}}, buffer.data, cc, en, current_line,InlineString255)
        elseif types[j] <: InlineString255
            buff_parser(res[j]::Vector{Union{Missing,InlineString255}}, buffer.data, cc, en, current_line,InlineString255)
        else # anything else
            buff_parser(res[j]::Vector{Union{Missing, String}}, buffer.data, cc, en, current_line, String)
        end
        nothing
end



@inline function _process_iobuff!(res, buffer, types, dlm, eol, cnt_read_bytes, buffsize, current_line, last_line, last_valid_buff, charbuff, df, fixed, dlmstr, informat)

    n_cols = length(types)
    line_start = 1
    current_cursor_position = 1

    #keeping track of number of warnings
    warn_pass_end_of_line = 0

    dlmstr === nothing ? dlm_length = 1  : dlm_length = length(dlmstr)
    while true

        # keep track of Characters and DateTime columns
        char_cnt = 0
        dt_cnt = 0

        line_end = find_end_of_line(buffer.data, line_start, last_valid_buff, eol)
        field_start = line_start
        for j in 1:n_cols
            if types[j] <: Characters
                char_cnt += 1
            elseif types[j] <: TimeType
                dt_cnt += 1
            end
            # if there is no fixed width information for the current column
            if fixed === 0:0 || fixed[j].start === 0
                dlm_pos = find_next_delim(buffer.data, field_start, line_end, dlm, dlmstr)
                # we should have a strategy for this kind of problem, for now just let the end of line as endpoint
                dlm_pos == 0 ? dlm_pos = line_end + dlm_length : nothing# 1 is added in this line and deduct in the next line, since we currently assume dlm is single char
                parse_data!(res, buffer, types, field_start, dlm_pos - dlm_length, current_line, charbuff, char_cnt, df, dt_cnt, j, informat)
                field_start = dlm_pos + 1
            else # we have a fixed width information for the current column
                offset = line_start - 1
                dlm_pos = fixed[j].stop + offset
                if dlm_pos > line_end
                    dlm_pos = line_end
                    warn_pass_end_of_line += 1
                    # TODO use better wording
                    if warn_pass_end_of_line < 5
                        @warn "for column $(j) in line $(current_line[]) the cursor goes beyond the line, and the value is truncated"
                    end
                end
                # dlm_pos doesn't contain dlm so it shouldn't be dlm_pos-1 like the non-fixed case
                parse_data!(res, buffer, types, fixed[j].start + offset, dlm_pos, current_line, charbuff, char_cnt, df, dt_cnt, j, informat)
                field_start = dlm_pos + 1
            end
            dlm_pos > line_end && break
        end

        line_start = line_end + length(eol) + 1
        current_line[] += 1
        line_start > last_valid_buff && break
    end

end


# lo is the begining of the read and hi is the end of read. hi should be end of file or a linebreak
function readfile_chunk!(res, llo, lhi, charbuff, path, types, n, lo, hi; delimiter = ',', linebreak = '\n', lsize = 2^15, buffsize = 2^16, fixed = 0:0, df = dateformat"yyyy-mm-dd", dlmstr = nothing, informat = Dict{Int, Function}())

    f = open(path, "r")
    try
        if dlmstr === nothing
            dlm = UInt8.(delimiter)
        elseif dlmstr isa AbstractString
            dlm = UInt8.(collect(dlmstr))
        else
            throw(ArgumentError("`dlmstr` must be a string of ASCII characters"))
        end
        eol = UInt8.(linebreak)
        eol_first = first(eol)
        eol_last = last(eol)
        eol_len = length(eol)

        buffsize > hi-lo+1 ? buffsize = hi-lo+1 : nothing

        # later we will use LineBuffer for this
        buffer = LineBuffer(Vector{UInt8}(undef, buffsize))
        current_line = Ref{Int}(llo)
        last_line = false
        last_valid_buff = buffsize
        # position which reading should be started
        seek(f, max(0, lo - 1))

        # TODO we should have a strategy when line is to long
        while true
            cnt_read_bytes = readbytes!(f, buffer.data)
            cur_position = position(f)

            if !eof(f) && cur_position < hi
                if buffer.data[end] !== eol_last || buffer.data[end - eol_len + 1] !== eol_first
                    #this means the buffer is not ended with a eol char, so we move back into buffer to have complete line
                    back_cnt = 0
                    for i in buffsize:-1:1
                        last_valid_buff = i
                        buffer.data[i] == eol_last && buffer.data[i - eol_len + 1] == eol_first && break
                        back_cnt += 1
                    end
                    cur_position = position(f)
                    seek(f, cur_position - back_cnt)
                else
                    last_valid_buff = buffsize
                end
            elseif cur_position == hi
                last_line = true
                if buffer.data[cnt_read_bytes] != eol_last || buffer.data[cnt_read_bytes - eol_len + 1] != eol_first
                    @warn "the last line is not ended with `end of line` character"
                    # we read it anyway
                    # if !eof(f)
                    #     for i in cnt_read_bytes:-1:1
                    #         last_valid_buff = i
                    #         buffer.data[i] == eol && break
                    #     end
                    # end
                    last_valid_buff = cnt_read_bytes
                else
                    last_valid_buff = cnt_read_bytes
                end
            else cur_position > hi
                last_line = true
                last_valid_buff = buffsize - (cur_position - hi + 1)
            end

            _process_iobuff!(res, buffer, types, dlm, eol, cnt_read_bytes, buffsize, current_line, last_line, last_valid_buff, charbuff, df, fixed, dlmstr, informat)
            # we need to break at some point
            last_line && break
        end
    catch e
        close(f)
        rethrow(e)
    end
    close(f)
    res
end


# main distributer
function distribute_file(path, types; delimiter = ',', linebreak = '\n', header = true, threads = true, guessingrows = 20, fixed = 0:0, buffsize = 2^16, quotation = nothing, dtformat = dateformat"yyyy-mm-dd", lsize = 2^15, dlmstr = nothing, informat = Dict{Int, Function}())
    eol = UInt8.(linebreak)
    eol_first = first(eol)
    eol_last = last(eol)
    eol_len = length(eol)


    lsize_estimate = estimate_linesize(path, eol, lsize, guessingrows = guessingrows)
    lsize_estimate > lsize && throw(ArgumentError("the lines are larger than 32k, increase buffers by setting `lsize` and `buffsize` arguments"))
    if fixed != 0:0
        colwidth = Vector{UnitRange{Int}}(undef, length(types))
        for i in 1:length(colwidth)
            colwidth[i] = get(fixed, i, 0:0)
        end
    else
        colwidth = 0:0
    end

    f = open(path, "r")
    # generating varnames
    f_pos = 0
    if (header isa AbstractVector) && (eltype(header) <: Union{AbstractString, Symbol})
        colnames = header
    elseif header === true
        f_pos, colnames = _generate_colname_based(path, eol, 1, lsize, lsize, types, delimiter, linebreak, buffsize, colwidth, dlmstr)
    elseif header === false
        colnames = :auto
    else
        throw(ArgumentError("`header` can be true or false, or a list of variable names"))
    end

    # how many bytes we should skip - we should use this information to have a better distribution of file into nt chunks.
    skip_bytes = f_pos
    fs = filesize(f)
    initial_guess_for_row_num = fs/lsize_estimate
    _check_nt_possible_size = div(fs, buffsize)
    if !threads || fs < 10^6 || div(fs, Threads.nthreads()) < lsize_estimate
        nt = 1
    else
        if _check_nt_possible_size > 0
            nt = min(Threads.nthreads(), _check_nt_possible_size)
        else
            nt = 1
        end
    end


    charbuff = Vector{Vector{UInt8}}()

    # this is temp approach to TimeType parsing, later we should use DT{N} structure to parse TimeType
    if dtformat isa Dict
        dtfmt = Vector{valtype(dtformat)}()
    else
        dtfmt = Vector{typeof(_todate(dtformat))}()
    end

    for j in 1:length(types)
        if types[j] <: Characters
            if types[j] == Characters
                types[j] = Characters{8, UInt8}
                push!(charbuff, Vector{UInt8}(undef, 8))
            else
                types[j] = Characters{sizeof(types[j]), UInt8}
                push!(charbuff, Vector{UInt8}(undef, sizeof(types[j])))
            end
        elseif types[j] <: TimeType
            if dtformat isa Dict
                push!(dtfmt, _todate(get(dtformat, j, ISODateFormat)))
            else
                push!(dtfmt, _todate(dtformat))
            end
        end
    end
    charbuff = fill(charbuff, nt)


    cz = div(fs, nt)
    lo = [(i-1)*cz+1 for i in 1:nt]
    hi = [i*cz for i in 1:nt]
    hi[end] = fs
    lo[1] += skip_bytes
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

    x = read(path)
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
            readfile_chunk!(res, line_lo[i], line_hi[i], charbuff[i], path, types, ns[i], lo[i], hi[i]; delimiter = delimiter, linebreak = linebreak, lsize = lsize, buffsize = buffsize, fixed = colwidth, df = dtfmt, dlmstr = dlmstr, informat = informat)
        end
    else
        for i in 1:nt
            readfile_chunk!(res, line_lo[i], line_hi[i], charbuff[i], path, types, ns[i], lo[i], hi[i]; delimiter = delimiter, linebreak = linebreak, lsize = lsize, buffsize = buffsize, fixed = colwidth, df = dtfmt, dlmstr = dlmstr, informat = informat)
        end
    end
    Dataset(res, colnames, copycols = false)
end


function guess_structure_of_delimited_file(path, delimiter; linebreak = nothing , header = true, guessingrows = 20, fixed = 0:0, dtformat = nothing, dlmstr = nothing, lsize = 2^15, buffsize = 2^16, informat = Dict{Int, Function}())

    if linebreak === nothing
        linebreak = (guess_eol_char(path))
    end
    eol = UInt8.(linebreak)
    eol_last = last(eol)
    eol_first = first(eol)
    eol_len = length(eol)
    if dlmstr === nothing
        dlm = UInt8.(delimiter)
    elseif dlmstr isa AbstractString
        dlm = UInt8.(collect(dlmstr))
    else
        throw(ArgumentError("`dlmstr` must be a string of ASCII characters"))
    end
    read_byte_val = Vector{UInt8}(undef, eol_len)

    f = open(path, "r")


    cnt = 1
    n_cols = 0
    col_width = 0:0

    if fixed isa Dict
        colwidth = UnitRange{Int}[]
    else
        colwidth = 0:0
    end

    l_length, f_pos = read_one_line(path, 1, filesize(f), eol)
    if l_length > lsize
        throw(ArgumentError("very wide delimited file, you need to set `lsize` and `buffsize` argument with larger values. It is also recommended to use lower number of `guessingrows`"))
    end
    a_line_buff = Vector{UInt8}(undef, l_length)
    nb = readbytes!(f, a_line_buff)

    nb_pos = 0
    seen_dlm = true
    while true
        if fixed isa Dict
            col_width = get(fixed, n_cols + 1, 0:0)
        end
        if col_width != 0:0
            nb_pos = col_width.stop
            n_cols += 1
            seen_dlm = false
            push!(colwidth, col_width)
        else
            new_dlm_pos = find_next_delim(a_line_buff, nb_pos+1, l_length, dlm, dlmstr)
            if new_dlm_pos > 0
                n_cols += 1
                nb_pos = new_dlm_pos
                seen_dlm = true
                fixed isa Dict && push!(colwidth, col_width)
            else
                if seen_dlm
                    n_cols += 1
                end
                fixed isa Dict && push!(colwidth, col_width)
                break
            end

        end
    end
    if header === true
        lo = f_pos+1
    else
        lo = 0
    end
    seek(f, lo)
    rows_in = 0
    l_length = 1
    file_pos = max(0, lo - 1)
    while l_length>0
        l_length, file_pos = read_one_line(path, file_pos+1, filesize(f), eol)
        if l_length > 0
            rows_in += 1
        end
        rows_in > guessingrows && break
    end
    hi = file_pos
    types = repeat([String], n_cols)
    res = [Vector{Union{Missing, String}}(undef, rows_in) for _ in 1:n_cols]
    readfile_chunk!(res, 1, rows_in, [], path, types, rows_in, lo, hi; delimiter = delimiter, linebreak = linebreak, buffsize = buffsize, fixed = colwidth, dlmstr = dlmstr, lsize = lsize, informat = informat)
    outtypes = Vector{DataType}(undef, n_cols)
    if !(dtformat isa Dict)
        for j in 1:n_cols
            old_cnt_vals = 0
            for T in (Float64, Int)
                cnt_vals = count(!isequal(nothing), tryparse_with_missing.(T, res[j]))
                if cnt_vals >= old_cnt_vals
                    old_cnt_vals = cnt_vals
                    outtypes[j] = T
                end
            end
            if old_cnt_vals / rows_in < .5
                outtypes[j] = String
            end
        end
    else
        for j in 1:n_cols
            old_cnt_vals = 0
            if haskey(dtformat, j)
                hasdpart = occursin(r"\([ymd]", string(dtformat[j].tokens))
                hastpart = occursin(r"\([HMSs]", string(dtformat[j].tokens))
                if hasdpart && hastpart
                    outtypes[j] = DateTime
                elseif hasdpart
                    outtypes[j] = Date
                elseif hastpart
                    outtypes[j] = Time
                else
                    throw(ArgumentError("the date time format for column $(j) is not valid"))
                end
            else
                for T in (Float64, Int)
                    cnt_vals = count(!isequal(nothing), tryparse_with_missing.(T, res[j]))
                    if cnt_vals >= old_cnt_vals
                        old_cnt_vals = cnt_vals
                        outtypes[j] = T
                    end
                end
                if old_cnt_vals / rows_in < .5
                    outtypes[j] = String
                end
            end
        end
    end
    close(f)
    linebreak, outtypes
end


function filereader(path; types = nothing, delimiter = ',', linebreak = nothing, header = true, threads = true, guessingrows = 20, fixed = 0:0, buffsize = 2^16, quotation = nothing, dtformat = dateformat"yyyy-mm-dd", dlmstr = nothing, lsize = 2^15, informat = Dict{Int, Function}())
    if types === nothing
        linebreak, intypes = guess_structure_of_delimited_file(path, delimiter; linebreak = linebreak, header = header, guessingrows = guessingrows, fixed = fixed, dtformat = dtformat, dlmstr = dlmstr, lsize = lsize, informat = informat)
    elseif types isa Vector && eltype(types) <: Union{DataType,Type}
        intypes = types
        if linebreak === nothing
            linebreak = guess_eol_char(path)
        end
    else
        throw(ArgumentError("types should be a vector of types"))
    end
    !all(isascii.(delimiter)) && throw(ArgumentError("delimiter must be ASCII"))
    distribute_file(path, intypes; delimiter = delimiter, linebreak = linebreak, header = header, threads = threads, guessingrows = guessingrows, fixed = fixed, buffsize = buffsize, quotation = quotation, dtformat = dtformat, dlmstr = dlmstr, lsize = lsize, informat = informat)
end
