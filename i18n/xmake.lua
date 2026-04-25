target("API-i18n")
    set_kind("phony")

    on_build(function (target)
        local args = { "-dPASDOC", "@cc.cfg", miscs.get_custom_fpc_conf() }

        for __, fullpath in ipairs(os.files("src/shared/cc.*.pp")) do
            -- TODO: Fix this terrible hardcoded FPC executable
            -- (pc and pcld failed to work)
            os.execv("fpc", table.join(args, fullpath))
        end
    end)

    after_build(function (target)
        i18n.generate_pot("src/shared", "i18n/cc.pot", false)

        for _, fullpath in ipairs(os.dirs("i18n/*")) do
            if os.isfile(fullpath .. "/cc.po") then
                i18n.merge_po_files("i18n/cc.pot", fullpath .. "/cc.po")
            end
        end
    end)

    on_clean(function (_)
        os.rm("i18n/*/cc.mo")
        os.rm("src/shared/*.o")
        os.rm("src/shared/*.ppu")
        os.rm("src/shared/*.rsj")
    end)
