function scdoc_to_groff(input, output)
    import("lib.detect.find_program")

    -- scdoc -h returns exit code 1, which makes
    -- find_program return nil. Thank you, stranger!
    local scdoc = find_program("scdoc", { check = "-v" })
    os.execv(scdoc, { }, { stdin = input, stdout = output })
end

function is_string_empty(str)
    return (str == nil) or (str:trim():len() == 0)
end

function get_custom_fpc_conf()
    local fpc_conf = get_config("fpc-conf")

    if not is_string_empty(fpc_conf) then
        return "@" .. fpc_conf
    end

    return ""
end

function single_string_quote(str)
    return "'" .. str .. "'"
end

function double_string_quote(str)
    return '"' .. str .. '"'
end

function get_fpc_path(config)
    local result = config.get("pc")
    return is_string_empty(result) and "fpc" or result
end

function get_fpc_path()
    import("core.project.config")
    config.load()
    return get_fpc_path(config)
end
