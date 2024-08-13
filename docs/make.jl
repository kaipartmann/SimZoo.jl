using SimZoo
using Documenter

DocMeta.setdocmeta!(SimZoo, :DocTestSetup, :(using SimZoo); recursive=true)

makedocs(;
    modules=[SimZoo],
    authors="Kai Partmann",
    sitename="SimZoo.jl",
    format=Documenter.HTML(;
        canonical="https://kaipartmann.github.io/SimZoo.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/kaipartmann/SimZoo.jl",
    devbranch="main",
)
