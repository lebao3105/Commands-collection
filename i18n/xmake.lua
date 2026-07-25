task("i18n")
    set_menu {
        usage = "xmake i18n [task] [what]",
        description = "Updates/compiles .po files",
        options = {
            { nil, "no-rebuild", "k", true, "Do not recompile [what]" },
            { nil, "task", "v", nil, "What to make",
                                     "    - pot for templates",
                                     "    - po for .po files",
                                     "    - mo for compiled .po files",
                                     "    - all for all the 3 above",
                                     "    - clean" },
            { nil, "what", "v", nil, "What to localize for",
              values = table.join(programs, {
                  "all"
              }) }
        }
    }

    on_run( function ()
        import("core.base.option")
        import("core.base.task")
        import("miscs")

        local what_to_do = option.get("task")
        local what_for = option.get("what")

        if what_for == "all" then
            if what_to_do == "clean" then
                for _, path in ipairs({ "**/*.mo" }) do
                    os.rm(path)
                end
            else
                -- The use of os.dirs(...) is intentional
                for _, p in ipairs(os.dirs(os.projectdir() .. "/src/*")) do
                    local name = path.filename(p)
                    if os.isfile(p .. '/' .. name .. ".pp") then
                        task.run("i18n", { task = what_to_do, what = name })
                    end
                end
            end
            return
        elseif what_to_do == "all" then
            task.run("i18n", { task = "pot", what = what_for })
            task.run("i18n", { task = "po", what = what_for })
            task.run("i18n", { task = "mo", what = what_for })
            return
        elseif miscs.is_string_empty(what_for) then
            os.exec("xmake i18n --help")
            raise("[what] is required here. Exiting.")
        end

        import("core.project.config")
        import("private.action.require.impl.package")
        config.load() -- to make core.project.config.get() work

        local gettext_dir
        for _, pkg in ipairs(package.load_packages({"gettext"})) do
            if pkg:requireinfo().originstr == "gettext" then
                gettext_dir = pkg:installdir() .. "/bin/"
            end
        end

        local i18n_dir = "i18n/"
        local potloc = i18n_dir .. what_for .. ".pot"

        if what_to_do == "pot" then
            if not option.get("no-rebuild") then
                print("building " .. what_for .. " ...")
                task.run("build", { target = what_for })
            end

            print("creating " .. potloc .. "...")
            local rsjpath = format(
                "%s/.objs/" .. what_for .. "/%s/%s/%s",
                config.builddir(), config.plat(),
                config.arch(), config.mode()
            )
            print('RSJ path: ' .. rsjpath)
            if os.isfile(potloc) then
                 os.rm(potloc)
            end
            os.touch(potloc)

            local xgettext = gettext_dir .. "xgettext"
            for __, fullpath in ipairs(os.files(rsjpath .. "/*.rsj"))
            do
                local fn = path.filename(fullpath)
                if not fn:startswith("small") then
                    print("found " .. fullpath .. " for localization")
                    os.execv(xgettext, { "-o", potloc, "-E", "-i",
                                         "--add-comments=TRANSLATORS",
                                         "--sort-by-file", "--omit-header",
                                         "-j", fullpath })
                end
            end

        elseif what_to_do == "po" then
            for _, fullpath in ipairs(os.dirs(i18n_dir .. "*")) do
                local out = fullpath .. "/" .. what_for .. ".po"
                print("merging " .. potloc .. " to " .. out)

                if os.exists(out) then
                    os.execv(gettext_dir .. "msgmerge", { "-i", "-E", "-N", "-U", out, potloc })
                else
                    os.cp(potloc, out)
                end
            end

        elseif what_to_do == "mo" then
            for _, fullpath in ipairs(os.dirs(i18n_dir .. "*")) do
                local outpath = fullpath .. "/" .. what_for .. ".mo"
                local inpath = fullpath .. "/" .. what_for .. ".po"

                print("creating " .. outpath .. " ...")
                os.execv(gettext_dir .. "msgfmt", table.join(inpath, { "-o", outpath }))
            end

        elseif what_to_do == "clean" then
            os.rm(fullpath .. "/" .. what_for .. ".mo")

        else
            os.exec("xmake i18n --help")
            raise("Unknown [task]: " .. what_to_do .. "!")
        end
    end)
