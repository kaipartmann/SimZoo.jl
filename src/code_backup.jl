timestamp() = Dates.format(now(), RFC1123Format)

function create_backup_log(cbf::S) where {S<:AbstractString}
    open(joinpath(cbf, "backup.log"), "w+") do io
        write(io, "backup created on ", timestamp())
    end
    return nothing
end

function make_code_backup(resfolder::S, filepaths::Vararg{S,N}) where {S<:AbstractString,N}
    cbf = joinpath(resfolder, "code_backup")
    cbf_tar = cbf * ".tar"
    if isfile(cbf_tar)
        @warn "existing code backup will be deleted!"
        rm(cbf_tar; recursive=true, force=true)
        @info "deleted old backup"
    end

    @info "create code backup..."
    cbf = joinpath(resfolder, "code_backup")
    mkpath(cbf)
    create_backup_log(cbf)
    project_file = Base.active_project()
    if isfile(project_file)
        cp(project_file, joinpath(cbf, basename(project_file)))
        @info "made backup of Project.toml"
    end
    manifest_file = joinpath(dirname(project_file), "Manifest.toml")
    if isfile(manifest_file)
        cp(manifest_file, joinpath(cbf, basename(manifest_file)))
        @info "made backup of Manifest.toml"
    end
    for filepath in filepaths
        if isfile(filepath)
            cp(filepath, joinpath(cbf, basename(filepath)))
            @info "made backup of file $(basename(filepath))"
        elseif isdir(filepath)
            cp(filepath, joinpath(cbf, basename(filepath)))
            @info "made backup of directory $(basename(filepath))"
        else
            @warn "could not make backup of $(basename(filepath))"
        end
    end
    Tar.create(cbf, cbf_tar)
    rm(cbf, recursive=true)
    return nothing
end
