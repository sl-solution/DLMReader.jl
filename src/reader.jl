@inline function parse_data!(res, buffer, types, cc, en, current_line, char_buff, char_cnt, df, dt_cnt, j)
        if types[j] <: Int64
            buff_parser(res[j]::Vector{Union{Missing, Int64}}, buffer, cc, en, current_line, Int64)
        elseif types[j] <: Int32
            buff_parser(res[j]::Vector{Union{Missing, Int32}}, buffer, cc, en, current_line, Int32)
        elseif types[j] <: Int16
            buff_parser(res[j]::Vector{Union{Missing, Int16}}, buffer, cc, en, current_line, Int16)
        elseif types[j] <: Int8
            buff_parser(res[j]::Vector{Union{Missing, Int8}}, buffer, cc, en, current_line, Int8)
        elseif types[j] <: Float64
            buff_parser(res[j]::Vector{Union{Missing, Float64}}, buffer.data, cc, en, current_line, Float64)
        elseif types[j] <: Float32
            buff_parser(res[j]::Vector{Union{Missing, Float32}}, buffer.data, cc, en, current_line, Float32)
        elseif types[j] <: DT
            buff_parser(res[j]::Vector{UInt8}, buffer.data, cc, en, current_line, DT)
        elseif types[j] <: Date
            buff_parser(res[j]::Vector{Union{Missing, Date}}, buffer, cc, en, current_line, df[dt_cnt], Date)
        elseif types[j] <: Time
            buff_parser(res[j]::Vector{Union{Missing, Time}}, buffer, cc, en, current_line, df[dt_cnt], Time)
        elseif types[j] <: DateTime
            buff_parser(res[j]::Vector{Union{Missing, DateTime}}, buffer, cc, en, current_line, df[dt_cnt], DateTime)
        elseif types[j] <: InlineString1
            buff_parser(res[j]::Vector{Union{Missing,InlineString1}}, buffer.data, cc, en, current_line,InlineString1)
        elseif types[j] <: InlineString3
            buff_parser(res[j]::Vector{Union{Missing,InlineString3}}, buffer.data, cc, en, current_line,InlineString3)
        elseif types[j] <: InlineString7
            buff_parser(res[j]::Vector{Union{Missing,InlineString7}}, buffer.data, cc, en, current_line,InlineString7)
        elseif types[j] <: InlineString15
            buff_parser(res[j]::Vector{Union{Missing,InlineString15}}, buffer.data, cc, en, current_line,InlineString15)
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
        elseif types[j] <: Characters{1, UInt8}
            buff_parser(res[j]::Vector{Union{Missing,Characters{1, UInt8}}}, buffer.data, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{1, UInt8})
        elseif types[j] <: Characters{2, UInt8}
            buff_parser(res[j]::Vector{Union{Missing,Characters{2, UInt8}}}, buffer.data, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{2, UInt8})
        elseif types[j] <: Characters{3, UInt8}
            buff_parser(res[j]::Vector{Union{Missing,Characters{3, UInt8}}}, buffer.data, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{3, UInt8})
        elseif types[j] <: Characters{4, UInt8}
            buff_parser(res[j]::Vector{Union{Missing,Characters{4, UInt8}}}, buffer.data, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{4, UInt8})
        elseif types[j] <: Characters{5, UInt8}
            buff_parser(res[j]::Vector{Union{Missing,Characters{5, UInt8}}}, buffer.data, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{5, UInt8})
        elseif types[j] <: Characters{6, UInt8}
            buff_parser(res[j]::Vector{Union{Missing,Characters{6, UInt8}}}, buffer.data, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{6, UInt8})
        elseif types[j] <: Characters{7, UInt8}
            buff_parser(res[j]::Vector{Union{Missing,Characters{7, UInt8}}}, buffer.data, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{7, UInt8})
        elseif types[j] <: Characters{8, UInt8}
            buff_parser(res[j]::Vector{Union{Missing,Characters{8, UInt8}}}, buffer.data, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{8, UInt8})
        elseif types[j] <: Characters{9, UInt8}
            buff_parser(res[j]::Vector{Union{Missing,Characters{9, UInt8}}}, buffer.data, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{9, UInt8})
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
        elseif types[j] <: Characters{16, UInt8}
            buff_parser(res[j]::Vector{Union{Missing,Characters{16, UInt8}}}, buffer.data, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{16, UInt8})
        else # types[j] <: String
            buff_parser(res[j]::Vector{Union{Missing, String}}, buffer.data, cc, en, current_line, String)
        end
        nothing
end



@inline function _process_iobuff!(res, buffer, types, dlm, eol, cnt_read_bytes, buffsize, current_line, last_line, last_valid_buff, charbuff, df, fixed)
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
    dt_cnt = 0
    while current_cursor_position <= last_valid_buff
        if types[j] <: Characters
            char_cnt += 1
        elseif types[j] <: TimeType
            dt_cnt += 1
        end
        if fixed === 0:0 || fixed[j].start === 0
            eol_reached, dlm_pos = find_next_delim_or_end_of_line(buffer.data, field_start, dlm, eol)
            parse_data!(res, buffer, types, field_start, dlm_pos - 1, current_line, charbuff, char_cnt, df, dt_cnt, j)
            field_start = dlm_pos + 1
        else
            offset = line_start - 1
            eol_reached, dlm_pos = buffer.data[fixed[j].stop + offset - 1] == eol, fixed[j].stop + offset
            parse_data!(res, buffer, types, fixed[j].start + offset, dlm_pos, current_line, charbuff, char_cnt, df, dt_cnt, j)
            field_start = fixed[j].stop + offset + 1
        end

        j += 1
        if eol_reached
            current_line[] += 1
            line_start = field_start
            j = 1
            char_cnt = 0
            dt_cnt = 0
        end
        current_cursor_position = field_start
    end


end

# lo is the begining of the read and hi is the end of read. hi should be end of file or a linebreak
function readfile_chunk!(res, llo, lhi, charbuff, path, types, n, lo, hi; delimiter = ',', linebreak = '\n', lsize = 32000, buffsize = 2^16, fixed = 0:0, df = dateformat"yyyy-mm-dd")

    f = open(path, "r")

    dlm = UInt8.(delimiter)
    eol = UInt8(linebreak)
    buffsize > hi-lo+1 ? buffsize = hi-lo+1 : nothing

    # later we will use LineBuffer for this
    buffer = LineBuffer(Vector{UInt8}(undef, buffsize))
    current_line = Ref{Int}(llo)
    last_line = false
    last_valid_buff = buffsize
    # position which reading should be started
    seek(f, lo - 1)

    # TODO we should have a strategy when line is to long
    while true
        cnt_read_bytes = readbytes!(f, buffer.data)
        cur_position = position(f)

        if !eof(f) && cur_position < hi
            if buffer.data[end] !== eol

                back_cnt = 0
                for i in buffsize:-1:1
                    last_valid_buff = i
                    buffer.data[i] == eol && break
                    back_cnt += 1
                end
                cur_position = position(f)
                seek(f, cur_position - back_cnt)
            else
                last_valid_buff = buffsize
            end
        elseif cur_position == hi
            last_line = true
            if buffer.data[cnt_read_bytes] !== eol
                @warn "the last line is not ended with line break character"
                if !eof(f)
                    for i in cnt_read_bytes:-1:1
                        last_valid_buff = i
                        buffer.data[i] == eol && break
                    end
                end

            else
                last_valid_buff = cnt_read_bytes
            end
        else cur_position > hi
            last_line = true
            last_valid_buff = buffsize - (cur_position - hi)
        end
        _process_iobuff!(res, buffer, types, dlm, eol, cnt_read_bytes, buffsize, current_line, last_line, last_valid_buff, charbuff, df, fixed)
        # we need to break at some point
        last_line && break
    end
    close(f)
    res
end


# main distributer
function distribute_file(path, types; delimiter = ',', linebreak = '\n', header = true, threads = true, guessingrows = 20, fixed = 0:0, buffsize = 2^16, quotation = nothing, dtformat = dateformat"yyyy-mm-dd")
    lsize_estimate = estimate_linesize(path, guessingrows = guessingrows)
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
    varnames = :auto
    if header
        _lvarnames = length(readline(f, keep = true))
        _varnames = [Vector{Union{String, Missing}}(undef, 1) for _ in 1:length(types)]
        readfile_chunk!(_varnames, 1,1, [], path, repeat([String], length(types)), 1, 1, _lvarnames; delimiter = delimiter, linebreak = linebreak, buffsize = buffsize, fixed = colwidth)
        varnames = Vector{String}(undef, length(types))
        for i in 1:length(_varnames)
            ismissing(_varnames[i][1]) && throw(ArgumentError("the variable name inference is not valid, setting `header = false` may solve the issue."))
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
            readfile_chunk!(res, line_lo[i], line_hi[i], charbuff[i], path, types, ns[i], lo[i], hi[i]; delimiter = delimiter, linebreak = linebreak, lsize = lsize_estimate, buffsize = buffsize, fixed = colwidth, df = dtfmt)
        end
    else
        for i in 1:nt
            readfile_chunk!(res, line_lo[i], line_hi[i], charbuff[i], path, types, ns[i], lo[i], hi[i]; delimiter = delimiter, linebreak = linebreak, lsize = lsize_estimate, buffsize = buffsize, fixed = colwidth, df = dtfmt)
        end
    end
    Dataset(res, varnames, copycols = false)
end


function guess_structure_of_delimited_file(path, dlm; eol = UInt8('\n'), header = true, guessingrows = 20, fixed = 0:0, dtformat = nothing)
    f = open(path, "r")
    cnt = 1
    n_cols = 0
    col_width = 0:0
    seen_dlm = false
    if fixed isa Dict
        colwidth = UnitRange{Int}[]
    else
        colwidth = 0:0
    end
    while true
        if fixed isa Dict
            col_width = get(fixed, n_cols + 1, 0:0)
        end
        if col_width != 0:0
            seek(f, position(f)+length(col_width))
            cnt += length(col_width)
            n_cols += 1
            seen_dlm = false
            push!(colwidth, col_width)
        else
            read_byte_val = read(f, UInt8)
            cnt += 1
            if read_byte_val == eol
                if seen_dlm
                    n_cols += 1
                    push!(colwidth, 0:0)
                end
                break
            end
            if read_byte_val in dlm
                n_cols += 1
                seen_dlm = true
                push!(colwidth, col_width)
            end
        end
    end
    if header
        lo = position(f) + 1
    else
        lo = 0
    end
    if cnt > 2^16
        @error "very wide delimited file, we use 1/10 of `gueesingrows` to detect types"
        guessingrows = max(1, div(guessingrows, 10))
    end
    seek(f, lo)
    rows_in = 1
    while true
        readline(f)
        rows_in += 1
        rows_in > guessingrows && break
    end
    rows_in -= 1
    hi = position(f)
    types = repeat([String], n_cols)
    res = [Vector{Union{Missing, String}}(undef, rows_in) for _ in 1:n_cols]
    readfile_chunk!(res, 1, rows_in, [], path, types, rows_in, lo, hi; delimiter = dlm, linebreak = eol, buffsize = 2^16, fixed = colwidth)
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
    outtypes
end


function filereader(path; types = nothing, delimiter = ',', linebreak = '\n', header = true, threads = true, guessingrows = 20, fixed = 0:0, buffsize = 2^16, quotation = nothing, dtformat = dateformat"yyyy-mm-dd")
    if types === nothing
        intypes = guess_structure_of_delimited_file(path, UInt8.(delimiter); eol = UInt8('\n'), header = header, guessingrows = guessingrows, fixed = fixed, dtformat = dtformat)
    elseif types isa AbstractVector{DataType}
        intypes = types
    else
        throw(ArgumentError("types should be a vector of types"))
    end
    !all(isascii.(delimiter)) && throw(ArgumentError("delimiter must be ASCII"))
    distribute_file(path, intypes; delimiter = delimiter, linebreak = linebreak, header = header, threads = threads, guessingrows = guessingrows, fixed = fixed, buffsize = buffsize, quotation = quotation, dtformat = dtformat)
end
