local api_docs_dir = "docs/api/"

task("docs")
    set_menu {
        usage = "xmake docs [task] [what]",
        description = "Updates/compiles .po files",
        options = {
            { nil, "task", "v", nil, "What to do",
                                     "    - b(uild)",
                                     "    - c(lean)" },
            { nil, "what", "v", nil, "What to build for",
              values = table.join(programs, {
                  "all", "API", "programs"
              }) }
        }
    }

    on_run( function ()
        import("core.base.option")
        import("miscs")
        local what_to_do = option.get("task")
        local what_for = option.get("what")

        if miscs.is_string_empty(what_for) then
            os.exec("xmake docs --help")
            raise("[what] is required here. Exiting.")
        end

        if what_for == "programs" then
            -- The use of os.dirs(...) is intentional
            for _, p in ipairs(os.dirs(os.projectdir() .. "/src/*")) do
                local name = path.filename(p)
                if os.isfile(p .. '/' .. name .. ".pp") then
                    task.run("docs", { task = what_to_do, what = name })
                end
            end
            return
        elseif what_for == "all" then
            task.run("docs", { task = what_to_do, what = "programs" })
            task.run("docs", { task = what_to_do, what = "API" })
            return
        end

        if (what_to_do == "build") or (what_to_do == "b") then
            if what_for ~= "API" then
                miscs.scdoc_to_groff(
                    "docs/1/" .. what_for .. ".scd",
                    "docs/1/cc-" .. what_for .. ".1"
                )
                return
            end

            if not os.isfile("docs/pasdoc/bin/pasdoc") then
                import("core.project.config")
                local compiler = config.get("pc")
                os.execv(find_program("make"), { "-C", "docs/pasdoc", "build-fpc-release" },
                            { envs = { FPC_DEFAULT = miscs.is_string_empty(compiler) and os.which("fpc") or compiler } })
            end

            if not os.isdir(api_docs_dir) then
                os.mkdir(api_docs_dir)
            end

            local args = { "-Iinclude/", "@docs/pasdoc.cfg" }
      		for line in io.lines("cc.cfg") do
     			if line:startswith("-d") then
         			table.append(args, '-D' .. line:split("-d")[1])
     			end
      		end

            table.join2(args, os.files("src/shared/**/cc.*.pp"), os.files("src/shared/cc.*.pp"))

            local ignores = table.to_array(io.lines("docs/pasdoc.ignore"))
            table.remove_if(args, function (v)
                return table.contains(ignores, args[v])
            end)

            os.execv("docs/pasdoc/bin/pasdoc", args)

            for _, file in ipairs(os.files("docs/7/*.scd")) do
                local out = "docs/7/cc-" .. path.basename(file) .. ".7"
                miscs.scdoc_to_groff(file, out)
            end

        elseif (what_to_do == "clean") or (what_to_do == "c") then
            if what_for ~= "API" then
                os.rm("docs/1/*.1") -- Manual pages
                return
            end

            -- Clean pasdoc
            os.execv(find_program("make"), { "-C", "docs/pasdoc", "clean" })
            -- Remove manual pages
            os.rm("docs/7/*.7")
            -- Remove generated HTML pages
            os.rm(api_docs_dir .. "*")

        else
            os.exec("xmake i18n --help")
            raise("Unknown [task]!")
        end
    end)
