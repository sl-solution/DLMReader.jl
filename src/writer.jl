function WRITE(f, x)
    for i in 1:length(x)
        write(f, x[i])
    end
end

function WRITE_CHUNK(rchunk, f, ds, n, ff, delim, quotechar)
    chunk = div(n, rchunk)
    for j in 1:chunk
        WRITE(f, InMemoryDatasets.row_join(view(ds, (j-1)*rchunk+1:j*rchunk, :), ff, :, delim = delim, quotechar = quotechar))
    end
    WRITE(f, InMemoryDatasets.row_join(view(ds, chunk*rchunk+1:n, :), ff, :, delim = delim, quotechar = quotechar))
end

# basic function for writing csv files
function filewriter(path::AbstractString, ds::Dataset; delim = ',', quotechar = nothing, mapformats = false)
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
    f = open(path, "w")
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
    if p < 1000
        WRITE_CHUNK(1000, f, ds, n, ff, delim, quotechar)
    elseif p<10000
        WRITE_CHUNK(500, f, ds, n, ff, delim, quotechar)
    elseif p<50000
        WRITE_CHUNK(100, f, ds, n, ff, delim, quotechar)
    else
        WRITE_CHUNK(20, f, ds, n, ff, delim, quotechar)
    end
    close(f)
end
