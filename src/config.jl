function root()
    config_file = get_config_file()
    config = read_config_file(config_file)
    return config["root"]
end

function get_config_file()
    expected_config_file_1 = "SimZoo.toml"
    expected_config_file_2 = joinpath(".." , expected_config_file_1)
    expected_config_file_3 = joinpath(".." , expected_config_file_2)

    if isfile(expected_config_file_1)
        config_file = expected_config_file_1
    elseif isfile(expected_config_file_2)
        config_file = expected_config_file_2
    elseif isfile(expected_config_file_3)
        config_file = expected_config_file_3
    else
        error("config not found! Please create a SimZoo.toml configuration file!")
    end

    return config_file
end

function read_config_file(config_file::AbstractString)
    return TOML.parsefile(config_file)
end
