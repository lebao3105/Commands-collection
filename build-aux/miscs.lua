import("lib.detect.find_program")

local scdoc = find_program("scdoc", { check = "-v" })

function scdoc_to_groff(input, output)
    -- scdoc -h returns exit code 1, which makes
    -- find_program return nil. Thank you, stranger!

    os.execv(scdoc, {}, { stdin = input, stdout = output })
end

function get_full_build_path()
    local builddir_is_relative = not path.is_absolute("$(builddir)")
    local prog_path = "$(builddir)/$(os)/$(arch)/$(mode)/"

    if builddir_is_relative then
        prog_path = os.projectdir() .. "/" .. prog_path
    end

    return prog_path
end

function get_custom_fpc_conf()
    local fpc_conf = get_config("fpc-conf")

    if fpc_conf ~= nil and fpc_conf:trim():len() > 0 then
        return "@" .. fpc_conf
    end

    return ""
end

function single_string_quote(str)
    return "'" .. str .. "'"
end

function double_string_quote(str)
    return '"' .. str '"'
end
