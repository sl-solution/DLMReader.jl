# DLMReader.jl

Welcome to the DLMReader.jl documentation!

This resource aims to teach you everything you need to know to get up and running with the DLMReader.jl package.

DLMReader is a delimited file reader/writer for Julia. It reads/writes delimited file into/from [InMemoryDatasets.jl](https://github.com/sl-solution/InMemoryDatasets.jl).

It is designed to be flexible, efficient, and scalable.

## Package manual

```@contents
Pages = ["man/tutorial_basic.md",
          "man/tutorial_adv.md",
           "man/read.md",
            "man/write.md",
            "man/informat.md",
            "man/gallery.md"]
Depth = 2
```

## API

Only exported (i.e. available for use without `DLMReader.` qualifier after loading the DLMReader.jl package with `using DLMReader`) types and functions are considered a part of the public API of the DLMReader.jl package. In general all such objects are documented in this manual (in case some documentation is
missing please kindly report an issue [here](https://github.com/sl-solution/DLMReader.jl/issues/new)).
