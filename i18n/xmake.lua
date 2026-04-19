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
        i18n.generate_pot(target:objectdir(), "./cc.pot")
        for _, fullpath in os.dirs("*") do
            if os.isfile(fullpath .. "/cc.po") then
                i18n.merge_po_files("./cc.pot", fullpath .. "/cc.po")
                i18n.compile_po_file(fullpath .. "/cc.po", fullpath .. "/cc.mo")
            end
        end
    end)
