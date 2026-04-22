target("API-i18n")
    set_kind("phony")

    on_build(function (target)
        local args = { "-dPASDOC", "@cc.cfg" }
        local fpc_conf = get_config("fpc-conf")

        if fpc_conf ~= nil and fpc_conf:trim():len() > 0 then
            table.insert(args, "@" .. get_config("fpc-conf"))
        end

        for __, fullpath in ipairs(os.files("src/cc.*.pp")) do
            -- cc.getopts is application specific
            if path.filename(fullpath) ~= "cc.getopts.pp" then
                -- TODO: Fix this terrible hardcoded FPC executable
                -- (pc and pcld failed to work)
                os.execv("fpc", table.join(args, fullpath))
            end
        end
    end)

    after_build(function (target)
        i18n.generate_pot("src", "i18n/cc.pot")
        for _, fullpath in ipairs(os.dirs("i18n/*")) do
            if os.isfile(fullpath .. "/cc.po") then
                i18n.merge_po_files("i18n/cc.pot", fullpath .. "/cc.po")
            end
        end
    end)

    on_clean(function (_)
        os.rm("i18n/*/cc.mo")
        os.rm("src/*.o")
        os.rm("src/*.ppu")
        os.rm("src/*.rsj")
    end)
