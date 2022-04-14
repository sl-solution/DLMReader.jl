using Documenter
using DLMReader

# DocMeta.setdocmeta!(InMemoryDatasets, :DocTestSetup, :(using InMemoryDatasets); recursive=true)

# Build documentation.
# ====================

makedocs(
    # options
    # modules = [InMemoryDatasets],
    doctest = false,
    clean = false,
    sitename = "DLMReader",
    # format = Documenter.HTML(
    #     canonical = "https://sl-solution.github.io/InMemoryDataset.jl/stable/",
    #     edit_link = "main"
    # ),
    pages = Any[
        "Introduction" => "index.md"
        # "API" => Any[
        #     "Functions" => "lib/functions.md"
        # ]
    ],
    strict = true
)

# Deploy built documentation from Travis.
# =======================================

deploydocs(
    # options
    repo = "github.com/sl-solution/DLMReader.jl",
    target = "build",
    deps = nothing,
    make = nothing,
    devbranch = "main"
)
