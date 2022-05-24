# _string_size(x, f, threads, ::Type{T}) where T <: InMemoryDatasets.FLOATS = Base.Ryu.neededdigits(T)
_string_size(x, f, threads, ::Type{T}) where T <: InMemoryDatasets.FLOATS = 30

_ndigits(x) = ndigits(x)
_ndigits(::Missing) = 0
function _string_size(x, f, threads, ::Type{T}) where T <: InMemoryDatasets.INTEGERS
    if threads
        InMemoryDatasets.hp_maximum(_ndigits∘f, x) + 1
    else
        InMemoryDatasets.stat_maximum(_ndigits∘f, x) + 1
    end
end
_string_size(x, f, threads, ::Type{T}) where T <: Bool = 1
_string_size(x, f, threads, ::Type{T}) where T <: Characters{N} where N = N

_STRING_L(x::AbstractString) = ncodeunits(x)
_STRING_L(x) = ncodeunits(string(x))
_STRING_L(::Missing) = 0
function _string_size(x, f, threads, ::Type{T}) where T <: Any
    if threads
        InMemoryDatasets.hp_maximum(_STRING_L∘f, x)
    else
        InMemoryDatasets.stat_maximum(_STRING_L∘f, x)
    end
end



function _find_max_string_length(ds, delim, quotechar, mapformats, threads)
    ncols = InMemoryDatasets.ncol(ds)
    ff = Function[]
    if mapformats
        for j in 1:ncols
            push!(ff, InMemoryDatasets.getformat(ds, j))
        end
    else
        ff = repeat([identity], ncols)
    end
    n, p = size(ds)
    s = 0
    cnt_str = 0
    for j in 1:ncols
        T = Core.Compiler.return_type(ff[j], Tuple{eltype(InMemoryDatasets._columns(ds)[j])})
        slen = _string_size(InMemoryDatasets._columns(ds)[j], ff[j], threads, nonmissingtype(T))
        ismissing(slen) ? s+=0 : s+=slen
        if nonmissingtype(T) <: AbstractString
            cnt_str += 1
        end
    end
    s += ncols*length(delim) + 1
    if quotechar != nothing
        s += 2*cnt_str
    end
    s + 1
end


function WRITE(f, buff, cur_pos, lbuff, lastvalid = length(cur_pos))
    offset = 1
    jump = size(buff, 1)
    for i in 1:lastvalid
        copyto!(lbuff, offset, buff, (i-1)*jump+1, cur_pos[i]-1)
        offset += cur_pos[i]-1
    end
    write(f, view(lbuff, 1:offset-1))
end

function WRITE_CHUNK(buff, cur_pos, lbuff, f, ds, n, ff, delim, quotechar, threads)
    rchunk = length(cur_pos)
    chunk = div(n, rchunk)
    for j in 1:chunk
        fill!(cur_pos, 1)
        InMemoryDatasets.row_join!(buff, cur_pos, view(ds, (j-1)*rchunk+1:j*rchunk, :), ff, :, delim = delim, quotechar = quotechar, threads = threads)
        WRITE(f, buff, cur_pos, lbuff)
    end
    fill!(cur_pos, 1)
    InMemoryDatasets.row_join!(buff, cur_pos, view(ds, chunk*rchunk+1:n, :), ff, :, delim = delim, quotechar = quotechar, threads = threads)
    WRITE(f, buff, cur_pos, lbuff, length(chunk*rchunk+1:n))
end

"""
    filewriter(path::AbstractString, ds::AbstractDataset; [...])

Write `ds` as text to a file (`path`) using the given delimiter `delimiter` (which defaults to comma). User can pass a single character or a vector of characters to the `delimiter` keyword argument.

# Keyword arguments

* `delimiter`: By default, `filewriter` uses comma as delimiter, however, user can pass any other `Char` (or a vector of `Char`) via the `delimiter` keyword argument.
* `mapformats`: Setting this as `true` causes `filewriter` to write the formatted values.
* `append`: Setting this as `true` causes `filewriter` to append values to the end of the input file.
* `header`: The `filewriter` function writes column names in the output file, however, this can be prevented by setting `header = false`.
* `buffsize`: This option controls the buffer size. 
* `lsize`: This option controls the line size for writing values.
* `threads`: If set `true`, `filewriter` exploits all threads.

# Example

```julia
julia> using InMemoryDatasets

julia> ds = Dataset(x=[1.0, 2.1, -2.0], y = 1:3)
3×2 Dataset
 Row │ x         y        
     │ identity  identity 
     │ Float64?  Int64?   
─────┼────────────────────
   1 │      1.0         1
   2 │      2.1         2
   3 │     -2.0         3

julia> filewriter("_tmp.csv", ds)
```
"""
function filewriter(path::AbstractString, ds::AbstractDataset; delimiter::Union{Char, Vector{Char}} = ',', quotechar::Union{Nothing, Char} = nothing, mapformats::Bool = false, append::Bool = false, header = true, lsize::Int = 0, buffsize::Int = 2^24, threads::Bool = true)
    delimiter = reduce(vcat, collect(codeunits.(string.(delimiter))))
    ncols = InMemoryDatasets.ncol(ds)
    ff = Function[]
    if mapformats
        for j in 1:ncols
            push!(ff, InMemoryDatasets.getformat(ds, j))
        end
    else
        ff = repeat([identity], ncols)
    end
    n, p = size(ds)
    if lsize == 0
        lsize = _find_max_string_length(ds, UInt8.(delimiter), quotechar, mapformats, threads)
    else
        lsize = lsize
    end
    f = open(path, write = true, append = append)
    try
        if header
            allnames = names(ds)
            for j in 1:ncols
                if quotechar !== nothing
                    write(f, quotechar)
                end
                write(f, allnames[j])
                if quotechar !== nothing
                    write(f, quotechar)
                end
                if j == ncols
                    write(f, '\n')
                else
                    write(f, UInt8.(delimiter))
                end
            end
        end
        nrow_buff = div(buffsize, lsize)
        nrow_buff == 0 && throw(ArgumentError("very wide data set! you need to manually adjust `buffsize` (and/or `lsize`)"))
        cs = min(nrow_buff, n)
        buff = Matrix{UInt8}(undef, lsize, cs)
        cur_pos = Vector{Int}(undef, cs)
        lbuff = Vector{UInt8}(undef, lsize*cs)
        nrow_buff, sizeof(buff), sizeof(cur_pos), sizeof(lbuff)
        WRITE_CHUNK(buff, cur_pos, lbuff, f, ds, n, ff, delimiter, quotechar, threads)
    catch e
        close(f)
        rethrow(e)
    end
    close(f)
end
