
# taken from https://discourse.julialang.org/t/is-there-a-way-to-keep-the-delimiter-in-split-function-as-a-separate-element/51995/2
function split_keeping_splitter(string, splitter)
    r = Regex(
        either(
            look_for("", before=splitter),
            look_for("", after=splitter)
        )
    )
    return split(string, r)
end
