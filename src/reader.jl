# constant variables
const number_of_errors_happen_so_far = Threads.Atomic{Int}(0)

# const supported_types = DataType[Bool, Int8, Int16, Int32, Int64, Int8, UInt8, UInt16, UInt32, UInt64, Float32, Float64, Int128, UInt128, BigFloat, String1, String3, String7, String15, String31, String63, String127, String255, InlineString1, InlineString3, InlineString7, InlineString15, InlineString31, InlineString63, InlineString127, InlineString255, Characters{1}, Characters{2}, Characters{3}, Characters{4}, Characters{5}, Characters{6}, Characters{7}, Characters{8}, Characters{9}, Characters{10}, Characters{11}, Characters{12}, Characters{13}, Characters{14}, Characters{15}, Characters{16}, TimeType, DateTime, Date, Time, String, UUID]

const supported_keywords = Symbol[:types, :delimiter, :linebreak, :header, :threads, :guessingrows, :fixed, :buffsize, :quotechar, :escapechar, :dtformat, :dlmstr, :lsize, :informat, :warn, :eolwarn, :emptycolname, :int_base, :string_trim, :makeunique, :ignorerepeated, :multiple_obs, :skipto, :limit, :line_informat, :small_files_size]

const supported_keywords_types = Type[Union{Dict{Int,<:Union{<:Type,DataType}},Vector{<:Union{<:Type,DataType}}}, Union{Char,Vector{Char}}, Union{Char,Vector{Char}}, Union{Bool,Vector{Symbol},Vector{String}}, Bool, Int, Dict{Int,UnitRange{Int}}, Int, Char, Char, Union{String,<:DateFormat,Dict{Int,<:Union{<:DateFormat,String}}}, String, Int, Dict{Int,<:Function}, Int, Bool, Bool, Dict{Int,Int}, Bool, Bool, Bool, Bool, Int, Int, Function, Int]

# get value of supported_keywords

function val_opts(opts)
    d = Dict{Symbol,Any}()
    for (opt_name, opt_val) in opts
        in(opt_name, supported_keywords) ||
            throw(ArgumentError("unknown option $opt_name"))
        opt_typ = supported_keywords_types[findfirst(isequal(opt_name), supported_keywords)::Int]
        isa(opt_val, opt_typ) ||
            throw(ArgumentError("$opt_name should be of type $opt_typ, got $(typeof(opt_val))"))
        d[opt_name] = opt_val
    end
    return d
end

# filereader function
function filereader(path::Union{AbstractString, IOBuffer}; opts...)::Dataset
    optsd = val_opts(opts)

    # dlm 
    !all(isascii.(get(optsd, :delimiter, ','))) && throw(ArgumentError("delimiter must be ASCII"))
    dlm = UInt8[]
    append!(dlm, UInt8.(get(optsd, :delimiter, ',')))

    #linebreak
    !all(isascii.(get(optsd, :linebreak, '\n'))) && throw(ArgumentError("linebreak must be ASCII"))
    linebreak = UInt8[]
    if haskey(optsd, :linebreak)
        append!(linebreak, UInt8.(get(optsd, :linebreak, '\n')))
    else
        append!(linebreak, guess_eol_char(path))
    end

    # if we have dlmstr we use a separate path
    if haskey(optsd, :dlmstr)
        dlmstr = true
        dlm = collect(codeunits(optsd[:dlmstr]))::Vector{UInt8}
    else
        dlmstr = false
    end

    if haskey(optsd, :quotechar)
        quotechar = UInt8(optsd[:quotechar])
        escapechar = UInt8(get(optsd, :escapechar, UInt8('\\')))::UInt8
    end

    if haskey(optsd, :header)
        if optsd[:header] isa Vector
            header = false
            colnames = Symbol.(optsd[:header])
        else
            header = optsd[:header]
            colnames = Symbol[]
        end
    else
        header = true
        colnames = Symbol[]
    end

    fixed = get(optsd, :fixed, Dict{Int,UnitRange{Int}}())::Dict{Int,UnitRange{Int}}
    if haskey(optsd, :dtformat)
        if optsd[:dtformat] isa DateFormat
            fixed_dtformat = optsd[:dtformat]
            dtformat = Dict{Int,DateFormat}()
        elseif optsd[:dtformat] isa String
            fixed_dtformat = DateFormat(optsd[:dtformat])
            dtformat = Dict{Int,DateFormat}()
        else
            dtformat = get(optsd, :dtformat, Dict{Int,DateFormat}())
            fixed_dtformat = ISODateFormat
        end
    else
        fixed_dtformat = ISODateFormat
        dtformat = Dict{Int, DateFormat}()
    end

    infmt = Dict{Int,Vector{Ptr{Nothing}}}()
    if haskey(optsd, :informat)
        if !haskey(DLMReader_Registered_Informats, :NA!)
            for in_fmt in DLMReader_buildin_informats
                register_informat(in_fmt; quiet=true, force=true)
            end
        end
        for (k, v) in optsd[:informat]
            push!(infmt, k => _get_ptr_informat!(Ptr{Nothing}[], DLMReader_Registered_Informats, v))
        end
    end
    if isempty(infmt)
        informat = nothing
    else
        informat = infmt
    end

    int_base = get(optsd, :int_base, nothing)::Union{Nothing, Dict{Int,Int}}

    if haskey(optsd, :line_informat)
        l_infmt = _get_ptr_informat!(Ptr{Nothing}[], DLMReader_Registered_Informats, optsd[:line_informat])::Vector{Ptr{Nothing}}
    end

    ignorerepeated = get(optsd, :ignorerepeated, false)::Bool




    threads = get(optsd, :threads, true)::Bool
    guessingrows = get(optsd, :guessingrows, 20)::Int
    buffsize = get(optsd, :buffsize, 2^16)::Int
    lsize = get(optsd, :lsize, 2^15)::Int
    warn = get(optsd, :warn, 20)::Int
    eolwarn = get(optsd, :eolwarn, true)::Bool
    emptycolname = get(optsd, :emptycolname, false)::Bool
    string_trim = get(optsd, :string_trim, false)::Bool
    makeunique = get(optsd, :makeunique, false)::Bool
    multiple_obs = get(optsd, :multiple_obs, false)::Bool
    limit = get(optsd, :limit, typemax(Int))::Int
    skipto = get(optsd, :skipto, 1)::Int

    guessingrows = min(guessingrows, limit)

    number_of_errors_happen_so_far[] = 0

    #general checks
    lsize > buffsize && throw(ArgumentError("`lsize` cannot be larger than `buffsize`"))
    ignorerepeated && dlmstr && throw(ArgumentError("`ignorerepeated` option cannot be used when `dlmstr` is set"))

    if multiple_obs
        !(get(optsd, :types, Nothing) isa AbstractVector) && throw(ArgumentError("For reading multiple observations per line the types of each column must be specified"))
        !isempty(fixed) && throw(ArgumentError("When multiple observations per line is `true` the `fixed` keyword argument cannot be used"))
    end

    if multiple_obs
        if header
            throw(ArgumentError("`filereader` doesn't support reading header from file when `multiple_obs = true`"))
        end
        if @isdefined l_infmt
            throw(ArgumentError("`filereader` doesn't support `line_informat` when `multiple_obs = true`"))
        end
    end

    # we must skipto
    l_length, start_of_file = skipto_fun(path, FILESIZE(path), linebreak, skipto)


    if haskey(optsd, :types) && (optsd[:types] isa Vector)
        types = optsd[:types]
    else   
      types = detect_types(path, start_of_file, FILESIZE(path), get(optsd, :types, Dict{Int, DataType}()), dlm, linebreak, header, colnames, guessingrows, fixed, dtformat, dlmstr, lsize, buffsize, informat, haskey(optsd, :quotechar) ? escapechar : nothing, haskey(optsd, :quotechar) ? quotechar : nothing, ignorerepeated, skipto, limit, haskey(optsd, :line_informat) ? l_infmt : nothing)
    end
    if !isempty(fixed)
        colwidth = Vector{UnitRange{Int}}(undef, length(types))
        for i in 1:length(colwidth)
            colwidth[i] = get(fixed, i, 0:0)
        end
    else
        colwidth = nothing
    end
    n_cols = length(types)

    if !isempty(colnames)
        @assert length(colnames) == n_cols "number of column names and the number of detected columns are not matched"
    end

    fill_column_name!(colnames, header, path, start_of_file, FILESIZE(path), n_cols, linebreak, dlm, buffsize, colwidth, dlmstr, haskey(optsd, :quotechar) ? escapechar : nothing, haskey(optsd, :quotechar) ? quotechar : nothing, ignorerepeated, skipto, limit, haskey(optsd, :line_informat) ? l_infmt : nothing, emptycolname)

    charbuff, df = allocate_charbuff_df(types, dtformat, fixed_dtformat)

    # If we have read header from file, we must adjust start_of_file
    if header
        l_length, start_of_file = read_one_line(path, start_of_file+1, FILESIZE(path), linebreak)
    end
    small_size = get(optsd, :small_files_size, 2^27)
    @assert small_size < 4294967295 "the `small_files_size` must be less than 4GB"
    if FILESIZE(path) - start_of_file + 1 < small_size
        distribute_file_no_parse(path, start_of_file+1, FILESIZE(path), types, dlm, linebreak, header, colnames, threads, guessingrows, colwidth, small_size, df, charbuff, lsize, dlmstr, informat, haskey(optsd, :quotechar) ? escapechar : nothing, haskey(optsd, :quotechar) ? quotechar : nothing, warn, eolwarn, int_base, string_trim, makeunique, ignorerepeated, multiple_obs, skipto, limit, haskey(optsd, :line_informat) ? l_infmt : nothing)
    else
        distribute_file_parse(path, start_of_file+1, FILESIZE(path), types, dlm, linebreak, header, colnames, threads, guessingrows, colwidth, buffsize, df, charbuff, lsize, dlmstr, informat, haskey(optsd, :quotechar) ? escapechar : nothing, haskey(optsd, :quotechar) ? quotechar : nothing, warn, eolwarn, int_base, string_trim, makeunique, ignorerepeated, multiple_obs, skipto, limit, haskey(optsd, :line_informat) ? l_infmt : nothing)
    end
    
end


# lo is the beginning of the read and hi is the end of read. hi should be end of file or a linebreak
@noinline function readfile_chunk_parse!(res::Vector{<:AbstractVector},
    llo::Int,
    charbuff,
    path::Union{AbstractString, IOBuffer},
    types::Vector{DataType},
    lo::Int,
    hi::Int,
    colnames::Vector{Symbol},
    delimiter::Vector{UInt8},
    linebreak::Vector{UInt8},
    buffsize::Int,
    fixed::Union{Nothing, Vector{UnitRange{Int}}},
    df,
    dlmstr::Bool,
    informat::Union{Nothing, Dict{Int, Vector{Ptr{Nothing}}}},
    escapechar::Union{Nothing, UInt8},
    quotechar::Union{Nothing, UInt8},
    warn::Int,
    eolwarn::Bool,
    int_bases::Union{Nothing, Dict{Int, Int}},
    string_trim::Bool,
    ignorerepeated::Bool,
    multiple_obs::Bool,
    limit::Int,
    line_informat::Union{Nothing, Vector{Ptr{Nothing}}},
    total_line_skipped::Int
)

    read_one_obs = true
    f = OUR_OPEN(path, read=true)

    _Characters_types = findall(x -> x <: Characters, types)
    if length(_Characters_types) > 15
        Characters_types = Set(_Characters_types)
    elseif length(_Characters_types) > 0
        Characters_types = _Characters_types
    else
        Characters_types = nothing
    end

    _TimeType_types = findall(x -> x <: TimeType, types)
    if length(_TimeType_types) > 15
        TimeType_types = Set(_TimeType_types)
    elseif length(_TimeType_types) > 0
        TimeType_types = _TimeType_types
    else
        TimeType_types = nothing
    end



    try
        eol = linebreak
        eol_first = first(eol)
        eol_last = last(eol)
        eol_len = length(eol)

        buffsize > hi - lo + 1 ? buffsize = hi - lo + 1 : nothing

        buffer = LineBuffer(Vector{UInt8}(undef, buffsize))
        current_line = Ref{Int}(llo)
        last_line = false
        last_valid_buff = buffsize
        # position which reading should be started
        seek(f, max(0, lo - 1))

        # to track parsing problem for better warnings
        # second part of track_problems keep the location of the probem in the current line
        # we separate them to create concrete types
        track_problems_1 = falses(length(types))
        track_problems_2 = [0:0 for _ in 1:20]

        # TODO we should have a strategy when line is too long
        while true
            cnt_read_bytes = readbytes!(f, buffer.data)
            if cnt_read_bytes == 0
                return res
            end
            cur_position = position(f)

            if !eof(f) && cur_position < hi
                if buffer.data[end] !== eol_last || buffer.data[end-eol_len+1] !== eol_first
                    #this means the buffer is not ended with a eol char, so we move back into buffer to have complete line
                    back_cnt = 0
                    for i in buffsize:-1:1
                        last_valid_buff = i
                        buffer.data[i] == eol_last && buffer.data[i-eol_len+1] == eol_first && break
                        back_cnt += 1
                        i < buffsize / 4 && throw(ArgumentError(PRINT_ERROR_LINEBREAK(eol)))
                    end
                    cur_position = position(f)
                    seek(f, cur_position - back_cnt)
                else
                    last_valid_buff = buffsize
                end
            elseif cur_position == hi
                last_line = true
                if buffer.data[cnt_read_bytes] != eol_last || buffer.data[cnt_read_bytes-eol_len+1] != eol_first
                    if eolwarn
                        @warn "the last line is not ended with `end of line` character"
                    end
                    last_valid_buff = cnt_read_bytes
                else
                    last_valid_buff = cnt_read_bytes
                end
                # if we read more than what is allowed for the current chunk, we should revise the last_valid_buff   
            else
                cur_position > hi
                last_line = true
                last_valid_buff = cnt_read_bytes - (cur_position - hi)
            end
            if multiple_obs
                read_one_obs = _process_iobuff_multiobs_parse!(res, buffer, types, delimiter, eol, current_line, last_valid_buff, charbuff, df, dlmstr, informat, quotechar, escapechar, warn, colnames, int_bases, string_trim, ignorerepeated, limit, track_problems_1, track_problems_2, Characters_types, TimeType_types)
            else
                _process_iobuff_parse!(res, buffer, types, delimiter, eol, current_line, last_valid_buff, charbuff, df, fixed, dlmstr, informat, quotechar, escapechar, warn, colnames, int_bases, string_trim, ignorerepeated, limit, line_informat, track_problems_1, track_problems_2, total_line_skipped, Characters_types, TimeType_types)
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
        map(x -> pop!(x), res)
    end
    res
end

@noinline function readfile_chunk_no_parse!(res::Union{Matrix{Tuple{UInt32, UInt32}}, Vector{Vector{Tuple{UInt32, UInt32}}}},
    llo::Int,
    path::Union{AbstractString, IOBuffer},
    n_cols::Int,
    lo::Int,
    hi::Int,
    colnames::Vector{Symbol},
    delimiter::Vector{UInt8},
    linebreak::Vector{UInt8},
    buffsize::Int,
    fixed::Union{Nothing, Vector{UnitRange{Int}}},
    dlmstr::Bool,
    escapechar::Union{Nothing, UInt8},
    quotechar::Union{Nothing, UInt8},
    warn::Int,
    eolwarn::Bool,
    ignorerepeated::Bool,
    multiple_obs::Bool,
    limit::Int,
    line_informat::Union{Nothing, Vector{Ptr{Nothing}}},
    total_line_skipped::Int
)::Tuple{Int, LineBuffer}

    read_one_obs = true
    f = OUR_OPEN(path, read=true)
    eol = linebreak
    eol_first = first(eol)
    eol_last = last(eol)
    eol_len = length(eol)

    buffsize > hi - lo + 1 ? buffsize = hi - lo + 1 : nothing

    buffer = LineBuffer(Vector{UInt8}(undef, buffsize))
    current_line = Ref{Int}(llo)
    last_line = false
    last_valid_buff = buffsize
    # position which reading should be started
    seek(f, max(0, lo - 1))

    cnt_read_bytes = 0
    try
        # TODO we should have a strategy when line is too long
        while true
            cnt_read_bytes = readbytes!(f, buffer.data)
            if cnt_read_bytes == 0
                return res
            end
            cur_position = position(f)

            if !eof(f) && cur_position < hi
                if buffer.data[end] !== eol_last || buffer.data[end-eol_len+1] !== eol_first
                    #this means the buffer is not ended with a eol char, so we move back into buffer to have complete line
                    back_cnt = 0
                    for i in buffsize:-1:1
                        last_valid_buff = i
                        buffer.data[i] == eol_last && buffer.data[i-eol_len+1] == eol_first && break
                        back_cnt += 1
                        i < buffsize / 4 && throw(ArgumentError(PRINT_ERROR_LINEBREAK(eol)))
                    end
                    cur_position = position(f)
                    seek(f, cur_position - back_cnt)
                else
                    last_valid_buff = buffsize
                end
            elseif cur_position == hi
                last_line = true
                if buffer.data[cnt_read_bytes] != eol_last || buffer.data[cnt_read_bytes-eol_len+1] != eol_first
                    if eolwarn
                        @warn "the last line is not ended with `end of line` character"
                    end
                    last_valid_buff = cnt_read_bytes
                else
                    last_valid_buff = cnt_read_bytes
                end
                # if we read more than what is allowed for the current chunk, we should revise the last_valid_buff   
            else
                cur_position > hi
                last_line = true
                last_valid_buff = cnt_read_bytes - (cur_position - hi)
            end
            if multiple_obs
                read_one_obs = _process_iobuff_multiobs_no_parse!(res, buffer, n_cols, delimiter, eol, current_line, last_valid_buff, dlmstr, quotechar, escapechar, ignorerepeated, limit)
            else
                _process_iobuff_no_parse!(res, buffer, n_cols, delimiter, eol, current_line, last_valid_buff, fixed, dlmstr, quotechar, escapechar, warn, colnames, ignorerepeated, limit, line_informat, total_line_skipped)
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
        map(x -> pop!(x), res)
    end
    # for readfile_chunk_no_parse we assume that the buffer is holding all file
    cnt_read_bytes, buffer
end

function distribute_file_parse(path::Union{AbstractString, IOBuffer},
    start_of_read::Int,
    end_of_read::Int,
    types::Vector{DataType},
    delimiter::Vector{UInt8},
    linebreak::Vector{UInt8},
    header::Bool,
    colnames::Vector{Symbol},
    threads::Bool,
    guessingrows::Int,
    fixed::Union{Nothing, Vector{UnitRange{Int}}},
    buffsize::Int,
    dtformat,
    char_buff,
    lsize::Int,
    dlmstr::Bool,
    informat::Union{Nothing, Dict{Int, Vector{Ptr{Nothing}}}},
    escapechar::Union{Nothing, UInt8},
    quotechar::Union{Nothing, UInt8},
    warn::Int,
    eolwarn::Bool,
    int_bases::Union{Nothing, Dict{Int, Int}},
    string_trim::Bool,
    makeunique::Bool,
    ignorerepeated::Bool,
    multiple_obs::Bool,
    skipto::Int,
    limit::Int,
    line_informat::Union{Nothing, Vector{Ptr{Nothing}}}
)::Dataset

    eol = linebreak
    eol_first = first(eol)
    eol_last = last(eol)
    eol_len = length(eol)

    total_line_skipped = skipto - 1 + Int(header)

    f = OUR_OPEN(path, read=true)
    
    f_pos = max(0, start_of_read - 1)

    if !multiple_obs

        lsize_estimate = estimate_linesize(path, eol, lsize, f_pos+1, guessingrows=guessingrows)
        if lsize_estimate == 0 # TODO we need a better strategy
            lsize_estimate = lsize
        end

        lsize_estimate > lsize && throw(ArgumentError("the lines are larger than $lsize, increase buffers by setting `lsize` and `buffsize` arguments, they are currently set as $lsize and $buffsize respectively"))
    end

    if  length(types) != length(colnames)
        AssertionError(PRINT_ERROR_TYPES_COLUMNS(length(types), length(colnames)))
    end

    if !multiple_obs
        nt = determine_nt(path, f_pos, end_of_read, buffsize, threads, lsize_estimate, limit)
    else
        nt = 1
    end

    charbuff = [deepcopy(char_buff) for _ in 1:nt]
    # reset number of warnings
    number_of_errors_happen_so_far[] = 1
    if !multiple_obs
        line_lo, line_hi, lo, hi, ns, last_chunk_to_read = dist_calc(f, path, end_of_read, f_pos, nt, eol, eol_len, eol_last, eol_first, limit)

        # revised calculation - if limit is set
        if nt > 1 && last_chunk_to_read < nt
            line_lo, line_hi, lo, hi, ns, last_chunk_to_read = dist_calc(f, path, hi[last_chunk_to_read], skip_bytes, nt, eol, eol_len, eol_last, eol_first, limit)
        end

        # res = Any[allocatecol_for_res(types[i], min(sum(ns), limit)) for i in 1:length(types)]
        res = [allocatecol_for_res(types[i], 0) for i in 1:length(types)]
        _resize_res_barrier!(res, types, min(sum(ns), limit), threads)

        CLOSE(f)

        if nt > 1
            Threads.@threads for i in 1:min(nt, last_chunk_to_read)
                line_lo[i] > line_hi[i] && continue
                readfile_chunk_parse!(res, line_lo[i], charbuff[i], path, types, lo[i], hi[i], colnames, delimiter, linebreak, buffsize, fixed, dtformat, dlmstr, informat, escapechar, quotechar, warn, eolwarn, int_bases, string_trim, ignorerepeated, false, limit, line_informat, total_line_skipped)
            end
        else
            for i in 1:1
                readfile_chunk_parse!(res, line_lo[i], charbuff[i], path, types, lo[i], hi[i], colnames, delimiter, linebreak, buffsize, fixed, dtformat, dlmstr, informat, escapechar, quotechar, warn, eolwarn, int_bases, string_trim, ignorerepeated, false, limit, line_informat, total_line_skipped)
            end
        end
    else
        res = [allocatecol_for_res(types[i], 1) for i in 1:length(types)]
        readfile_chunk_parse!(res, 1, charbuff[1], path, types, start_of_read, end_of_read, colnames, delimiter, linebreak, buffsize, fixed, dtformat, dlmstr, informat, escapechar, quotechar, warn, eolwarn, int_bases, string_trim, ignorerepeated, true, limit, line_informat, total_line_skipped)
    end

    Dataset(res, colnames, copycols=false, makeunique=makeunique)
end

function distribute_file_no_parse(path::Union{AbstractString, IOBuffer},
    start_of_read::Int,
    end_of_read::Int,
    types::Vector{DataType},
    delimiter::Vector{UInt8},
    linebreak::Vector{UInt8},
    header::Bool,
    colnames::Vector{Symbol},
    threads::Bool,
    guessingrows::Int,
    fixed::Union{Nothing, Vector{UnitRange{Int}}},
    buffsize::Int,
    dtformat,
    char_buff::Vector{Vector{UInt8}},
    lsize::Int,
    dlmstr::Bool,
    informat::Union{Nothing, Dict{Int, Vector{Ptr{Nothing}}}},
    escapechar::Union{Nothing, UInt8},
    quotechar::Union{Nothing, UInt8},
    warn::Int,
    eolwarn::Bool,
    int_bases::Union{Nothing, Dict{Int, Int}},
    string_trim::Bool,
    makeunique::Bool,
    ignorerepeated::Bool,
    multiple_obs::Bool,
    skipto::Int,
    limit::Int,
    line_informat::Union{Nothing, Vector{Ptr{Nothing}}}
)::Dataset

    eol = linebreak

    total_line_skipped = skipto - 1 + Int(header)


    if !multiple_obs

        lsize_estimate = estimate_linesize(path, eol, lsize, start_of_read, guessingrows=guessingrows)
        if lsize_estimate == 0 # TODO we need a better strategy
            lsize_estimate = lsize
        end

        lsize_estimate > lsize && throw(ArgumentError("the lines are larger than $lsize, increase buffers by setting `lsize` and `buffsize` arguments, they are currently set as $lsize and $buffsize respectively"))
    end

    if  length(types) != length(colnames)
        AssertionError(PRINT_ERROR_TYPES_COLUMNS(length(types), length(colnames)))
    end
    
    charbuff = char_buff
    # reset number of warnings
    number_of_errors_happen_so_far[] = 1
    if !multiple_obs
        n_rows = count_lines_of_file(path, start_of_read, end_of_read, eol)

        res_idx = Matrix{Tuple{UInt32, UInt32}}(undef, n_rows, length(types))

        cnt_read_bytes, buffer = readfile_chunk_no_parse!(res_idx, 1, path, length(types), start_of_read, end_of_read, colnames, delimiter, linebreak, buffsize, fixed, dlmstr, escapechar, quotechar, warn, eolwarn, ignorerepeated, false, limit, line_informat, total_line_skipped)
           
    else
        res_idx_temp = [Vector{Tuple{UInt32, UInt32}}(undef, 1) for _ in 1:length(types)]
        cnt_read_bytes, buffer = readfile_chunk_no_parse!(res_idx_temp, 1, path, length(types), start_of_read, end_of_read, colnames, delimiter, linebreak, buffsize, fixed, dlmstr, escapechar, quotechar, warn, eolwarn, ignorerepeated, true, limit, line_informat, total_line_skipped)

        # next functions assume res_idx is a matrix, since for multiple_obs we assume the file is small we hcat the vector
        res_idx = reduce(hcat, res_idx_temp)
        n_rows = length(res_idx_temp[1])
    end
    res = [allocatecol_for_res(types[i], 0) for i in 1:length(types)]
    _resize_res_barrier!(res, types, min(n_rows, limit), threads)
    outds = Dataset(res, colnames, copycols = false, makeunique = makeunique)
    # Dataset(res, colnames, copycols=false, makeunique=makeunique)
    parse_eachrow_of_dataset!(outds, types, buffer, res_idx, informat, dtformat, char_buff, int_bases, string_trim, threads, warn)
    outds

end
function detect_types(path::Union{AbstractString, IOBuffer},
    start_of_read::Int,
    end_of_read::Int,
    outtypes::Dict{Int, DataType},
    delimiter::Vector{UInt8},
    linebreak::Vector{UInt8},
    header::Bool,
    colnames::Vector{Symbol},
    guessingrows::Int,
    fixed::Union{Nothing, Dict{Int, UnitRange{Int}}},
    dtformat::Dict{Int, <:DateFormat},
    dlmstr::Bool,
    lsize::Int,
    buffsize::Int,
    informat::Union{Nothing, Dict{Int, Vector{Ptr{Nothing}}}},
    escapechar::Union{Nothing, UInt8},
    quotechar::Union{Nothing, UInt8},
    ignorerepeated::Bool,
    skipto::Int,
    limit::Int,
    line_informat::Union{Nothing, Vector{Ptr{Nothing}}}
)::Vector{DataType}

    total_line_skipped::Int = skipto - 1 + Int(header)
    eol::Vector{UInt8} = linebreak

    f = OUR_OPEN(path, read = true)

    f_pos::Int = start_of_read

    n_cols::Int = 0

    if !isempty(fixed)
        colwidth = UnitRange{Int}[]
    else
        colwidth = nothing
    end

    l_length, _tmp_f_pos = read_one_line(path, f_pos+1, end_of_read, eol)

    if l_length > lsize
        throw(ArgumentError("very wide delimited file! you need to set `lsize` and `buffsize` argument with larger values,  they are currently set as $lsize and $buffsize respectively. It is also recommended to use lower number of `guessingrows`"))
    end

    seek(f, f_pos)

    a_line_buff = Vector{UInt8}(undef, l_length)

    nb::Int = readbytes!(f, a_line_buff)
    
    nb_pos::Int = 0
    
    seen_dlm::Bool = true
    
    while true
        if !isempty(fixed)
            col_width = get(fixed, n_cols+1, 0:0)
        else
            col_width = 0:0
        end
        if col_width != 0:0
            nb_pos = col_width.stop
            n_cols += 1
            seen_dlm = false
            push!(colwidth, col_width)
        else
            if quotechar !== nothing
                new_dlm_pos, new_lo, new_hi = find_next_delim(a_line_buff, nb_pos+1, l_length, delimiter, dlmstr, quotechar, escapechar, ignorerepeated)
            else
                new_dlm_pos,new_lo, new_hi = find_next_delim(a_line_buff, nb_pos+1, l_length, delimiter, dlmstr, ignorerepeated)
            end
            if new_dlm_pos > 0
                n_cols += 1
                nb_pos = new_dlm_pos
                seen_dlm = true
                !isempty(fixed) && push!(colwidth, col_width)
            else
                if seen_dlm
                    n_cols += 1
                end
                !isempty(fixed) && push!(colwidth, col_width)

                break
            end

        end
    end

    if header
        lo = _tmp_f_pos+1
    else
        lo = f_pos+1
    end

    seek(f, lo)

    rows_in = 0
    
    l_length = 1
    
    file_pos = max(0, lo - 1)
    
    while l_length>0
        l_length, file_pos = read_one_line(path, file_pos+1, end_of_read, eol)
        if l_length > 0
            rows_in += 1
        end
        rows_in >= guessingrows && break
    end

    hi = file_pos

    res = Matrix{Tuple{UInt32, UInt32}}(undef, rows_in, n_cols)
    # check that returned buffer has not been reused inside readfile_chunk_no_parse
    @assert hi - lo + 1 < buffsize "the input file is very wide, you must increase the buffsize/lsize for detecting types, otherwise decreasing gussingrows might resolve the issue"
    cnt_read_bytes, buffer = readfile_chunk_no_parse!(res, 1, path, n_cols, lo, hi, colnames, delimiter, linebreak, buffsize, colwidth, dlmstr, escapechar, quotechar, 0, false, ignorerepeated , false, limit, line_informat, total_line_skipped)

    if !isempty(dtformat)
        for (j, val) in dtformat
            hasdpart = occursin(r"\([ymd]", string(val.tokens))
            hastpart = occursin(r"\([HMSs]", string(val.tokens))
            if hasdpart && hastpart
                outtypes[j] = DateTime
            elseif hasdpart
                outtypes[j] = Date
            elseif hastpart
                outtypes[j] = Time
            else
                throw(ArgumentError("the date time format for column $(j) is not valid"))
            end
        end
    end
    for j in 1:n_cols
        if !haskey(outtypes, j)
            if informat !== nothing && haskey(informat, j)
                outtypes[j] = r_type_guess(res[:, j], buffer, informat[j])
            else
                outtypes[j] = r_type_guess(res[:, j], buffer, nothing)
            end
        end 
    end
    CLOSE(f)
    DataType[outtypes[i] for i in 1:n_cols]
    
end
