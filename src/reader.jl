const number_of_errors_happen_so_far = Threads.Atomic{Int}(0)
function parse_data!(res, buffer, types, lo::Int, hi::Int, current_line, char_buff, char_cnt, df, dt_cnt, j, informat, int_bases, string_trim)
        flag = 0
        cc = lo
        en = hi
        if !isempty(informat)
            if haskey(informat, j)
                new_lo = lo
                new_hi = hi
                for ptrs in informat[j]
                    (new_lo, new_hi) = ccall(ptrs, Tuple{Int, Int}, (Vector{UInt8}, Int, Int), buffer.data, new_lo, new_hi)
                end
                
                cc = new_lo
                en = new_hi
            end
        end
        # any new type added here must also be added to _resize_res_barrier! in util.jl (the function allocates the result)
        @inbounds if types[j] === Int64
           flag = buff_parser(res[j]::Vector{Union{Missing, Int64}}, buffer, cc, en, current_line, Int64; base = int_bases)
        elseif types[j] === Float64
           flag = buff_parser(res[j]::Vector{Union{Missing, Float64}}, buffer.data, cc, en, current_line, Float64)
        elseif types[j] === Bool
            flag = buff_parser(res[j]::Vector{Union{Missing, Bool}}, buffer, cc, en, current_line, Bool)
        elseif types[j] === Date
            flag = buff_parser(res[j]::Vector{Union{Missing, Date}}, buffer, cc, en, current_line, df[dt_cnt], Date)
        elseif types[j] === DateTime
            flag = buff_parser(res[j]::Vector{Union{Missing, DateTime}}, buffer, cc, en, current_line, df[dt_cnt], DateTime)
        elseif types[j] === String
            if string_trim
                flag = buff_parser(res[j]::Vector{Union{Missing, String}}, buffer.data, cc, en, current_line, string_trim, String)
            else
                flag = buff_parser(res[j]::Vector{Union{Missing, String}}, buffer.data, cc, en, current_line, String)
            end
        elseif types[j] === Int32
            flag = buff_parser(res[j]::Vector{Union{Missing, Int32}}, buffer, cc, en, current_line, Int32; base = int_bases)
        elseif types[j] === Float32
            flag = buff_parser(res[j]::Vector{Union{Missing, Float32}}, buffer.data, cc, en, current_line, Float32)
        elseif types[j] === Int8
            flag = buff_parser(res[j]::Vector{Union{Missing, Int8}}, buffer, cc, en, current_line, Int8; base = int_bases)
        elseif types[j] === Int16
            flag = buff_parser(res[j]::Vector{Union{Missing, Int16}}, buffer, cc, en, current_line, Int16; base = int_bases)
        elseif types[j] === String1
            flag = buff_parser(res[j]::Vector{Union{Missing,String1}}, buffer.data, cc, en, current_line,String1)
        elseif types[j] === String3
            flag = buff_parser(res[j]::Vector{Union{Missing,String3}}, buffer.data, cc, en, current_line,String3)
        elseif types[j] === String7
            flag = buff_parser(res[j]::Vector{Union{Missing,String7}}, buffer.data, cc, en, current_line,String7)
        elseif types[j] === String15
            flag = buff_parser(res[j]::Vector{Union{Missing,String15}}, buffer.data, cc, en, current_line,String15)
        elseif types[j] === Characters{3}
            flag = buff_parser(res[j]::Vector{Union{Missing,Characters{3}}}, buffer.data, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{3})
        elseif types[j] === Characters{5}
            flag = buff_parser(res[j]::Vector{Union{Missing,Characters{5}}}, buffer.data, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{5})
        elseif types[j] === Characters{8}
            flag = buff_parser(res[j]::Vector{Union{Missing,Characters{8}}}, buffer.data, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{8})
        elseif types[j] === Characters{10}
            flag = buff_parser(res[j]::Vector{Union{Missing,Characters{10}}}, buffer.data, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{10})
        elseif types[j] === Characters{11}
            flag = buff_parser(res[j]::Vector{Union{Missing,Characters{11}}}, buffer.data, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{11})
        elseif types[j] === Characters{12}
            flag = buff_parser(res[j]::Vector{Union{Missing,Characters{12}}}, buffer.data, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{12})
        elseif types[j] === Characters{13}
            flag = buff_parser(res[j]::Vector{Union{Missing,Characters{13}}}, buffer.data, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{13})
        elseif types[j] === Characters{14}
            flag = buff_parser(res[j]::Vector{Union{Missing,Characters{14}}}, buffer.data, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{14})
        elseif types[j] === Characters{15}
            flag = buff_parser(res[j]::Vector{Union{Missing,Characters{15}}}, buffer.data, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{15})
        elseif types[j] === Characters{1}
            flag = buff_parser(res[j]::Vector{Union{Missing,Characters{1}}}, buffer.data, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{1})
        elseif types[j] === Characters{2}
            flag = buff_parser(res[j]::Vector{Union{Missing,Characters{2}}}, buffer.data, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{2})
        elseif types[j] === Characters{4}
            flag = buff_parser(res[j]::Vector{Union{Missing,Characters{4}}}, buffer.data, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{4})
        elseif types[j] === Characters{6}
            flag = buff_parser(res[j]::Vector{Union{Missing,Characters{6}}}, buffer.data, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{6})
        elseif types[j] === Characters{7}
            flag = buff_parser(res[j]::Vector{Union{Missing,Characters{7}}}, buffer.data, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{7})
        elseif types[j] === Characters{9}
            flag = buff_parser(res[j]::Vector{Union{Missing,Characters{9}}}, buffer.data, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{9})
        elseif types[j] === Characters{16}
            flag = buff_parser(res[j]::Vector{Union{Missing,Characters{16}}}, buffer.data, cc, en, current_line, char_buff[char_cnt]::Vector{UInt8}, Characters{16})
        elseif types[j] === Time
            flag = buff_parser(res[j]::Vector{Union{Missing, Time}}, buffer, cc, en, current_line, df[dt_cnt], Time)
        elseif types[j] === String31
            flag = buff_parser(res[j]::Vector{Union{Missing,String31}}, buffer.data, cc, en, current_line,String31)
        elseif types[j] === String63
            flag = buff_parser(res[j]::Vector{Union{Missing,String63}}, buffer.data, cc, en, current_line,String63)
        elseif types[j] === String127
            flag = buff_parser(res[j]::Vector{Union{Missing,String127}}, buffer.data, cc, en, current_line,String127)
        elseif types[j] === String255
            flag = buff_parser(res[j]::Vector{Union{Missing,String255}}, buffer.data, cc, en, current_line,String255)
        elseif types[j] === UInt8
            flag = buff_parser(res[j]::Vector{Union{Missing, UInt8}}, buffer, cc, en, current_line, UInt8; base = int_bases)
        elseif types[j] === UInt16
            flag = buff_parser(res[j]::Vector{Union{Missing, UInt16}}, buffer, cc, en, current_line, UInt16; base = int_bases)
        elseif types[j] === UInt32
            flag = buff_parser(res[j]::Vector{Union{Missing, UInt32}}, buffer, cc, en, current_line, UInt32; base = int_bases)
        elseif types[j] === UInt64
            flag = buff_parser(res[j]::Vector{Union{Missing, UInt64}}, buffer, cc, en, current_line, UInt64; base = int_bases)
        elseif types[j] === Int128
            flag = buff_parser(res[j]::Vector{Union{Missing, Int128}}, buffer, cc, en, current_line, Int128; base = int_bases)
        elseif types[j] === BigFloat
            flag = buff_parser(res[j]::Vector{Union{Missing, BigFloat}}, buffer, cc, en, current_line, BigFloat)
        elseif types[j] === UUID
            flag = buff_parser(res[j]::Vector{Union{Missing, UUID}}, buffer, cc, en, current_line, UUID)
        else # others are string
            flag = buff_parser(res[j]::Vector{Union{Missing, String}}, buffer.data, cc, en, current_line, String)
        end
        flag
end
function _process_iobuff!(res, buffer, types, dlm, eol,  current_line, last_valid_buff, charbuff, df, fixed, dlmstr, informat, quotechar, escapechar, warn, colnames, int_bases, string_trim, ignorerepeated, limit, line_informat!, track_problems, total_line_skipped, Characters_types, TimeType_types)
    n_cols = length(types)
    line_start = 1
    dlm_pos = 0
    #keeping track of number of warnings
    warn_pass_end_of_line = 0
    dlmstr === nothing ? dlm_length = 1  : dlm_length = length(dlm)
    anything_is_wrong = 0
    any_problem_with_parsing = 0
    current_loc_track_problems = 1
    while true

        # keep track of Characters and DateTime columns
        char_cnt = 0
        dt_cnt = 0

        line_end = find_end_of_line(buffer.data, line_start, last_valid_buff, eol)
       
        if line_informat! !== nothing
            for ptrs in line_informat!
                (line_start, line_end) = ccall(ptrs, Tuple{Int, Int}, (Vector{UInt8}, Int, Int), buffer.data, line_start, line_end)
            end
        end
        field_start = line_start
        any_problem_with_parsing = 0
        for j in 1:n_cols
            if in(j, Characters_types)
                char_cnt += 1
            elseif in(j, TimeType_types)
                dt_cnt += 1
            end
            selected_int_base = 10
            if !isempty(int_bases)
                selected_int_base = get(int_bases, j, 10)
            end
            # if there is no fixed width information for the current column
            if fixed === 0:0 || fixed[j].start === 0
                if quotechar !== nothing
                    dlm_pos, new_lo, new_hi = find_next_delim(buffer.data, field_start, line_end, dlm, dlmstr, quotechar, escapechar, ignorerepeated)
                    if new_lo != 0 && new_hi != 0 && new_lo <= new_hi
                        new_lo, new_hi = clean_escapechar!(buffer, new_lo, new_hi, quotechar, escapechar)
                    end
                else
                   dlm_pos, new_lo, new_hi = find_next_delim(buffer.data, field_start, line_end, dlm, dlmstr, ignorerepeated)
                end
                # we should have a strategy for this kind of problems, for now just let the end of line as endpoint                
                if dlm_pos == 0
                    # line_end + dlm_length : since later we use dlm_pos+1 for next field
                    dlm_pos = line_end + dlm_length
                    if j < n_cols
                        if Threads.atomic_add!(number_of_errors_happen_so_far, 1) <= warn
                            if colnames !== nothing
                                @info DLMERRORS_LINE(buffer.data, line_start, line_end, current_line[]+total_line_skipped, current_line[], false).message
                            end
                        end
                    end
                end
                
               anything_is_wrong = parse_data!(res, buffer, types, new_lo == 0 ? field_start : new_lo, new_hi == 0 ? dlm_pos - dlm_length : new_hi, current_line, charbuff, char_cnt, df, dt_cnt, j, informat, selected_int_base, string_trim)
                if anything_is_wrong == 1
                    change_true_tracker!(track_problems[1]::BitVector, j)
                    # track_problems[1][j] = true
                    if current_loc_track_problems < 21
                        change_loc_tracker!(track_problems[2]::Vector{UnitRange{Int}}, current_loc_track_problems, (new_lo == 0 ? field_start : new_lo), (new_hi == 0 ? dlm_pos - dlm_length : new_hi))
                        # track_problems[2][current_loc_track_problems] = (new_lo == 0 ? field_start : new_lo):(new_hi == 0 ? dlm_pos - dlm_length : new_hi)
                        current_loc_track_problems += 1
                    end
                end

                field_start = dlm_pos + 1

            else # we have a fixed width information for the current column
                offset = line_start - 1
                dlm_pos = fixed[j].stop + offset
                if dlm_pos > line_end
                    dlm_pos = line_end
                    warn_pass_end_of_line += 1
                    # TODO use better wording
                    if warn_pass_end_of_line < 5
                        @warn "for column $(j) in line $(current_line[]+total_line_skipped) the cursor goes beyond the line, and the value is truncated\n"
                    end
                end
                # dlm_pos doesn't contain dlm so it shouldn't be dlm_pos-1 like the non-fixed case
                anything_is_wrong = parse_data!(res, buffer, types, fixed[j].start + offset, dlm_pos, current_line, charbuff, char_cnt, df, dt_cnt, j, informat, selected_int_base, string_trim)
                if anything_is_wrong == 1
                    # track_problems[1][j] = true
                    change_true_tracker!(track_problems[1]::BitVector, j)
                    if current_loc_track_problems < 21
                        change_loc_tracker!(track_problems[2]::Vector{UnitRange{Int}}, current_loc_track_problems, (fixed[j].start + offset), (dlm_pos))
                        # track_problems[2][current_loc_track_problems] = (fixed[j].start + offset):(dlm_pos)
                        current_loc_track_problems += 1
                    end
                end

                field_start = dlm_pos + 1
            end
            any_problem_with_parsing += anything_is_wrong
            dlm_pos > line_end && break
        end
       if dlm_pos < line_end
            if Threads.atomic_add!(number_of_errors_happen_so_far, 1) <= warn
                if colnames !== nothing
                    @info DLMERRORS_LINE(buffer.data, line_start, line_end, current_line[]+total_line_skipped, current_line[], true).message
                end
            end
        end
        if any_problem_with_parsing>0
            if Threads.atomic_add!(number_of_errors_happen_so_far, 1) <= warn
                if colnames !== nothing
                    @warn DLMERRORS_PARSE_ERROR(buffer.data, line_start, line_end, res, current_line[], colnames, track_problems, current_line[]+total_line_skipped).message
                end
            end
            # reset track_problems
            fill!(track_problems[1], false)
            fill!(track_problems[2], 0:0)
            current_loc_track_problems = 1
        end

        line_start = line_end + length(eol) + 1
        current_line[] += 1
        current_line[] > limit && return
        line_start > last_valid_buff && break
    end

end

# different function for reading multiple observations per line - the main difference is: here we push one observation at a time
function _process_iobuff_multiobs!(res, buffer, types, dlm, eol, current_line, last_valid_buff, charbuff, df, dlmstr, informat, quotechar, escapechar, warn, colnames, int_bases, string_trim, ignorerepeated, limit, track_problems, Characters_types, TimeType_types)
    n_cols = length(types)
    line_start = 1


    dlmstr === nothing ? dlm_length = 1  : dlm_length = length(dlm)
    anything_is_wrong = 0
    any_problem_with_parsing = 0
    current_loc_track_problems = 1
    j = 1
    field_start = 1
    read_one_obs = false
    
    line_end = find_end_of_line(buffer.data, line_start, last_valid_buff, eol)
    while true
        # keep track of Characters and DateTime columns
        char_cnt = 0
        dt_cnt = 0

        
        if in(j, Characters_types)
            char_cnt += 1
        elseif in(j, TimeType_types)
            dt_cnt += 1
        end
        selected_int_base = get(int_bases, j, 10)

        if quotechar !== nothing
            dlm_pos, new_lo, new_hi = find_next_delim(buffer.data, field_start, line_end, dlm, dlmstr, quotechar, escapechar, ignorerepeated)
            if new_lo != 0 && new_hi != 0 && new_lo <= new_hi
                new_lo, new_hi = clean_escapechar!(buffer, new_lo, new_hi, quotechar, escapechar)
            end
        else
            dlm_pos, new_lo, new_hi = find_next_delim(buffer.data, field_start, line_end, dlm, dlmstr, ignorerepeated)
        end
        # we should have a strategy for this kind of problems, for now just let the end of line as endpoint
        dlm_pos == 0 ? dlm_pos = line_end + dlm_length : nothing
        anything_is_wrong = parse_data!(res, buffer, types, new_lo == 0 ? field_start : new_lo, new_hi == 0 ? dlm_pos - dlm_length : new_hi, current_line, charbuff, char_cnt, df, dt_cnt, j, informat, selected_int_base, string_trim)
        if anything_is_wrong == 1
            # track_problems[1][j] = true
            change_true_tracker!(track_problems[1]::BitVector, j)
            if current_loc_track_problems < 21
                change_loc_tracker!(track_problems[2]::Vector{UnitRange{Int}}, current_loc_track_problems, (new_lo == 0 ? field_start : new_lo), (new_hi == 0 ? dlm_pos - dlm_length : new_hi))
                # track_problems[2][current_loc_track_problems] = (new_lo == 0 ? field_start : new_lo):(new_hi == 0 ? dlm_pos - dlm_length : new_hi)
                current_loc_track_problems += 1
            end
        end
        field_start = dlm_pos + 1
        read_one_obs = true
        any_problem_with_parsing += anything_is_wrong

        if j == n_cols && any_problem_with_parsing>0
            if Threads.atomic_add!(number_of_errors_happen_so_far, 1) <= warn
                if colnames !== nothing
                    # since each observation may spread in multiple lines, we cannot determine the line number where problem happened
                    @warn DLMERRORS_PARSE_ERROR(buffer.data, line_start, line_end, res, current_line[], colnames, track_problems, "UNKNOWN").message
                end
            end
            # reset track_problems
            fill!(track_problems[1], false)
            fill!(track_problems[2], 0:0)
            current_loc_track_problems = 1
        end

        j = j + 1
        if j > n_cols
            map(x->push!(x, missing), res)
            read_one_obs = false
            current_line[] += 1
            current_line[]> limit && return read_one_obs
            j = 1
            any_problem_with_parsing = 0
        end


        if dlm_pos > line_end
            line_start = line_end + length(eol) + 1
            field_start = line_start
            line_end = find_end_of_line(buffer.data, line_start, last_valid_buff, eol)
        end
        line_start > last_valid_buff && break
    end
    read_one_obs
end


# lo is the beginning of the read and hi is the end of read. hi should be end of file or a linebreak
function readfile_chunk!(res, llo, lhi, charbuff, path, types, n, lo, hi, colnames; delimiter = ',', linebreak = '\n', lsize = 2^15, buffsize = 2^16, fixed = 0:0, df = dateformat"yyyy-mm-dd", dlmstr = nothing, informat = Dict{Int, Symbol}(), escapechar = nothing, quotechar = nothing, warn = 20, eolwarn = true, int_bases = Dict{Int, Int}(), string_trim = false, ignorerepeated = false, multiple_obs = false, limit = typemax(Int), line_informat = nothing, total_line_skipped = 0)
    read_one_obs = true
    f = OUR_OPEN(path, read = true)

    _Characters_types = findall(x->x <: Characters, types)
    if length(_Characters_types) > 15 
        Characters_types = Set(_Characters_types)
    else
        Characters_types = _Characters_types
    end

    _TimeType_types = findall(x->x <: TimeType, types)
    if length(_TimeType_types) > 15
        TimeType_types = Set(_TimeType_types)
    else
        TimeType_types = _TimeType_types
    end



    try
        if dlmstr === nothing
            dlm = UInt8.(delimiter)
        elseif dlmstr isa AbstractString
            dlm = collect(codeunits(dlmstr))
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

        # to track parsing problem for better warnings
        # second part of track_problems keep the location of the probem in the current line
        track_problems = [falses(length(types)), [0:0 for _ in 1:20]]

        # TODO we should have a strategy when line is too long
        while true
            cnt_read_bytes = readbytes!(f, buffer.data)
            if cnt_read_bytes == 0
                return res
            end
            cur_position = position(f)

            if !eof(f) && cur_position < hi
                if buffer.data[end] !== eol_last || buffer.data[end - eol_len + 1] !== eol_first
                    #this means the buffer is not ended with a eol char, so we move back into buffer to have complete line
                    back_cnt = 0
                    for i in buffsize:-1:1
                        last_valid_buff = i
                        buffer.data[i] == eol_last && buffer.data[i - eol_len + 1] == eol_first && break
                        back_cnt += 1
                        i < buffsize/4 && throw(ArgumentError("It is difficult to reach end of lines, either linebreak (current value : $(length(eol) == 1 ? Char.([linebreak]) : Char.(eol))) is not detected properly or `lsize` and/or `buffsize` are too small."))
                    end
                    cur_position = position(f)
                    seek(f, cur_position - back_cnt)
                else
                    last_valid_buff = buffsize
                end
            elseif cur_position == hi
                last_line = true
                if buffer.data[cnt_read_bytes] != eol_last || buffer.data[cnt_read_bytes - eol_len + 1] != eol_first
                    if eolwarn
                        @warn "the last line is not ended with `end of line` character"
                    end
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
            # if we read more than what is allowed for the current chunk, we should revise the last_valid_buff   
            else cur_position > hi
                last_line = true
                last_valid_buff = cnt_read_bytes - (cur_position - hi)
            end
            if multiple_obs
                read_one_obs = _process_iobuff_multiobs!(res, buffer, types, dlm, eol, current_line, last_valid_buff, charbuff, df, dlmstr, informat, quotechar, escapechar, warn, colnames, int_bases, string_trim, ignorerepeated, limit, track_problems, Characters_types, TimeType_types)
            else
                _process_iobuff!(res, buffer, types, dlm, eol, current_line, last_valid_buff, charbuff, df, fixed, dlmstr, informat, quotechar, escapechar, warn, colnames, int_bases, string_trim, ignorerepeated, limit, line_informat, track_problems, total_line_skipped, Characters_types, TimeType_types)
            end
                # we need to break at some point
            current_line[] > limit && break
            last_line && break
        end
    catch e
        CLOSE(f)
        rethrow(e)
    end
    CLOSE(f)
    if !read_one_obs
        map(x->pop!(x), res)
    end
    res
end

# main distributer
function distribute_file(path, types; delimiter=',', linebreak='\n', header=true, threads=true, guessingrows=20, fixed=0:0, buffsize=2^16, dtformat=dateformat"yyyy-mm-dd", lsize=2^15, dlmstr=nothing, informat=Dict{Int,Symbol}(), escapechar=nothing, quotechar=nothing, warn=20, eolwarn=true, emptycolname=false, int_bases=Dict{Int,Int}(), string_trim=false, makeunique=false, ignorerepeated=false, multiple_obs=false, skipto=1, limit=typemax(Int), line_informat=nothing)::Dataset

    eol = UInt8.(linebreak)
    eol_first = first(eol)
    eol_last = last(eol)
    eol_len = length(eol)
    colwidth = 0:0

    total_line_skipped = skipto - 1 + (header == true)

    f = OUR_OPEN(path, read=true)
    # generating varnames
    f_pos = 0
    if skipto != 1
        _fsize_ = FILESIZE(f)
        l_length, f_pos = read_multiple_lines(path, f_pos, _fsize_, eol, skipto - 1)
    else
        f_pos = 0
    end

    if !multiple_obs

        lsize_estimate = estimate_linesize(path, eol, lsize, f_pos+1, guessingrows=guessingrows)
        if lsize_estimate == 0 # TODO we need a better strategy
            lsize_estimate = lsize
        end

        lsize_estimate > lsize && throw(ArgumentError("the lines are larger than $lsize, increase buffers by setting `lsize` and `buffsize` arguments, they are currently set as $lsize and $buffsize respectively"))
        if fixed != 0:0
            colwidth = Vector{UnitRange{Int}}(undef, length(types))
            for i in 1:length(colwidth)
                colwidth[i] = get(fixed, i, 0:0)
            end
        else
            colwidth = 0:0
        end
    end

    if (header isa AbstractVector) && (eltype(header) <: Union{AbstractString,Symbol})
        # colnames = header
        colnames = Symbol.(header)
        if makeunique
            colnames = InMemoryDatasets.make_unique(colnames; makeunique=makeunique)
        end
    elseif header === true
        f_pos, colnames = _generate_colname_based(path, eol, f_pos + 1, lsize, lsize, types, delimiter, linebreak, buffsize, colwidth, dlmstr, quotechar, escapechar, emptycolname, ignorerepeated, multiple_obs, line_informat, total_line_skipped)
        isempty(colnames) && throw(ArgumentError("Detecting column names return empty array, this can happen if your file is empty or the column names are not detectable."))
        colnames = InMemoryDatasets.make_unique(colnames; makeunique=makeunique)
    elseif header === false
        colnames = [Symbol("x" * string(k)) for k in 1:length(types)]
    else
        throw(ArgumentError("`header` can be true or false, or a list of variable names"))
    end
    @assert length(types) == length(colnames) "Number of columns $(length(types)) and number of column names $(length(colnames)) are not equal"
    if !multiple_obs
        # how many bytes we should skip - we should use this information to have a better distribution of file into nt chunks.
        skip_bytes = f_pos
        fs = FILESIZE(f)
        initial_guess_for_row_num = (fs - skip_bytes) / lsize_estimate
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
    else
        nt = 1
    end


    charbuff = Vector{Vector{UInt8}}()

    # this is a temp approach to TimeType parsing, later we should use DT{N} structure to parse TimeType
    if dtformat isa Dict
        dtfmt = Vector{valtype(dtformat)}()
    else
        dtfmt = Vector{typeof(_todate(dtformat))}()
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
            if dtformat isa Dict
                push!(dtfmt, _todate(get(dtformat, j, ISODateFormat)))
            else
                push!(dtfmt, _todate(dtformat))
            end
        end
    end
    charbuff = [deepcopy(charbuff) for _ in 1:nt]
    # reset number of warnings
    number_of_errors_happen_so_far[] = 1
    if !multiple_obs
        line_lo, line_hi, lo, hi, ns, last_chunk_to_read = dist_calc(f, path, fs, skip_bytes, nt, eol, eol_len, eol_last, eol_first, limit)

        # revised calculation - if limit is set
        if nt > 1 && last_chunk_to_read < nt
            line_lo, line_hi, lo, hi, ns, last_chunk_to_read = dist_calc(f, path, hi[last_chunk_to_read], skip_bytes, nt, eol, eol_len, eol_last, eol_first, limit)
        end

        # res = Any[allocatecol_for_res(types[i], min(sum(ns), limit)) for i in 1:length(types)]
        res = Any[allocatecol_for_res(types[i], 0) for i in 1:length(types)]
        _resize_res_barrier!(res, types, min(sum(ns), limit), threads)

        CLOSE(f)

        if nt > 1
            Threads.@threads for i in 1:min(nt, last_chunk_to_read)
                line_lo[i] > line_hi[i] && continue
                readfile_chunk!(res, line_lo[i], line_hi[i], charbuff[i], path, types, ns[i], lo[i], hi[i], colnames; delimiter=delimiter, linebreak=linebreak, lsize=lsize, buffsize=buffsize, fixed=colwidth, df=dtfmt, dlmstr=dlmstr, informat=informat, escapechar=escapechar, quotechar=quotechar, warn=warn, eolwarn=eolwarn, int_bases=int_bases, string_trim=string_trim, ignorerepeated=ignorerepeated, limit=limit, line_informat=line_informat, total_line_skipped=total_line_skipped)
            end
        else
            for i in 1:1
                readfile_chunk!(res, line_lo[i], line_hi[i], charbuff[i], path, types, ns[i], lo[i], hi[i], colnames; delimiter=delimiter, linebreak=linebreak, lsize=lsize, buffsize=buffsize, fixed=colwidth, df=dtfmt, dlmstr=dlmstr, informat=informat, escapechar=escapechar, quotechar=quotechar, warn=warn, eolwarn=eolwarn, int_bases=int_bases, string_trim=string_trim, ignorerepeated=ignorerepeated, limit=limit, line_informat=line_informat, total_line_skipped=total_line_skipped)
            end
        end
    else
        res = Any[allocatecol_for_res(types[i], 1) for i in 1:length(types)]
        readfile_chunk!(res, 1, 1, charbuff[1], path, types, 1, f_pos + 1, FILESIZE(path), colnames; delimiter=delimiter, linebreak=linebreak, lsize=lsize, buffsize=buffsize, fixed=colwidth, df=dtfmt, dlmstr=dlmstr, informat=informat, escapechar=escapechar, quotechar=quotechar, warn=warn, eolwarn=eolwarn, int_bases=int_bases, string_trim=string_trim, ignorerepeated=ignorerepeated, multiple_obs=true, limit=limit, total_line_skipped=total_line_skipped)
    end

    Dataset(res, colnames, copycols=false, makeunique=makeunique)
end


function guess_structure_of_delimited_file(path, delimiter; linebreak = nothing , header = true, guessingrows = 20, fixed = 0:0, dtformat = nothing, dlmstr = nothing, lsize = 2^15, buffsize = 2^16, informat = Dict{Int, Symbol}(), escapechar = nothing, quotechar = nothing, eolwarn = false, ignorerepeated = false, skipto = 1, line_informat = nothing)

    if linebreak === nothing
        linebreak = (guess_eol_char(path))
    end
    total_line_skipped = skipto - 1 + (header == true)
    eol = UInt8.(linebreak)
    eol_last = last(eol)
    eol_first = first(eol)
    eol_len = length(eol)
    if dlmstr === nothing
        dlm = UInt8.(delimiter)
    elseif dlmstr isa AbstractString
        dlm = collect(codeunits(dlmstr))
    else
        throw(ArgumentError("`dlmstr` must be a string of ASCII characters"))
    end
    read_byte_val = Vector{UInt8}(undef, eol_len)

    f = OUR_OPEN(path, read = true)

    f_pos = 0
    if skipto != 1
        _fsize_ = FILESIZE(f)
        l_length, f_pos = read_multiple_lines(path, f_pos, _fsize_, eol, skipto-1)
    else
        f_pos = 0
    end

    cnt = 1
    n_cols = 0
    col_width = 0:0

    if fixed isa Dict
        colwidth = UnitRange{Int}[]
    else
        colwidth = 0:0
    end
    l_length, _tmp_f_pos = read_one_line(path, f_pos+1, FILESIZE(f), eol)
    if l_length > lsize
        throw(ArgumentError("very wide delimited file! you need to set `lsize` and `buffsize` argument with larger values,  they are currently set as $lsize and $buffsize respectively. It is also recommended to use lower number of `guessingrows`"))
    end
    seek(f, f_pos)

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
            if quotechar !== nothing
                new_dlm_pos, new_lo, new_hi = find_next_delim(a_line_buff, nb_pos+1, l_length, dlm, dlmstr, quotechar, escapechar, ignorerepeated)
            else
                new_dlm_pos,new_lo, new_hi = find_next_delim(a_line_buff, nb_pos+1, l_length, dlm, dlmstr, ignorerepeated)
            end
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
        lo = _tmp_f_pos+1
    else
        lo = f_pos+1
    end
    seek(f, lo)
    rows_in = 0
    l_length = 1
    file_pos = max(0, lo - 1)
    while l_length>0
        l_length, file_pos = read_one_line(path, file_pos+1, FILESIZE(f), eol)
        if l_length > 0
            rows_in += 1
        end
        rows_in > guessingrows && break
    end
    hi = file_pos
    types = repeat([String], n_cols)
    res = [allocatecol_for_res(String, rows_in) for _ in 1:n_cols]
    readfile_chunk!(res, 1, rows_in, [], path, types, rows_in, lo, hi, nothing; delimiter = delimiter, linebreak = linebreak, buffsize = buffsize, fixed = colwidth, dlmstr = dlmstr, lsize = lsize, informat = informat, quotechar = quotechar, escapechar = escapechar, eolwarn = eolwarn, ignorerepeated = ignorerepeated, line_informat = line_informat, total_line_skipped = total_line_skipped)
    outtypes = Vector{DataType}(undef, n_cols)
    if !(dtformat isa Dict)
        for j in 1:n_cols
            old_cnt_vals = 0
            if all(isequal.(missing, res[j]))
                outtypes[j] = String
                continue
            end
            #TODO should we apply format here or in readfile_chunk! in the above?
            outtypes[j] = r_type_guess(res[j], identity)
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
                if all(isequal.(missing, res[j]))
                    outtypes[j] = String
                    continue
                end
                outtypes[j] = r_type_guess(res[j], identity)
            end
        end
    end
    CLOSE(f)
    linebreak, outtypes
end


"""
    filereader(path; [...])

Read a delimited file into `Julia`.

# Keyword arguments

* `types`: User can pass the types of each column of the input file by using the `types` keyword argument. User may pass a vector of types which includes every type of each column, or may pass a dictionary of types for few selected columns.
* `delimiter`: To change the default delimiter, user must pass the `delimiter` keyword argument. The `delimiter` keyword argument only accept `Char` as delimiter. Additionally, user can pass a vector of `Char` which causes `filereader` to use them as alternative delimiters.
* `dlmstr`: This keyword argument is used to pass a string as the delimiter for values.
* `ignorerepeated`: If it is set as `true`, repeated delimiters will be ignored.
* `header`: User must set this as `false` if the first line of the input file is not the column header. Additionally, user can pass a vector of columns' name, which will be used as the columns' header.
* `linebreak`: The `filereader` function use the value of this option as line separator. It can accept a `Char` or a vector of `Char` where the length of the vector is less than or equal two. For some rare cases user may need to pass this option to assist `filereader` in reading the input file.
* `guessingrows`: This provide the number of lines to be used for types detection. The `filereader` function will detect the types of the column more accurately if user increase this value, however, it costs more computation time.
* `fixed`: This option is used for reading fixed width files. User must pass a dictionary of columns' locations (as a range) for reading a fixed width file.
* `quotechar`: If the texts are quoted in the input file, user must pass the quoted character via this keyword argument.
* `escapechar`: Declaring the escape char for quoted text.
* `dtformat`: User must pass the date format of DateTime columns if they are different from the standard format. The `dtformat` keyword argument accept a dictionary of values.
* `int_base`: The `filereader` can read integers with given base. User must pass this information for a specific column.
* `informat`: User can pass a dictionary which provides the information of the `informat` of selected columns.
* `skipto`: It can be used to start reading a file from specific location.
* `limit`: It can be used to limit the number of observations read from the input file.
* `multiple_obs`: If it is set as `true`, the `filereader` function assumes there are more than one observation in each line of the input file.
* `line_informat`: User can provide line informat via this keyword argument.
* `buffsize`: User can provide any positive number for the buffer size. Each thread allocates the amount of `buffsize` and reads the values from the input file into it.
* `lsize`: It indicated the line buffer size for reading the input files. For very wide table use may need to manually adjust this option. Its value must be less than `buffsize`.
* `string_trim`: Setting this as `true` will trim the trailing blanks of strings before storing them into the output data set.
* `makeunique`: If there are non-unique columns' names, this can resolve it by adding a suffix to the names.
* `emptycolname`: If it is set to `true`, it generates a column name for columns with empty name.
* `warn`: Control the maximum number of warning and information. Setting it to 0 will suppress warnings and information during reading the input file.
* `eolwarn`: Control if the end-of-line character warning should be shown.
* `threads`: For large files, the `filereader` function exploits all threads. However, this can be switch off by setting this argument as `false`.
"""
function filereader(path; types = nothing, delimiter::Union{Char, Vector{Char}} = ',', linebreak::Union{Nothing, Char, Vector{Char}} = nothing, header = true, threads::Bool = true, guessingrows::Int = 20, fixed::Union{<:UnitRange, Dict{Int, <:UnitRange}} = 0:0, buffsize::Int = 2^16, quotechar::Union{Nothing, Char} = nothing, escapechar::Union{Nothing, Char} = nothing, dtformat = dateformat"yyyy-mm-dd", dlmstr::Union{Nothing, <:AbstractString} = nothing, lsize::Int = 2^15, informat = Dict(), warn::Int = 20, eolwarn::Bool = true, emptycolname::Bool = false, int_base::Dict{Int, Int} = Dict{Int, Int}(), string_trim::Bool = false, makeunique::Bool = false, ignorerepeated::Bool = false, multiple_obs::Bool = false, skipto::Int = 1, limit::Int = typemax(Int), line_informat = nothing)::Dataset
    
    infmt = Dict{Int, Vector{Ptr{Nothing}}}()
    if !isempty(informat)
        for (k,v) in informat
           push!(infmt , k => _get_ptr_informat!(Ptr{Nothing}[], DLMReader_Registered_Informats, v))
        end
    end

    if line_informat === nothing
        l_infmt = nothing
    else
        l_infmt = _get_ptr_informat!(Ptr{Nothing}[], DLMReader_Registered_Informats, line_informat)
    end


    supported_types = [Bool, Int8, Int16, Int32, Int64, Int8, UInt16, UInt32, UInt64, Float32, Float64, Int128, UInt128, BigFloat, String1, String3, String7, String15, String31, String63, String127, String255, InlineString1, InlineString3, InlineString7, InlineString15, InlineString31, InlineString63, InlineString127, InlineString255,  Characters{1},  Characters{2}, Characters{3}, Characters{4}, Characters{5}, Characters{6}, Characters{7}, Characters{8}, Characters{9}, Characters{10}, Characters{11}, Characters{12}, Characters{13}, Characters{14}, Characters{15}, Characters{16}, TimeType, DateTime, Date, Time, String, UUID]
    
    lsize > buffsize && throw(ArgumentError("`lsize` cannot be larger than `buffsize`"))
    ignorerepeated && dlmstr !== nothing && throw(ArgumentError("`ignorerepeated` option cannot be used when `dlmstr` is set"))

    guessingrows = min(guessingrows, limit)

    number_of_errors_happen_so_far[] = 0
    
    if quotechar !== nothing
        quotechar = UInt8(quotechar)
        if escapechar !== nothing
            escapechar = UInt8(escapechar)
        else
            escapechar = UInt8('\\')
        end
    end

    if multiple_obs
        !(types isa AbstractVector) && throw(ArgumentError("For reading multiple observations per line the types of each column must be specified"))
        fixed != 0:0 && throw(ArgumentError("When multiple observations per line is `true` the `fixed` keyword argument cannot be used"))
    end

    if types === nothing || types isa Dict
        linebreak, intypes = guess_structure_of_delimited_file(path, delimiter; linebreak = linebreak, header = header, guessingrows = guessingrows, fixed = fixed, buffsize = buffsize, dtformat = dtformat, dlmstr = dlmstr, lsize = lsize, informat = infmt, escapechar = escapechar, quotechar = quotechar, eolwarn = false, ignorerepeated = ignorerepeated, skipto = skipto, line_informat = l_infmt)
        if types isa Dict
            for (k, v) in types
                intypes[k] = v
            end
        end
    elseif types isa AbstractVector && eltype(types) <: Union{DataType,Type}
        intypes = types
        if linebreak === nothing
            linebreak = guess_eol_char(path)
        end
    else
        throw(ArgumentError("types should be a vector of types"))
    end
    # update intypes with information about integer base - by default we assume integers are base 10
    if !isempty(int_base)
        for (k, v) in int_base
            # if int_base is set for the kth columun and its type is something else change its type to Int
            if !(intypes[k] <: Integer)
                intypes[k] = Int
            end
        end
    end

    !all(intypes .∈ Ref(Set(supported_types))) && throw(ArgumentError("DLMReaser only supports the following types(and their Subtypes): Bool, Integers, Floats, BigFloat, Characters, TimeType, String, InlineString, UUID"))
    !all(isascii.(delimiter)) && throw(ArgumentError("delimiter must be ASCII"))

    if multiple_obs
        if header == true
            throw(ArgumentError("`filereader` doesn't support reading header from file when `multiple_obs = true`"))
        end
        if line_informat !== nothing
            throw(ArgumentError("`filereader` doesn't support `line_informat` when `multiple_obs = true`"))
        end
    end

    distribute_file(path, intypes; delimiter = delimiter, linebreak = linebreak, header = header, threads = threads, guessingrows = guessingrows, fixed = fixed, buffsize = buffsize, dtformat = dtformat, dlmstr = dlmstr, lsize = lsize, informat = infmt, escapechar = escapechar, quotechar = quotechar, warn = warn, eolwarn = eolwarn, emptycolname = emptycolname, int_bases = int_base, string_trim = string_trim, makeunique = makeunique, ignorerepeated = ignorerepeated, multiple_obs = multiple_obs, skipto = skipto, limit = limit, line_informat = l_infmt)
end
