task("i18n")
    set_menu {
        usage = "xmake i18n [task] [what]",
        description = "Updates/compiles .po files",
        options = {
            { nil, "task", "v", nil, "What to make",
                                        " - pot for templates",
                                        " - po for .po files",
                                        " - mo for compiled .po files",
                                        " - all for all the 3 above",
                                        " - clean" },
            { nil, "what", "v", nil, "What to localize for (check build targets from xmake b --help)" }
        }
    }

    on_run( function ()
        import("core.base.option")
        import("core.base.task")
        import("miscs")

        local what_to_do = option.get("task")
        local what_for = option.get("what")

        if not miscs.is_string_empty(what_for) then
            if what_to_do == "clean" then
                print(what_for .. " is not needed for xmake i18n clean")
            elseif what_to_do == "all" then
                task.run("i18n", { task = "pot", what = what_for })
                task.run("i18n", { task = "po", what = what_for })
                task.run("i18n", { task = "mo", what = what_for })
            end
        else
            os.exec("xmake i18n --help")
            raise("[what] is required here. Exiting.")
        end

        if what_for == "programs" then
            for _, p in ipairs(os.dirs(os.projectdir() .. "/src/*")) do
                local name = path.filename(p)
                if os.isfile(p .. '/' .. name .. ".pp") then
                    task.run("i18n", { task = what_to_do, what = name })
                end
            end
        elseif what_for == "all" then
            task.run("i18n", { task = what_to_do, what = "programs" })
            task.run("i18n", { task = what_to_do, what = "API" })
        end

        import("i18n")
        import("core.project.config")
        config.load() -- to make core.project.config.get() work

        if task.run("build", what_for) ~= 0 then
            raise("Failed to build " .. what_for)
        end

        local i18n_dir, potloc
        if what_for == "API" then
            i18n_dir = "i18n/"
            potloc = "i18n/cc.pot"
        else
            i18n_dir = "src/" .. what_for .. "/i18n/"
            potloc = i18n_dir .. "cc.pot"
        end

        if what_to_do == "pot" then
            print("Creating templates...")
            local rsjpath = (what_for == "API") and "src/shared" or
                format(
                    "%s/.objs/" .. what_for .. "/%s/%s/%s",
                    config.builddir, config.plat,
                    config.arch, config.mode
                )
            -- print(rsjpath)
            i18n.generate_pot(rsjpath, potloc, what_for ~= "API")

        elseif what_to_do == "po" then
            for _, fullpath in ipairs(os.dirs(i18n_dir .. "*")) do
                local out = fullpath .. "/cc.po"
                print("Merging " .. potloc .. " to " .. out)
                i18n.merge_po_files(potloc, out)
            end

        elseif what_to_do == "mo" then
            for _, fullpath in ipairs(os.dirs(i18n_dir .. "*")) do
                local outpath = fullpath .. "/cc.mo"
                local inpaths = { fullpath .. "/cc.po" }

                if not (what_for == "API") then
                    local language = path.filename(fullpath)
                    table.insert(inpaths, "i18n/" .. language .. "/cc.po")
                end

                i18n.compile_po_files(inpaths, outpath)
            end

        elseif what_to_do == "clean" then
            for _, path in ipairs({ "**/*.mo" }) do
                os.rm(path)
            end

        else
            os.exec("xmake i18n --help")
            raise("Unknown [task]!")
        end
    end)
