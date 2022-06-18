function parse_data!(res, buffer, types, lo::Int, hi::Int, current_line, char_buff, char_cnt, df, dt_cnt, j, informat, int_bases, string_trim)
    flag = 0
    cc = lo
    en = hi
    if informat !== nothing
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
       flag = buff_parser(res[j]::Vector{Union{Missing, Int64}}, buffer, cc, en, current_line[], Int64; base = int_bases)
    elseif types[j] === Float64
       flag = buff_parser(res[j]::Vector{Union{Missing, Float64}}, buffer.data, cc, en, current_line[], Float64)
    elseif types[j] === Bool
        flag = buff_parser(res[j]::Vector{Union{Missing, Bool}}, buffer, cc, en, current_line[], Bool)
    elseif types[j] === Date
        flag = buff_parser(res[j]::Vector{Union{Missing, Date}}, buffer, cc, en, current_line[], df[dt_cnt], Date)
    elseif types[j] === DateTime
        flag = buff_parser(res[j]::Vector{Union{Missing, DateTime}}, buffer, cc, en, current_line[], df[dt_cnt], DateTime)
    elseif types[j] === String
        if string_trim
            flag = buff_parser(res[j]::Vector{Union{Missing, String}}, buffer.data, cc, en, current_line[], string_trim, String)
        else
            flag = buff_parser(res[j]::Vector{Union{Missing, String}}, buffer.data, cc, en, current_line[], String)
        end
    elseif types[j] === Int32
        flag = buff_parser(res[j]::Vector{Union{Missing, Int32}}, buffer, cc, en, current_line[], Int32; base = int_bases)
    elseif types[j] === Float32
        flag = buff_parser(res[j]::Vector{Union{Missing, Float32}}, buffer.data, cc, en, current_line[], Float32)
    elseif types[j] === Int8
        flag = buff_parser(res[j]::Vector{Union{Missing, Int8}}, buffer, cc, en, current_line[], Int8; base = int_bases)
    elseif types[j] === Int16
        flag = buff_parser(res[j]::Vector{Union{Missing, Int16}}, buffer, cc, en, current_line[], Int16; base = int_bases)
    elseif types[j] === String1
        flag = buff_parser(res[j]::Vector{Union{Missing,String1}}, buffer.data, cc, en, current_line[],String1)
    elseif types[j] === String3
        flag = buff_parser(res[j]::Vector{Union{Missing,String3}}, buffer.data, cc, en, current_line[],String3)
    elseif types[j] === String7
        flag = buff_parser(res[j]::Vector{Union{Missing,String7}}, buffer.data, cc, en, current_line[],String7)
    elseif types[j] === String15
        flag = buff_parser(res[j]::Vector{Union{Missing,String15}}, buffer.data, cc, en, current_line[],String15)
    elseif types[j] === Characters{3}
        flag = buff_parser(res[j]::Vector{Union{Missing,Characters{3}}}, buffer.data, cc, en, current_line[], char_buff[char_cnt]::Vector{UInt8}, Characters{3})
    elseif types[j] === Characters{5}
        flag = buff_parser(res[j]::Vector{Union{Missing,Characters{5}}}, buffer.data, cc, en, current_line[], char_buff[char_cnt]::Vector{UInt8}, Characters{5})
    elseif types[j] === Characters{8}
        flag = buff_parser(res[j]::Vector{Union{Missing,Characters{8}}}, buffer.data, cc, en, current_line[], char_buff[char_cnt]::Vector{UInt8}, Characters{8})
    elseif types[j] === Characters{10}
        flag = buff_parser(res[j]::Vector{Union{Missing,Characters{10}}}, buffer.data, cc, en, current_line[], char_buff[char_cnt]::Vector{UInt8}, Characters{10})
    elseif types[j] === Characters{11}
        flag = buff_parser(res[j]::Vector{Union{Missing,Characters{11}}}, buffer.data, cc, en, current_line[], char_buff[char_cnt]::Vector{UInt8}, Characters{11})
    elseif types[j] === Characters{12}
        flag = buff_parser(res[j]::Vector{Union{Missing,Characters{12}}}, buffer.data, cc, en, current_line[], char_buff[char_cnt]::Vector{UInt8}, Characters{12})
    elseif types[j] === Characters{13}
        flag = buff_parser(res[j]::Vector{Union{Missing,Characters{13}}}, buffer.data, cc, en, current_line[], char_buff[char_cnt]::Vector{UInt8}, Characters{13})
    elseif types[j] === Characters{14}
        flag = buff_parser(res[j]::Vector{Union{Missing,Characters{14}}}, buffer.data, cc, en, current_line[], char_buff[char_cnt]::Vector{UInt8}, Characters{14})
    elseif types[j] === Characters{15}
        flag = buff_parser(res[j]::Vector{Union{Missing,Characters{15}}}, buffer.data, cc, en, current_line[], char_buff[char_cnt]::Vector{UInt8}, Characters{15})
    elseif types[j] === Characters{1}
        flag = buff_parser(res[j]::Vector{Union{Missing,Characters{1}}}, buffer.data, cc, en, current_line[], char_buff[char_cnt]::Vector{UInt8}, Characters{1})
    elseif types[j] === Characters{2}
        flag = buff_parser(res[j]::Vector{Union{Missing,Characters{2}}}, buffer.data, cc, en, current_line[], char_buff[char_cnt]::Vector{UInt8}, Characters{2})
    elseif types[j] === Characters{4}
        flag = buff_parser(res[j]::Vector{Union{Missing,Characters{4}}}, buffer.data, cc, en, current_line[], char_buff[char_cnt]::Vector{UInt8}, Characters{4})
    elseif types[j] === Characters{6}
        flag = buff_parser(res[j]::Vector{Union{Missing,Characters{6}}}, buffer.data, cc, en, current_line[], char_buff[char_cnt]::Vector{UInt8}, Characters{6})
    elseif types[j] === Characters{7}
        flag = buff_parser(res[j]::Vector{Union{Missing,Characters{7}}}, buffer.data, cc, en, current_line[], char_buff[char_cnt]::Vector{UInt8}, Characters{7})
    elseif types[j] === Characters{9}
        flag = buff_parser(res[j]::Vector{Union{Missing,Characters{9}}}, buffer.data, cc, en, current_line[], char_buff[char_cnt]::Vector{UInt8}, Characters{9})
    elseif types[j] === Characters{16}
        flag = buff_parser(res[j]::Vector{Union{Missing,Characters{16}}}, buffer.data, cc, en, current_line[], char_buff[char_cnt]::Vector{UInt8}, Characters{16})
    elseif types[j] === Time
        flag = buff_parser(res[j]::Vector{Union{Missing, Time}}, buffer, cc, en, current_line[], df[dt_cnt], Time)
    elseif types[j] === String31
        flag = buff_parser(res[j]::Vector{Union{Missing,String31}}, buffer.data, cc, en, current_line[],String31)
    elseif types[j] === String63
        flag = buff_parser(res[j]::Vector{Union{Missing,String63}}, buffer.data, cc, en, current_line[],String63)
    elseif types[j] === String127
        flag = buff_parser(res[j]::Vector{Union{Missing,String127}}, buffer.data, cc, en, current_line[],String127)
    elseif types[j] === String255
        flag = buff_parser(res[j]::Vector{Union{Missing,String255}}, buffer.data, cc, en, current_line[],String255)
    elseif types[j] === UInt8
        flag = buff_parser(res[j]::Vector{Union{Missing, UInt8}}, buffer, cc, en, current_line[], UInt8; base = int_bases)
    elseif types[j] === UInt16
        flag = buff_parser(res[j]::Vector{Union{Missing, UInt16}}, buffer, cc, en, current_line[], UInt16; base = int_bases)
    elseif types[j] === UInt32
        flag = buff_parser(res[j]::Vector{Union{Missing, UInt32}}, buffer, cc, en, current_line[], UInt32; base = int_bases)
    elseif types[j] === UInt64
        flag = buff_parser(res[j]::Vector{Union{Missing, UInt64}}, buffer, cc, en, current_line[], UInt64; base = int_bases)
    elseif types[j] === Int128
        flag = buff_parser(res[j]::Vector{Union{Missing, Int128}}, buffer, cc, en, current_line[], Int128; base = int_bases)
    elseif types[j] === UInt128
        flag = buff_parser(res[j]::Vector{Union{Missing, UInt128}}, buffer, cc, en, current_line[], UInt128; base = int_bases)
    elseif types[j] === BigFloat
        flag = buff_parser(res[j]::Vector{Union{Missing, BigFloat}}, buffer, cc, en, current_line[], BigFloat)
    elseif types[j] === UUID
        flag = buff_parser(res[j]::Vector{Union{Missing, UUID}}, buffer, cc, en, current_line[], UUID)
    else # others are string
        flag = buff_parser(res[j]::Vector{Union{Missing, String}}, buffer.data, cc, en, current_line[], String)
    end
    flag
end


function _process_iobuff_parse!(res,
    buffer,
    types,
    dlm,
    eol,
    current_line,
    last_valid_buff,
    charbuff,
    df,
    fixed,
    dlmstr,
    informat,
    quotechar,
    escapechar,
    warn,
    colnames,
    int_bases,
    string_trim,
    ignorerepeated,
    limit,
    line_informat!,
    track_problems_1,
    track_problems_2,
    total_line_skipped,
    Characters_types,
    TimeType_types
    )

    n_cols = length(types)
    line_start = 1
    dlm_pos = 0
    #keeping track of number of warnings
    warn_pass_end_of_line = 0
    !dlmstr ? dlm_length = 1  : dlm_length = length(dlm)
    anything_is_wrong = 0
    any_problem_with_parsing = 0
    current_loc_track_problems = 1

    while true

        # keep track of Characters and DateTime columns
        char_cnt = 0
        dt_cnt = 0

        line_end = find_end_of_line(buffer.data, line_start, last_valid_buff, eol)
       
        # call line_informat if it exists
        if line_informat! !== nothing
            for ptrs in line_informat!
                (line_start, line_end) = ccall(ptrs, Tuple{Int, Int}, (Vector{UInt8}, Int, Int), buffer.data, line_start, line_end)
            end
        end

        field_start = line_start
        any_problem_with_parsing = 0

        for j in 1:n_cols
            if Characters_types !== nothing
                if in(j, Characters_types)
                    char_cnt += 1
                end
            end
            if TimeType_types !== nothing
                if in(j, TimeType_types)
                    dt_cnt += 1
                end
            end
            
            selected_int_base = 10
            if int_bases !== nothing
                selected_int_base = get(int_bases, j, 10)
            end
            # if there is no fixed width information for the current column
            if fixed === nothing || fixed[j].start === 0
                if quotechar !== nothing
                    dlm_pos, new_lo, new_hi = find_next_delim(buffer.data, field_start, line_end, dlm, dlmstr, quotechar, escapechar, ignorerepeated)
                    if new_lo != 0 && new_hi != 0 && new_lo <= new_hi
                        new_lo, new_hi = clean_escapechar!(buffer.data, new_lo, new_hi, quotechar)
                    end
                else
                   dlm_pos, new_lo, new_hi = find_next_delim(buffer.data, field_start, line_end, dlm, dlmstr, ignorerepeated)
                end

                if dlm_pos == 0
                    # line_end + dlm_length : since later we use dlm_pos+1 for next field
                    dlm_pos = line_end + dlm_length
                    if j < n_cols
                        # TODO we shouldn't call atomic_add! if already `number_of_errors_happen_so_far` is larger than warn - performance
                        if Threads.atomic_add!(number_of_errors_happen_so_far, 1) <= warn
                            if !isempty(colnames)
                                @info DLMERRORS_LINE(buffer.data, line_start, line_end, current_line[]+total_line_skipped, current_line[], false).message
                            end
                        end
                    end
                end
                
                anything_is_wrong = parse_data!(res, buffer, types, new_lo == 0 ? field_start : new_lo, new_hi == 0 ? dlm_pos - dlm_length : new_hi, current_line, charbuff, char_cnt, df,   dt_cnt, j, informat, selected_int_base, string_trim)

                if anything_is_wrong == 1
                    # we split track_problems to two components - now track_problems_1 and track_problems_2 are vector rather than any
                    change_true_tracker!(track_problems_1::BitVector, j)
                    # track_problems[1][j] = true
                    if current_loc_track_problems < 21
                        change_loc_tracker!(track_problems_2::Vector{UnitRange{Int}}, current_loc_track_problems, (new_lo == 0 ? field_start : new_lo), (new_hi == 0 ? dlm_pos - dlm_length : new_hi))
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
                    change_true_tracker!(track_problems_1::BitVector, j)
                    if current_loc_track_problems < 21
                        change_loc_tracker!(track_problems_2::Vector{UnitRange{Int}}, current_loc_track_problems, (fixed[j].start + offset), (dlm_pos))
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
                if !isempty(colnames)
                    @info DLMERRORS_LINE(buffer.data, line_start, line_end, current_line[]+total_line_skipped, current_line[], true).message
                end
            end
        end
        if any_problem_with_parsing>0
            if Threads.atomic_add!(number_of_errors_happen_so_far, 1) <= warn
                if !isempty(colnames)
                    @warn DLMERRORS_PARSE_ERROR(buffer.data, line_start, line_end, res, current_line[], colnames, track_problems_1, track_problems_2, current_line[]+total_line_skipped).message
                end
            end
            # reset track_problems
            fill!(track_problems_1, false)
            fill!(track_problems_2, 0:0)
            current_loc_track_problems = 1
        end

        line_start = line_end + length(eol) + 1
        current_line[] += 1
        current_line[] > limit && return
        line_start > last_valid_buff && break
    end
    nothing
end

function _process_iobuff_no_parse!(res::Matrix{Tuple{UInt32, UInt32}},
    buffer::LineBuffer,
    n_cols::Int,
    dlm::Vector{UInt8},
    eol::Vector{UInt8},
    current_line::Base.RefValue{Int},
    last_valid_buff::Int,
    fixed::Union{Nothing, Vector{UnitRange{Int}}},
    dlmstr::Bool,
    quotechar::Union{Nothing, UInt8},
    escapechar::Union{Nothing, UInt8},
    warn::Int,
    colnames::Vector{Symbol},
    ignorerepeated::Bool,
    limit::Int,
    line_informat!::Union{Nothing, Vector{Ptr{Nothing}}},
    total_line_skipped::Int,
    )

    line_start = 1
    dlm_pos = 0
    #keeping track of number of warnings
    warn_pass_end_of_line = 0
    !dlmstr ? dlm_length = 1  : dlm_length = length(dlm)
    any_problem_with_parsing = 0

    while true

    # keep track of Characters and DateTime columns

    line_end = find_end_of_line(buffer.data, line_start, last_valid_buff, eol)

    # call line_informat if it exists
    if line_informat! !== nothing
        for ptrs in line_informat!
            (line_start, line_end) = ccall(ptrs, Tuple{Int, Int}, (Vector{UInt8}, Int, Int), buffer.data, line_start, line_end)
        end
    end

    field_start = line_start
    any_problem_with_parsing = 0

    for j in 1:n_cols
        # if there is no fixed width information for the current column
        if fixed===nothing || fixed[j].start === 0
            if quotechar !== nothing
                dlm_pos, new_lo, new_hi = find_next_delim(buffer.data, field_start, line_end, dlm, dlmstr, quotechar, escapechar, ignorerepeated)
                if new_lo != 0 && new_hi != 0 && new_lo <= new_hi
                    new_lo, new_hi = clean_escapechar!(buffer.data, new_lo, new_hi, quotechar)
                end
            else
                dlm_pos, new_lo, new_hi = find_next_delim(buffer.data, field_start, line_end, dlm, dlmstr, ignorerepeated)

            end
            if dlm_pos == 0
                # line_end + dlm_length : since later we use dlm_pos+1 for next field
                dlm_pos = line_end + dlm_length
                if j < n_cols
                    for k in j+1:n_cols
                        res[current_line[], k] = (0, 0)
                    end
                    # TODO we shouldn't call atomic_add! if already `number_of_errors_happen_so_far` is larger than warn - performance
                    if Threads.atomic_add!(number_of_errors_happen_so_far, 1) <= warn
                        if !isempty(colnames)
                            @info DLMERRORS_LINE(buffer.data, line_start, line_end, current_line[]+total_line_skipped, current_line[], false).message
                        end
                    end
                end
            end
            
            res[current_line[], j] = (new_lo == 0 ? field_start : new_lo, new_hi == 0 ? max(0, dlm_pos - dlm_length) : new_hi)
            
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
            res[current_line[], j] = (fixed[j].start + offset, dlm_pos)

            field_start = dlm_pos + 1
        end
        dlm_pos > line_end && break
    end
    if dlm_pos < line_end
        if Threads.atomic_add!(number_of_errors_happen_so_far, 1) <= warn
            if !isempty(colnames)
                @info DLMERRORS_LINE(buffer.data, line_start, line_end, current_line[]+total_line_skipped, current_line[], true).message
            end
        end
    end

    line_start = line_end + length(eol) + 1
    current_line[] += 1
    current_line[] > limit && return
    line_start > last_valid_buff && break
    end
    nothing
end

function _process_iobuff_multiobs_parse!(res,
    buffer,
    types,
    dlm,
    eol,
    current_line,
    last_valid_buff,
    charbuff,
    df,
    dlmstr,
    informat,
    quotechar,
    escapechar,
    warn,
    colnames,
    int_bases,
    string_trim,
    ignorerepeated,
    limit,
    track_problems_1,
    track_problems_2,
    Characters_types,
    TimeType_types
    )::Bool

    n_cols = length(types)
    line_start = 1
    dlm_pos = 0
    #keeping track of number of warnings
    warn_pass_end_of_line = 0
    !dlmstr ? dlm_length = 1  : dlm_length = length(dlm)
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

        if Characters_types !== nothing
            if in(j, Characters_types)
                char_cnt += 1
            end
        end
        if TimeType_types !== nothing
            if in(j, TimeType_types)
                dt_cnt += 1
            end
        end
        
        selected_int_base = 10
        if int_bases !== nothing
            selected_int_base = get(int_bases, j, 10)
        end

        if quotechar !== nothing
            dlm_pos, new_lo, new_hi = find_next_delim(buffer.data, field_start, line_end, dlm, dlmstr, quotechar, escapechar, ignorerepeated)
            if new_lo != 0 && new_hi != 0 && new_lo <= new_hi
                new_lo, new_hi = clean_escapechar!(buffer.data, new_lo, new_hi, quotechar)
            end
        else
            dlm_pos, new_lo, new_hi = find_next_delim(buffer.data, field_start, line_end, dlm, dlmstr, ignorerepeated)
        end

        dlm_pos == 0 ? dlm_pos = line_end + dlm_length : nothing
        
        anything_is_wrong = parse_data!(res, buffer, types, new_lo == 0 ? field_start : new_lo, new_hi == 0 ? dlm_pos - dlm_length : new_hi, current_line, charbuff, char_cnt, df, dt_cnt, j, informat, selected_int_base, string_trim)

        if anything_is_wrong == 1
            # we split track_problems to two components - now track_problems_1 and track_problems_2 are vector rather than any
            change_true_tracker!(track_problems_1::BitVector, j)
            if current_loc_track_problems < 21
                change_loc_tracker!(track_problems_2::Vector{UnitRange{Int}}, current_loc_track_problems, (new_lo == 0 ? field_start : new_lo), (new_hi == 0 ? dlm_pos - dlm_length : new_hi))
                current_loc_track_problems += 1
            end
        end

        field_start = dlm_pos + 1
        read_one_obs = true
        any_problem_with_parsing += anything_is_wrong
        
        if j == n_cols && any_problem_with_parsing>0
            if Threads.atomic_add!(number_of_errors_happen_so_far, 1) <= warn
                if !isempty(colnames)
                    @warn DLMERRORS_PARSE_ERROR(buffer.data, line_start, line_end, res, current_line[], colnames, track_problems_1, track_problems_2, "UNKNOWN").message
                end
            end
            # reset track_problems
            fill!(track_problems_1, false)
            fill!(track_problems_2, 0:0)
            current_loc_track_problems = 1
        end
        j = j+1
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


function _process_iobuff_multiobs_no_parse!(res::Vector{Vector{Tuple{UInt32, UInt32}}},
    buffer::LineBuffer,
    n_cols::Int,
    dlm::Vector{UInt8},
    eol::Vector{UInt8},
    current_line::Base.RefValue{Int},
    last_valid_buff::Int,
    dlmstr::Bool,
    quotechar::Union{Nothing, UInt8},
    escapechar::Union{Nothing, UInt8},
    ignorerepeated::Bool,
    limit::Int,
    )::Bool

    line_start = 1
    dlm_pos = 0
    #keeping track of number of warnings
    !dlmstr ? dlm_length = 1  : dlm_length = length(dlm)
    any_problem_with_parsing = 0
    j = 1
    field_start = 1
    read_one_obs = false

    line_end = find_end_of_line(buffer.data, line_start, last_valid_buff, eol)

    while true

        if quotechar !== nothing
            dlm_pos, new_lo, new_hi = find_next_delim(buffer.data, field_start, line_end, dlm, dlmstr, quotechar, escapechar, ignorerepeated)
            if new_lo != 0 && new_hi != 0 && new_lo <= new_hi
                new_lo, new_hi = clean_escapechar!(buffer.data, new_lo, new_hi, quotechar)
            end
        else
            dlm_pos, new_lo, new_hi = find_next_delim(buffer.data, field_start, line_end, dlm, dlmstr, ignorerepeated)
        end

        dlm_pos == 0 ? dlm_pos = line_end + dlm_length : nothing
        
        res[j][current_line[]] = (new_lo == 0 ? field_start : new_lo, new_hi == 0 ? max(0, dlm_pos - dlm_length) : new_hi)

        field_start = dlm_pos + 1
        read_one_obs = true
        
        j = j+1
        if j > n_cols
            map(x->push!(x, (0,0)), res)
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