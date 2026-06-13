local api_docs_dir = "docs/api/"

task("docs")
    set_menu {
        usage = "xmake docs [task] [what]",
        description = "Updates/compiles .po files",
        options = {
            { nil, "task", "v", nil, "What to do",
                                        " - build",
                                        " - clean" },
            { nil, "what", "v", nil, "What to build for (check build targets from xmake b --help)" }
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


        if what_to_do == "build" then
            if what_for == "API" then
                if not os.isfile("docs/pasdoc/bin/pasdoc") then
                    os.execv(find_program("make"), { "-C", "docs/pasdoc", "build-fpc-release" },
                             { envs = { FPC_DEFAULT = miscs.get_fpc_path() } })
                end

                if not os.isdir(api_docs_dir) then
                    os.mkdir(api_docs_dir)
                end

                local args = {
                    "-DPASDOC", "-Iinclude/",
                    "@docs/pasdoc.cfg"
                }

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
                    local out = "docs/7/cc-" .. path.filename(file):split(".scd")[1] .. ".7"
                    miscs.scdoc_to_groff(file, out)
                end
            else
                miscs.scdoc_to_groff(
                    "docs/1/" .. what_for .. ".scd",
                    "docs/1/cc-" .. what_for .. ".1"
                )
            end

        elseif what_to_do == "clean" then
            if what_for == "API" then
                -- Clean pasdoc
                os.execv(find_program("make"), { "-C", "docs/pasdoc", "clean" })
                -- Remove manual pages
                os.rm("docs/7/*.7")
                -- Remove generated HTML pages
                os.rm(api_docs_dir .. "*")
            else
                os.rm("docs/1/*.1") -- Manual pages
            end

        else
            os.exec("xmake i18n --help")
            raise("Unknown [task]!")
        end
    end)
