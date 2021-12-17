precompile(Tuple{typeof(Base.Broadcast.broadcasted), Type, Base.UnitRange{Int64}, Function})
precompile(Tuple{Type{Base.RefValue{T} where T}, typeof(DLMReader.NUM_NA!)})
precompile(Tuple{Type{Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1}, Axes, F, Args} where Args<:Tuple where F where Axes}, Type{Base.Pair{A, B} where B where A}, Tuple{Base.UnitRange{Int64}, Base.RefValue{typeof(DLMReader.NUM_NA!)}}})
precompile(Tuple{typeof(Base.Broadcast.materialize), Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1}, Nothing, Type{Base.Pair{A, B} where B where A}, Tuple{Base.UnitRange{Int64}, Base.RefValue{typeof(DLMReader.NUM_NA!)}}}})
precompile(Tuple{Type{Base.Dict{K, V} where V where K}, Array{Base.Pair{Int64, typeof(DLMReader.NUM_NA!)}, 1}})
precompile(Tuple{typeof(Base.setindex!), Base.Dict{Int64, typeof(DLMReader.NUM_NA!)}, Function, Int64})
precompile(Tuple{Type{NamedTuple{(:quotechar, :informat), T} where T<:Tuple}, Tuple{Char, Base.Dict{Int64, typeof(DLMReader.NUM_NA!)}}})
precompile(Tuple{Base.Cartesian.var"#@ncall", LineNumberNode, Module, Int64, Any, Vararg{Any, N} where N})
precompile(Tuple{typeof(Base.tuple_type_tail), Type})
precompile(Tuple{typeof(Base.argtail), Type, Type, Vararg{Type, N} where N})
precompile(Tuple{typeof(Base.argtail), Type})
precompile(Tuple{DLMReader.var"#filereader##kw", NamedTuple{(:quotechar, :informat), Tuple{Char, Base.Dict{Int64, typeof(DLMReader.NUM_NA!)}}}, typeof(DLMReader.filereader), String})
precompile(Tuple{typeof(DLMReader.allocatecol_for_res), Type, Int64})
precompile(Tuple{typeof(Missings.missings), Type{String}, Int64})
precompile(Tuple{typeof(Base._array_for), Type{Array{Union{Base.Missing, String}, 1}}, Base.UnitRange{Int64}, Base.HasShape{1}})
precompile(Tuple{Type{NamedTuple{(:delimiter, :linebreak, :buffsize, :fixed, :dlmstr, :lsize, :informat, :quotechar, :escapechar, :eolwarn), T} where T<:Tuple}, Tuple{Char, Char, Int64, Base.UnitRange{Int64}, Nothing, Int64, Base.Dict{Int64, typeof(DLMReader.NUM_NA!)}, UInt8, UInt8, Bool}})
precompile(Tuple{DLMReader.var"#readfile_chunk!##kw", NamedTuple{(:delimiter, :linebreak, :buffsize, :fixed, :dlmstr, :lsize, :informat, :quotechar, :escapechar, :eolwarn), Tuple{Char, Char, Int64, Base.UnitRange{Int64}, Nothing, Int64, Base.Dict{Int64, typeof(DLMReader.NUM_NA!)}, UInt8, UInt8, Bool}}, typeof(DLMReader.readfile_chunk!), Array{Array{Union{Base.Missing, String}, 1}, 1}, Int64, Int64, Array{Any, 1}, String, Array{DataType, 1}, Int64, Int64, Int64})
precompile(Tuple{typeof(Base.getindex), Array{Array{Union{Base.Missing, String}, 1}, 1}, Int64})
precompile(Tuple{typeof(Base.Broadcast.broadcasted), Function, Base.Missing, Array{Union{Base.Missing, String}, 1}})
precompile(Tuple{Type{Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1}, Axes, F, Args} where Args<:Tuple where F where Axes}, typeof(Base.isequal), Tuple{Base.RefValue{Base.Missing}, Array{Union{Base.Missing, String}, 1}}})
precompile(Tuple{typeof(Base.Broadcast.materialize), Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1}, Nothing, typeof(Base.isequal), Tuple{Base.RefValue{Base.Missing}, Array{Union{Base.Missing, String}, 1}}}})
precompile(Tuple{typeof(Base.all), Base.BitArray{1}})
precompile(Tuple{typeof(DLMReader.r_type_guess), Array{Union{Base.Missing, String}, 1}, Function})
precompile(Tuple{typeof(DLMReader.tryparse_with_missing), Type, String, typeof(Base.identity)})
precompile(Tuple{typeof(Base.tryparse), Type{Int64}, DLMReader.LineBuffer})
precompile(Tuple{typeof(Base.tryparse), Type{Float64}, DLMReader.LineBuffer})
precompile(Tuple{Type{NamedTuple{(:delimiter, :linebreak, :header, :threads, :guessingrows, :fixed, :buffsize, :dtformat, :dlmstr, :lsize, :informat, :escapechar, :quotechar, :warn, :eolwarn), T} where T<:Tuple}, Tuple{Char, Char, Bool, Bool, Int64, Base.UnitRange{Int64}, Int64, Dates.DateFormat{Symbol("yyyy-mm-dd"), Tuple{Dates.DatePart{Char(0x79)}, Dates.Delim{Char, 1}, Dates.DatePart{Char(0x6d)}, Dates.Delim{Char, 1}, Dates.DatePart{Char(0x64)}}}, Nothing, Int64, Base.Dict{Int64, typeof(DLMReader.NUM_NA!)}, UInt8, UInt8, Int64, Bool}})
precompile(Tuple{DLMReader.var"#distribute_file##kw", NamedTuple{(:delimiter, :linebreak, :header, :threads, :guessingrows, :fixed, :buffsize, :dtformat, :dlmstr, :lsize, :informat, :escapechar, :quotechar, :warn, :eolwarn), Tuple{Char, Char, Bool, Bool, Int64, Base.UnitRange{Int64}, Int64, Dates.DateFormat{Symbol("yyyy-mm-dd"), Tuple{Dates.DatePart{Char(0x79)}, Dates.Delim{Char, 1}, Dates.DatePart{Char(0x6d)}, Dates.Delim{Char, 1}, Dates.DatePart{Char(0x64)}}}, Nothing, Int64, Base.Dict{Int64, typeof(DLMReader.NUM_NA!)}, UInt8, UInt8, Int64, Bool}}, typeof(DLMReader.distribute_file), String, Array{DataType, 1}})
precompile(Tuple{typeof(DLMReader._generate_colname_based), String, UInt8, Int64, Int64, Int64, Array{DataType, 1}, Char, Char, Int64, Base.UnitRange{Int64}, Nothing, UInt8, UInt8})
precompile(Tuple{typeof(Base.deepcopy), Array{Array{UInt8, 1}, 1}})
precompile(Tuple{typeof(Base.similar), Array{Array{UInt8, 1}, 1}})
precompile(Tuple{typeof(Base._array_for), Type{Array{Array{UInt8, 1}, 1}}, Base.UnitRange{Int64}, Base.HasShape{1}})
precompile(Tuple{typeof(Base.Threads.threading_run), Function})
    precompile(Tuple{DLMReader.var"#133#threadsfor_fun#12"{String, Array{Int64, 1}, Array{Int64, 1}, Array{Int64, 1}, UInt8, Base.UnitRange{Int64}}})
precompile(Tuple{typeof(Missings.missings), Type{Int64}, Int64})
    precompile(Tuple{DLMReader.var"#148#threadsfor_fun#13"{Char, Char, Int64, Int64, Nothing, Base.Dict{Int64, typeof(DLMReader.NUM_NA!)}, UInt8, UInt8, Int64, Bool, String, Array{DataType, 1}, Array{Int64, 1}, Array{Int64, 1}, Array{Any, 1}, Array{Int64, 1}, Array{Int64, 1}, Array{Int64, 1}, Base.UnitRange{Int64}}})
precompile(Tuple{typeof(Base.getindex), Array{Array{Array{UInt8, 1}, 1}, 1}, Int64})
precompile(Tuple{Type{NamedTuple{(:delimiter, :linebreak, :lsize, :buffsize, :fixed, :df, :dlmstr, :informat, :escapechar, :quotechar, :warn, :eolwarn), T} where T<:Tuple}, Tuple{Char, Char, Int64, Int64, Base.UnitRange{Int64}, Array{Dates.DateFormat{Symbol("yyyy-mm-dd"), Tuple{Dates.DatePart{Char(0x79)}, Dates.Delim{Char, 1}, Dates.DatePart{Char(0x6d)}, Dates.Delim{Char, 1}, Dates.DatePart{Char(0x64)}}}, 1}, Nothing, Base.Dict{Int64, typeof(DLMReader.NUM_NA!)}, UInt8, UInt8, Int64, Bool}})
    precompile(Tuple{Dates.var"##s831#36", Any, Any, Any, Any, Any, Any, Any, Any})
precompile(Tuple{typeof(Dates.character_codes), Type{Dates.DateFormat{Symbol("yyyy-mm-dd"), Tuple{Dates.DatePart{Char(0x79)}, Dates.Delim{Char, 1}, Dates.DatePart{Char(0x6d)}, Dates.Delim{Char, 1}, Dates.DatePart{Char(0x64)}}}}})
precompile(Tuple{typeof(Base.first), Core.SimpleVector})
precompile(Tuple{typeof(Base.push!), Array{Char, 1}, Char})
precompile(Tuple{typeof(Dates.genvar), DataType})
precompile(Tuple{typeof(Base._array_for), Type{Symbol}, Tuple{DataType, DataType, DataType}, Base.HasLength})
precompile(Tuple{Type{Base.LinearIndices{N, R} where R<:Tuple{Vararg{Base.AbstractUnitRange{Int64}, N}} where N}, Array{Symbol, 1}})
precompile(Tuple{typeof(Base.setindex!), Array{Symbol, 1}, Symbol, Int64})
    precompile(Tuple{Type{Base.Generator{I, F} where F where I}, Dates.var"#37#38", Tuple{DataType, DataType, DataType}})
    precompile(Tuple{Type{Tuple}, Base.Generator{Tuple{DataType, DataType, DataType}, Dates.var"#37#38"}})
precompile(Tuple{typeof(Base._array_for), Type{Int64}, Tuple{DataType, DataType, DataType}, Base.HasLength})
    precompile(Tuple{typeof(Base.collect_to_with_first!), Array{Int64, 1}, Int64, Base.Generator{Tuple{DataType, DataType, DataType}, Dates.var"#37#38"}, Int64})
precompile(Tuple{typeof(Base.Iterators.zip), Array{Symbol, 1}, Vararg{Any, N} where N})
precompile(Tuple{Type{Base.Iterators.Zip{Is} where Is<:Tuple}, Tuple{Array{Symbol, 1}, Tuple{Int64, Int64, Int64}}})
precompile(Tuple{typeof(Base._array_for), Type{Expr}, Base.Iterators.Zip{Tuple{Array{Symbol, 1}, Tuple{Int64, Int64, Int64}}}, Base.HasLength})
precompile(Tuple{Type{Base.LinearIndices{N, R} where R<:Tuple{Vararg{Base.AbstractUnitRange{Int64}, N}} where N}, Array{Expr, 1}})
precompile(Tuple{typeof(Base.Iterators._zip_iterate_all), Tuple{Array{Symbol, 1}, Tuple{Int64, Int64, Int64}}, Tuple{Tuple{}, Tuple{}}})
precompile(Tuple{typeof(Base.setindex!), Array{Expr, 1}, Expr, Int64})
precompile(Tuple{typeof(Base.map), typeof(tuple), Tuple{Int64, Int64}})
precompile(Tuple{typeof(Base.Iterators._zip_iterate_all), Tuple{Array{Symbol, 1}, Tuple{Int64, Int64, Int64}}, Tuple{Tuple{Int64}, Tuple{Int64}}})
    precompile(Tuple{Dates.var"##s832#33", Any, Any, Any, Any, Any, Any})
precompile(Tuple{typeof(Dates._directives), Type{Dates.DateFormat{Symbol("yyyy-mm-dd"), Tuple{Dates.DatePart{Char(0x79)}, Dates.Delim{Char, 1}, Dates.DatePart{Char(0x6d)}, Dates.Delim{Char, 1}, Dates.DatePart{Char(0x64)}}}}})
precompile(Tuple{typeof(Base._array_for), Type{Int64}, Array{Type, 1}, Base.HasShape{1}})
    precompile(Tuple{typeof(Base.collect_to_with_first!), Array{Int64, 1}, Int64, Base.Generator{Array{Type, 1}, Dates.var"#34#35"}, Int64})
precompile(Tuple{typeof(Base.length), Core.SimpleVector})
precompile(Tuple{Base.var"#@goto", LineNumberNode, Module, Symbol})
precompile(Tuple{Base.var"#@label", LineNumberNode, Module, Symbol})
precompile(Tuple{typeof(Base._array_for), Type{Symbol}, Tuple{DataType, DataType, DataType, DataType, DataType, DataType, DataType, DataType}, Base.HasLength})
    precompile(Tuple{Type{Base.Generator{I, F} where F where I}, Dates.var"#37#38", Tuple{DataType, DataType, DataType, DataType, DataType, DataType, DataType, DataType}})
    precompile(Tuple{Type{Tuple}, Base.Generator{Tuple{DataType, DataType, DataType, DataType, DataType, DataType, DataType, DataType}, Dates.var"#37#38"}})
precompile(Tuple{typeof(Base._array_for), Type{Int64}, Tuple{DataType, DataType, DataType, DataType, DataType, DataType, DataType, DataType}, Base.HasLength})
    precompile(Tuple{typeof(Base.collect_to_with_first!), Array{Int64, 1}, Int64, Base.Generator{Tuple{DataType, DataType, DataType, DataType, DataType, DataType, DataType, DataType}, Dates.var"#37#38"}, Int64})
precompile(Tuple{typeof(Base.setindex_widen_up_to), Array{Int64, 1}, Dates.AMPM, Int64})
    precompile(Tuple{typeof(Base.collect_to!), Array{Any, 1}, Base.Generator{Tuple{DataType, DataType, DataType, DataType, DataType, DataType, DataType, DataType}, Dates.var"#37#38"}, Int64, Int64})
precompile(Tuple{Type{Base.Iterators.Zip{Is} where Is<:Tuple}, Tuple{Array{Symbol, 1}, Tuple{Int64, Int64, Int64, Int64, Int64, Int64, Int64, Dates.AMPM}}})
precompile(Tuple{typeof(Base._array_for), Type{Expr}, Base.Iterators.Zip{Tuple{Array{Symbol, 1}, Tuple{Int64, Int64, Int64, Int64, Int64, Int64, Int64, Dates.AMPM}}}, Base.HasLength})
precompile(Tuple{typeof(Base.Iterators._zip_iterate_all), Tuple{Array{Symbol, 1}, Tuple{Int64, Int64, Int64, Int64, Int64, Int64, Int64, Dates.AMPM}}, Tuple{Tuple{}, Tuple{}}})
precompile(Tuple{typeof(Base.Iterators._zip_iterate_all), Tuple{Array{Symbol, 1}, Tuple{Int64, Int64, Int64, Int64, Int64, Int64, Int64, Dates.AMPM}}, Tuple{Tuple{Int64}, Tuple{Int64}}})
precompile(Tuple{typeof(Base._array_for), Type{Symbol}, Tuple{DataType, DataType, DataType, DataType, DataType, DataType, DataType}, Base.HasLength})
    precompile(Tuple{Type{Base.Generator{I, F} where F where I}, Dates.var"#37#38", Tuple{DataType, DataType, DataType, DataType, DataType, DataType, DataType}})
    precompile(Tuple{Type{Tuple}, Base.Generator{Tuple{DataType, DataType, DataType, DataType, DataType, DataType, DataType}, Dates.var"#37#38"}})
precompile(Tuple{typeof(Base._array_for), Type{Int64}, Tuple{DataType, DataType, DataType, DataType, DataType, DataType, DataType}, Base.HasLength})
    precompile(Tuple{typeof(Base.collect_to_with_first!), Array{Int64, 1}, Int64, Base.Generator{Tuple{DataType, DataType, DataType, DataType, DataType, DataType, DataType}, Dates.var"#37#38"}, Int64})
    precompile(Tuple{typeof(Base.collect_to!), Array{Any, 1}, Base.Generator{Tuple{DataType, DataType, DataType, DataType, DataType, DataType, DataType}, Dates.var"#37#38"}, Int64, Int64})
precompile(Tuple{Type{Base.Iterators.Zip{Is} where Is<:Tuple}, Tuple{Array{Symbol, 1}, Tuple{Int64, Int64, Int64, Int64, Int64, Int64, Dates.AMPM}}})
precompile(Tuple{typeof(Base._array_for), Type{Expr}, Base.Iterators.Zip{Tuple{Array{Symbol, 1}, Tuple{Int64, Int64, Int64, Int64, Int64, Int64, Dates.AMPM}}}, Base.HasLength})
precompile(Tuple{typeof(Base.Iterators._zip_iterate_all), Tuple{Array{Symbol, 1}, Tuple{Int64, Int64, Int64, Int64, Int64, Int64, Dates.AMPM}}, Tuple{Tuple{}, Tuple{}}})
precompile(Tuple{typeof(Base.Iterators._zip_iterate_all), Tuple{Array{Symbol, 1}, Tuple{Int64, Int64, Int64, Int64, Int64, Int64, Dates.AMPM}}, Tuple{Tuple{Int64}, Tuple{Int64}}})
precompile(Tuple{DLMReader.var"#readfile_chunk!##kw", NamedTuple{(:delimiter, :linebreak, :lsize, :buffsize, :fixed, :df, :dlmstr, :informat, :escapechar, :quotechar, :warn, :eolwarn), Tuple{Char, Char, Int64, Int64, Base.UnitRange{Int64}, Array{Dates.DateFormat{Symbol("yyyy-mm-dd"), Tuple{Dates.DatePart{Char(0x79)}, Dates.Delim{Char, 1}, Dates.DatePart{Char(0x6d)}, Dates.Delim{Char, 1}, Dates.DatePart{Char(0x64)}}}, 1}, Nothing, Base.Dict{Int64, typeof(DLMReader.NUM_NA!)}, UInt8, UInt8, Int64, Bool}}, typeof(DLMReader.readfile_chunk!), Array{Any, 1}, Int64, Int64, Array{Array{UInt8, 1}, 1}, String, Array{DataType, 1}, Int64, Int64, Int64})
precompile(Tuple{typeof(Base.setindex!), Array{AbstractArray{T, 1} where T, 1}, Array{Union{Base.Missing, Int64}, 1}, Int64})
precompile(Tuple{typeof(Base.setindex!), Array{AbstractArray{T, 1} where T, 1}, Array{Union{Base.Missing, String}, 1}, Int64})
precompile(Tuple{typeof(Base.length), Array{Union{Base.Missing, Int64}, 1}})
precompile(Tuple{typeof(Base.length), Array{Union{Base.Missing, String}, 1}})
# precompile(Tuple{typeof(InMemoryDatasets._preprocess_column), Array{Union{Base.Missing, Int64}, 1}, Int64, Bool})
# precompile(Tuple{typeof(InMemoryDatasets._preprocess_column), Array{Union{Base.Missing, String}, 1}, Int64, Bool})
# precompile(Tuple{typeof(Base.firstindex), Array{Union{Base.Missing, Int64}, 1}})
# precompile(Tuple{typeof(Base.firstindex), Array{Union{Base.Missing, String}, 1}})
# precompile(Tuple{Type{Ref{Any}}, InMemoryDatasets.Dataset})
#     precompile(Tuple{Core.Compiler.var"#256#258"{DataType, Tuple{String}}, Int64})
#     precompile(Tuple{typeof(Base.show), Base.IOContext{Base.TTY}, Base.Multimedia.MIME{Symbol("text/plain")}, InMemoryDatasets.Dataset})
#     precompile(Tuple{Type{InMemoryDatasets.DatasetColumn{T, E} where E where T<:InMemoryDatasets.AbstractDataset}, Int64, InMemoryDatasets.Dataset, Array{Union{Base.Missing, Int64}, 1}})
#     precompile(Tuple{Type{InMemoryDatasets.DatasetColumn{T, E} where E where T<:InMemoryDatasets.AbstractDataset}, Int64, InMemoryDatasets.Dataset, Array{Union{Base.Missing, String}, 1}})
#     precompile(Tuple{Base.var"#4#5"{InMemoryDatasets.var"#660#662"{Base.Dict{Any, String}}}, Tuple{Union, Int64}})
#     precompile(Tuple{InMemoryDatasets.var"#660#662"{Base.Dict{Any, String}}, Type, Int64})
#     precompile(Tuple{typeof(Base.get!), InMemoryDatasets.var"#661#663"{Union, Int64}, Base.Dict{Any, String}, Type{Union{Base.Missing, Int64}}})
#     precompile(Tuple{typeof(Base.show), Base.GenericIOBuffer{Array{UInt8, 1}}, Type})
#     precompile(Tuple{typeof(Base.show), Base.IOContext{Base.GenericIOBuffer{Array{UInt8, 1}}}, Type})
#     precompile(Tuple{typeof(Base.get!), InMemoryDatasets.var"#661#663"{Union, Int64}, Base.Dict{Any, String}, Type{Union{Base.Missing, String}}})
#     precompile(Tuple{Type{NamedTuple{(:alignment, :alignment_anchor_fallback, :alignment_anchor_regex, :body_hlines, :compact_printing, :crop, :crop_num_lines_at_beginning, :ellipsis_line_skip, :formatters, :header, :header_alignment, :hlines, :highlighters, :maximum_columns_width, :newline_at_end, :nosubheader, :row_name_alignment, :row_name_crayon, :row_name_column_title, :row_names, :row_number_alignment, :row_number_column_title, :show_row_number, :title, :vlines), T} where T<:Tuple}, Tuple{Array{Symbol, 1}, Symbol, Base.Dict{Int64, Array{Base.Regex, 1}}, Array{Int64, 1}, Bool, Symbol, Int64, Int64, Tuple{}, Tuple{Array{String, 1}, Array{String, 1}, Array{String, 1}}, Symbol, Array{Symbol, 1}, Tuple{InMemoryDatasets.PrettyTables.Highlighter}, Array{Int64, 1}, Bool, Bool, Symbol, InMemoryDatasets.PrettyTables.Crayons.Crayon, String, Nothing, Symbol, String, Bool, String, Array{Int64, 1}}})
#     precompile(Tuple{typeof(Base._compute_eltype), Any})
#     precompile(Tuple{typeof(Base.iterate), Base.IdSet{Any}})
#     precompile(Tuple{typeof(Base.convert), Type{Any}, Type})
#     precompile(Tuple{typeof(Base.iterate), Base.IdSet{Any}, Int64})
#     precompile(Tuple{typeof(Base.afoldl), Base.var"#42#43", Type, Type, Type, Type, Type, Type, Type, Type, Type, Type, Type, Type})
#     precompile(Tuple{typeof(Base.afoldl), Base.var"#42#43", Type, Type, Type, Type, Type, Type, Type, Type, Type, Type, Type})
#     precompile(Tuple{Base.var"##s79#169", Any, Any, Any, Any, Any})
#     precompile(Tuple{typeof(Base.merge_types), Tuple{Vararg{Symbol, N} where N}, Type{var"#s79"} where var"#s79"<:(NamedTuple{names, T} where T<:Tuple where names), Type{var"#s78"} where var"#s78"<:(NamedTuple{names, T} where T<:Tuple where names)})
#     precompile(Tuple{typeof(Base.afoldl), Base.var"#42#43", Type, Type, Type, Type, Type, Type, Type, Type})
#     precompile(Tuple{InMemoryDatasets.PrettyTables.var"#pretty_table##kw", NamedTuple{(:alignment, :alignment_anchor_fallback, :alignment_anchor_regex, :body_hlines, :compact_printing, :crop, :crop_num_lines_at_beginning, :ellipsis_line_skip, :formatters, :header, :header_alignment, :hlines, :highlighters, :maximum_columns_width, :newline_at_end, :nosubheader, :row_name_alignment, :row_name_crayon, :row_name_column_title, :row_names, :row_number_alignment, :row_number_column_title, :show_row_number, :title, :vlines), Tuple{Array{Symbol, 1}, Symbol, Base.Dict{Int64, Array{Base.Regex, 1}}, Array{Int64, 1}, Bool, Symbol, Int64, Int64, Tuple{}, Tuple{Array{String, 1}, Array{String, 1}, Array{String, 1}}, Symbol, Array{Symbol, 1}, Tuple{InMemoryDatasets.PrettyTables.Highlighter}, Array{Int64, 1}, Bool, Bool, Symbol, InMemoryDatasets.PrettyTables.Crayons.Crayon, String, Nothing, Symbol, String, Bool, String, Array{Int64, 1}}}, typeof(InMemoryDatasets.PrettyTables.pretty_table), Base.IOContext{Base.TTY}, InMemoryDatasets.Dataset})
#     precompile(Tuple{InMemoryDatasets.PrettyTables.var"##_pretty_table#73", Tuple{Array{String, 1}, Array{String, 1}, Array{String, 1}}, Base.Iterators.Pairs{Symbol, Any, Tuple{Symbol, Symbol, Symbol, Symbol, Symbol, Symbol, Symbol, Symbol, Symbol, Symbol, Symbol, Symbol, Symbol, Symbol, Symbol, Symbol, Symbol, Symbol, Symbol, Symbol, Symbol, Symbol, Symbol, Symbol}, NamedTuple{(:alignment, :alignment_anchor_fallback, :alignment_anchor_regex, :body_hlines, :compact_printing, :crop, :crop_num_lines_at_beginning, :ellipsis_line_skip, :formatters, :header_alignment, :hlines, :highlighters, :maximum_columns_width, :newline_at_end, :nosubheader, :row_name_alignment, :row_name_crayon, :row_name_column_title, :row_names, :row_number_alignment, :row_number_column_title, :show_row_number, :title, :vlines), Tuple{Array{Symbol, 1}, Symbol, Base.Dict{Int64, Array{Base.Regex, 1}}, Array{Int64, 1}, Bool, Symbol, Int64, Int64, Tuple{}, Symbol, Array{Symbol, 1}, Tuple{InMemoryDatasets.PrettyTables.Highlighter}, Array{Int64, 1}, Bool, Bool, Symbol, InMemoryDatasets.PrettyTables.Crayons.Crayon, String, Nothing, Symbol, String, Bool, String, Array{Int64, 1}}}}, typeof(InMemoryDatasets.PrettyTables._pretty_table), IO, InMemoryDatasets.Dataset})
#     precompile(Tuple{typeof(Base.length), InMemoryDatasets.DatasetColumn{InMemoryDatasets.Dataset, Array{Union{Base.Missing, Int64}, 1}}})
#     precompile(Tuple{typeof(Base.get), Base.IOContext{Base.TTY}, Symbol, Bool})
#     precompile(Tuple{typeof(InMemoryDatasets.PrettyTables._compute_cell_alignment_override), InMemoryDatasets.PrettyTables.ColumnTable, Array{Int64, 1}, Array{Int64, 1}, Int64, Int64, Int64, Base.RefValue{Any}})
#     precompile(Tuple{typeof(InMemoryDatasets.PrettyTables._fill_matrix_data!), Array{String, 2}, Array{Array{String, 1}, 2}, Array{Int64, 1}, Array{Int64, 1}, Array{Int64, 1}, Int64, Any, Any, Ref{Any}, InMemoryDatasets.PrettyTables.Display, Bool, Bool, Array{Int64, 1}, Bool, Bool, Bool, Bool, Bool, Base.Val{:print}, Symbol})
#     precompile(Tuple{typeof(Base.isassigned), Array{String, 1}, Int64})
#     precompile(Tuple{InMemoryDatasets.PrettyTables.var"#_parse_cell_text##kw", NamedTuple{(:autowrap, :cell_first_line_only, :column_width, :compact_printing, :has_color, :limit_printing, :linebreaks, :renderer), Tuple{Bool, Bool, Int64, Bool, Bool, Bool, Bool, Base.Val{:print}}}, typeof(InMemoryDatasets.PrettyTables._parse_cell_text), String})
#     precompile(Tuple{Base.var"##sprint#385", Nothing, Int64, typeof(Base.sprint), Function, String, Vararg{String, N} where N})
#     precompile(Tuple{typeof(Base.convert), Type{Array{String, 1}}, Array{String, 1}})
#     precompile(Tuple{typeof(Base.isassigned), InMemoryDatasets.PrettyTables.ColumnTable, Int64, Int64})
#     precompile(Tuple{typeof(InMemoryDatasets.Tables.getcolumn), InMemoryDatasets.DatasetColumns{InMemoryDatasets.Dataset}, Symbol})
#     precompile(Tuple{typeof(Base.isassigned), InMemoryDatasets.DatasetColumn{InMemoryDatasets.Dataset, Array{Union{Base.Missing, Int64}, 1}}, Int64})
#     precompile(Tuple{typeof(Base.getindex), InMemoryDatasets.PrettyTables.ColumnTable, Int64, Int64})
#     precompile(Tuple{typeof(Base.getindex), InMemoryDatasets.DatasetColumn{InMemoryDatasets.Dataset, Array{Union{Base.Missing, Int64}, 1}}, Int64})
#     precompile(Tuple{InMemoryDatasets.PrettyTables.var"#_parse_cell_text##kw", NamedTuple{(:autowrap, :cell_data_type, :cell_first_line_only, :column_width, :compact_printing, :has_color, :limit_printing, :linebreaks, :renderer), Tuple{Bool, DataType, Bool, Int64, Bool, Bool, Bool, Bool, Base.Val{:print}}}, typeof(InMemoryDatasets.PrettyTables._parse_cell_text), Int64})
#     precompile(Tuple{Type{Base.IOContext{IO_t} where IO_t<:IO}, Base.TTY, Base.Pair{Symbol, Bool}, Base.Pair{Symbol, Bool}})
#     precompile(Tuple{Type{NamedTuple{(:context,), T} where T<:Tuple}, Tuple{Base.IOContext{Base.TTY}}})
#     precompile(Tuple{Base.var"#sprint##kw", NamedTuple{(:context,), Tuple{Base.IOContext{Base.TTY}}}, typeof(Base.sprint), Function, Int64})
#     precompile(Tuple{typeof(Base.isassigned), InMemoryDatasets.DatasetColumn{InMemoryDatasets.Dataset, Array{Union{Base.Missing, String}, 1}}, Int64})
#     precompile(Tuple{typeof(Base.getindex), InMemoryDatasets.DatasetColumn{InMemoryDatasets.Dataset, Array{Union{Base.Missing, String}, 1}}, Int64})
#     precompile(Tuple{InMemoryDatasets.PrettyTables.var"#_parse_cell_text##kw", NamedTuple{(:autowrap, :cell_data_type, :cell_first_line_only, :column_width, :compact_printing, :has_color, :limit_printing, :linebreaks, :renderer), Tuple{Bool, DataType, Bool, Int64, Bool, Bool, Bool, Bool, Base.Val{:print}}}, typeof(InMemoryDatasets.PrettyTables._parse_cell_text), String})
#     precompile(Tuple{typeof(Base.ht_keyindex), Base.Dict{Int64, Array{Base.Regex, 1}}, Int64})
#     precompile(Tuple{typeof(Base.copyto!), Array{Int64, 1}, Base.KeySet{Int64, Base.Dict{Int64, Array{Base.Regex, 1}}}})
#     precompile(Tuple{typeof(Base._replace!), Base.var"#new#295"{Tuple{Base.Pair{Symbol, Int64}, Base.Pair{Symbol, Int64}, Base.Pair{Symbol, Int64}}}, Array{Any, 1}, Array{Symbol, 1}, Int64})
#     precompile(Tuple{typeof(Base._typed_vcat!), Array{Any, 1}, Tuple{Array{Any, 1}, Array{Int64, 1}}})
#     precompile(Tuple{typeof(Base.in), Int64, Base.Set{Any}})
#     precompile(Tuple{typeof(Base.push!), Base.Set{Any}, Int64})
#     precompile(Tuple{Type{Array{Int64, 1}}, Array{Any, 1}})
#     precompile(Tuple{typeof(Base._replace!), Base.var"#new#295"{Tuple{Base.Pair{Symbol, Int64}, Base.Pair{Symbol, Int64}}}, Array{Int64, 1}, Array{Int64, 1}, Int64})
#     precompile(Tuple{typeof(Base.print), Base.IOContext{Base.GenericIOBuffer{Array{UInt8, 1}}}, InMemoryDatasets.PrettyTables.Crayons.Crayon})
#     precompile(Tuple{typeof(InMemoryDatasets.PrettyTables._print_table_header!), Base.IOContext{Base.GenericIOBuffer{Array{UInt8, 1}}}, InMemoryDatasets.PrettyTables.Display, Any, Array{String, 2}, Array{Int64, 1}, Array{Int64, 1}, Int64, Int64, Array{Int64, 1}, Array{Int64, 1}, Array{Symbol, 1}, Array{Symbol, 1}, Ref{Any}, Bool, Bool, InMemoryDatasets.PrettyTables.TextFormat, InMemoryDatasets.PrettyTables.Crayons.Crayon, Array{InMemoryDatasets.PrettyTables.Crayons.Crayon, 1}, Array{InMemoryDatasets.PrettyTables.Crayons.Crayon, 1}, InMemoryDatasets.PrettyTables.Crayons.Crayon, InMemoryDatasets.PrettyTables.Crayons.Crayon})
#     precompile(Tuple{typeof(Base.print), Base.GenericIOBuffer{Array{UInt8, 1}}, InMemoryDatasets.PrettyTables.Crayons.Crayon, String, Vararg{Any, N} where N})
#     precompile(Tuple{typeof(Base.print), Base.GenericIOBuffer{Array{UInt8, 1}}, InMemoryDatasets.PrettyTables.Crayons.Crayon})
#     precompile(Tuple{typeof(Base._collect), Base.UnitRange{Int64}, Base.RegexMatchIterator, Base.HasEltype, Base.SizeUnknown})
#     precompile(Tuple{typeof(Base.getproperty), InMemoryDatasets.PrettyTables.Highlighter, Symbol})
#     precompile(Tuple{typeof(InMemoryDatasets._pretty_tables_highlighter_func), InMemoryDatasets.Dataset, Int64, Int64})
#     precompile(Tuple{typeof(Base.getindex), Array{Union{Base.Missing, Int64}, 1}, Int64})
#     precompile(Tuple{typeof(Base.getindex), Array{Union{Base.Missing, String}, 1}, Int64})
#     precompile(Tuple{typeof(InMemoryDatasets.PrettyTables._flush_buffer!), Base.IOContext{Base.TTY}, Base.GenericIOBuffer{Array{UInt8, 1}}, Bool, Bool, Int64})