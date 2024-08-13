"""
    get_simdata_cage(root::AbstractString, sim::AbstractString)

Returns a versioned directory for a simulation named `sim` in the simzoo simulation results
output database. It is not possible to overwrite in an existing directory. If a simulation
already exists, the simulation version counter is increased.
"""
function get_simdata_cage(root::AbstractString, sim::AbstractString)
    return get_cage(simzoo_simdata_dir(root, sim), sim)
end

"""
    get_post_cage(root::AbstractString, sim::AbstractString)
"""
function get_post_cage(root::AbstractString, sim::AbstractString)
    return get_cage(simzoo_post_dir(root, sim), sim)
end

function get_cage(path::AbstractString, sim::AbstractString)
    version = get_new_version_of_cage(path, sim)
    cage = joinpath(path, cage_name(sim, version))
    @assert !isdir(cage)
    return cage
end

function simzoo_sim_dir(root::AbstractString, sim::AbstractString)
    return normpath(joinpath(root, sim))
end

function simzoo_simdata_dir(root::AbstractString, sim::AbstractString)
    return normpath(joinpath(simzoo_sim_dir(root, sim), "simdata"))
end

function simzoo_post_dir(root::AbstractString, sim::AbstractString)
    return normpath(joinpath(simzoo_sim_dir(root, sim), "post"))
end

function get_latest_version_of_cage(path::AbstractString, sim::AbstractString)
    isdir(path) || return 0
    cages = filter(readdir(path, join=true, sort=true)) do cage
        sim == extract_sim_from_path(cage)
    end
    isempty(cages) && return 0
    versions = extract_version_from_path.(cages)
    latest_version = maximum(versions)
    return latest_version
end

function get_new_version_of_cage(path::AbstractString, sim::AbstractString)
    return get_latest_version_of_cage(path, sim) + 1
end

function extract_from_path(path::AbstractString)
    path_base = strip(first(splitext(basename(path))), '_')
    path_base_divided = split_keeping_splitter(path_base, "_")
    n_splits = length(path_base_divided)
    if n_splits == 3
        n_splits == 3
        version_str = first(path_base_divided)
        sim = last(path_base_divided)
    elseif n_splits > 3
        version_str = first(path_base_divided)
        sim = prod(path_base_divided[begin+1:end])
    else
        msg = "incorrect simzoo outdir!\n"
        msg *= "The outdir should contain an arbitrary string as simulation name, divided\n"
        msg *= "by a `_` and the version number at the end with 4 digits and trailing "
        msg *= "zeros.\n"
        throw(ArgumentError(msg))
    end
    version = parse(Int, version_str)
    return sim, version
end

@inline function extract_sim_from_path(path)
    return first(extract_from_path(path))
end

@inline function extract_version_from_path(path)
    return last(extract_from_path(path))
end

function version_string(version::Int)
    return @sprintf("%04d", version)
end

function cage_name(sim::AbstractString, version::Int)
    return @sprintf("%s_%s", version_string(version), clean(sim))
end

function clean(sim_in::AbstractString)
    stripped_sim_in = strip(sim_in)
    sim_out = replace(stripped_sim_in, " " => "_")
    return sim_out
end
