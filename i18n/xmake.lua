function generate_pot(resource_paths, outpath)
    local xgettext = find_program("xgettext")

    if xgettext == nil then
        error("Failed to find xgettext!")
        return
    end

    if os.isfile(outpath) then
        os.rm(outpath)
    end
    os.touch(outpath)

    for __, fullpath in ipairs(resource_paths .. "/*.rsj", { async = true })
    do
        print("Found a .rsj file for localization: " .. fullpath)
        os.execv(xgettext, {"-o", outpath, "-E", "-i",
                            "--add-comments=TRANSLATORS",
                            "-j", fullpath })
    end
end

function merge_po_files(from, to)
    local msgmerge = find_program("msgmerge")

    if msgmerge == nil then
        error("Failed to find msgmerge!")
        return
    end

    if os.exists(to) then
        os.execv(msgmerge, { "-U", "-i", to, from })
    else
        os.cp(from, to)
    end
end

function compile_po_file(from, to)
    local msgfmt = find_program("msgfmt")

    if msgfmt == nil then
        error("Failed to find msgfmt!")
        return
    end

    os.execv(msgfmt, { from, "-o", to })
end

target("API-i18n")
    set_kind("phony")
    add_rules("unit_pas")

    on_build(function (target)
        for __, fullpath in ipairs(os.files("src/cc.*.pp")) do
            os.execv("$(pc)", table.join(
                target:get("pcflags"),
                { fullpath, "-dPASDOC" }))
        end
    end)

    after_build(function (target)
        -- generate_pot(target:objectdir(), "./cc.pot")
        -- for _, fullpath in os.dirs("*") do
        --     if os.isfile(fullpath .. "/cc.po") then
        --         merge_po_files("./cc.pot", fullpath .. "/cc.po")
        --         compile_po_file(fullpath .. "/cc.po", fullpath .. "/cc.mo")
        --     end
        -- end
    end)
