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
    local p = "extra.cfg"
    return os.isfile(p) and '@' .. p or ""
end

function single_string_quote(str)
    return "'" .. str .. "'"
end

function double_string_quote(str)
    return '"' .. str .. '"'
end

-- Below is the script once used in Pascal targets.
-- It's removed from normal build because it doesn't work - XMake only check
-- the modification time of target:targetfile(), making addition of other files
-- useless. I moved it here for later use, if any.
-- after_build( function (target)
    -- PPUDump options (must be put before file names)
    --     -F<format>  Set output format to <format>: we only care about j(SON)
    --     -M Exit with ExitCode=2 if more information is available
    --     -S Skip PPU version check. May lead to reading errors
    --     -V<verbose>  Set verbosity to <verbose>
    --                    H - Show header info
    --                    I - Show interface
    --                    M - Show implementation
    --                    S - Show interface symbols
    --                    D - Show interface definitions
    --                    A - Show all
--     local ppudump = find_program("ppudump", { check = "-h" })
--     local out, err = os.iorunv(ppudump, table.join(
--         { "-VI", "-Fj" },
--         os.files(target:objectdir() .. "/*.ppu"))
--     )
--     if not miscs.is_string_empty(err) then
--         print("error dumping infos from PPUs:")
--         raise(err)
--     end

--     import("core.base.json")
--     import("core.project.depend")
--     local dependfile = target:dependfile(target:targetfile())
--     local dependinfo = depend.load(dependfile)
--     local depends = os.files("src/" .. name .. "/*", true)
--     table.insert(depends, "src/shared/i18n.pp")

    -- Read the dumped PPU data. It is an array with the following keys
    -- Files: array of files that made the unit. Unused as there is no edge-cases
    -- Units: used units in both interface and implementation sections
    -- Ignore everything else. RTL, FCL etc units are not included in the depends table.
--     for _, obj in ipairs(json.decode(out)) do
--         for __, unit in ipairs(obj["Units"]) do
--             if unit:startswith("lua") or unit == "lauxlib" then
--                 table.insert(depends, "include/" .. unit .. ".inc")
--                 table.insert(depends, "src/shared/" .. unit .. ".pp")
--             end
--         end
--     end

    -- target:dependfile() contains serialized Lua table (lol)
--     dependinfo["files"] = table.unique(table.join(depends, dependinfo["files"]))
--     depend.save(dependinfo, dependfile)
-- end)
