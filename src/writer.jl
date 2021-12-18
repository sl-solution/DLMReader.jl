# some idea to reduce allocation - Not ok yet
_string_size(x, f, ::Type{T}) where T <: InMemoryDatasets.FLOATS = Base.Ryu.neededdigits(T)

_ndigits(x) = ndigits(x)
_ndigits(::Missing) = 0
_string_size(x, f, ::Type{T}) where T <: InMemoryDatasets.INTEGERS = InMemoryDatasets.hp_maximum(_ndigits∘f, x) + 1
_string_size(x, f, ::Type{T}) where T <: Bool = 1
_string_size(x, f, ::Type{T}) where T <: Characters{M, UInt8} where M= M

_STRING_L(x) = length(string(x))
_STRING_L(::Missing) = 0
_string_size(x, f, ::Type{T}) where T <: Any = InMemoryDatasets.hp_maximum(_STRING_L∘f, x)



function _find_max_string_length(ds, delim, quotechar, mapformats)
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
    for j in 1:ncols
        T = Core.Compiler.return_type(ff[j], (eltype(InMemoryDatasets._columns(ds)[j]), ))
        s += _string_size(InMemoryDatasets._columns(ds)[j], ff[j], nonmissingtype(T))
    end
    s += ncols*length(delim) + 1
    if quotechar != nothing
        s += 2*ncols
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

function WRITE_CHUNK(buff, cur_pos, lbuff, f, ds, n, ff, delim, quotechar)
    rchunk = length(cur_pos)
    chunk = div(n, rchunk)
    for j in 1:chunk
        fill!(cur_pos, 1)
        InMemoryDatasets.row_join!(buff, cur_pos, view(ds, (j-1)*rchunk+1:j*rchunk, :), ff, :, delim = delim, quotechar = quotechar)
        WRITE(f, buff, cur_pos, lbuff)
    end
    fill!(cur_pos, 1)
    InMemoryDatasets.row_join!(buff, cur_pos, view(ds, chunk*rchunk+1:n, :), ff, :, delim = delim, quotechar = quotechar)
    WRITE(f, buff, cur_pos, lbuff, length(chunk*rchunk+1:n))
end

# basic function for writing csv files
function filewriter(path::AbstractString, ds::AbstractDataset; delim = ',', quotechar = nothing, mapformats = false, append = false, header = true, lsize = :auto)
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

    lsize = _find_max_string_length(ds, UInt8.(delim), quotechar, mapformats)
    f = open(path, write = true, append = append)
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
                write(f, delim)
            end
        end
    end
    if p < 100
        cs = min(10000, n)
        buff = Matrix{UInt8}(undef, lsize, cs)
        cur_pos = Vector{Int32}(undef, cs)
        lbuff = Vector{UInt8}(undef, lsize*cs)
        WRITE_CHUNK(buff, cur_pos, lbuff, f, ds, n, ff, delim, quotechar)
    elseif p<500
        cs = min(5000, n)
        buff = Matrix{UInt8}(undef, lsize, cs)
        cur_pos = Vector{Int32}(undef, cs)
        lbuff = Vector{UInt8}(undef, lsize*cs)

        WRITE_CHUNK(buff, cur_pos, lbuff, f, ds, n, ff, delim, quotechar)
    elseif p<5000
        cs = min(1000, n)
        buff = Matrix{UInt8}(undef, lsize, cs)
        cur_pos = Vector{Int32}(undef, cs)
        lbuff = Vector{UInt8}(undef, lsize*cs)

        WRITE_CHUNK(buff, cur_pos, lbuff, f, ds, n, ff, delim, quotechar)
    else
        cs = min(100, n)
        buff = Matrix{UInt8}(undef, lsize, cs)
        cur_pos = Vector{Int}(undef, cs)
        lbuff = Vector{UInt8}(undef, lsize*cs)
        WRITE_CHUNK(buff, cur_pos, lbuff, f, ds, n, ff, delim, quotechar)
    end
    close(f)
end