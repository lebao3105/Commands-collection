local api_docs_dir = "docs/api"

-- Pasdoc 0.17 introduces a much nicer UI so why not using it
target("pasdoc")
	set_kind("phony")
	on_build(function (_)
		-- FIXME:
		-- Pasdoc does not use the changed FPC (via CC's project options), if there is one.
        if not os.isfile("docs/pasdoc/bin/pasdoc") then
            os.execv(find_program("make"), {"-C", "docs/pasdoc", "build-fpc-release"})
        end
	end)

	on_clean(function (_)
		os.execv(find_program("make"), {"-C", "docs/pasdoc", "clean"})
	end)

target("API-docs")
	set_kind("phony")
	add_deps("pasdoc")
    add_installfiles(os.projectdir() .. "/docs/7/cc-*.7", { prefixdir = "share/man/man7" })

	on_clean(function (_)
		os.rm(api_docs_dir .. "/*")
        os.rm("docs/7/cc-*.7")
	end)

	on_build(function (target)
		local args = {
            "-E" .. api_docs_dir,
            "-X", -- Copyright header
            "-DPASDOC", "-Iinclude/",
            "@pasdoc.cfg"
        }

		os.mkdir(api_docs_dir)

		for line in io.lines("cc.cfg") do
			if line:startswith("-d") then
				table.append(args, '-D' .. line:split("-d")[1])
			end
		end

        table.join2(args, os.files("src/cc.*.pp"))

        os.execv("docs/pasdoc/bin/pasdoc", args)

        for _, file in ipairs(os.files("docs/7/*.scd")) do
            local out = "docs/7/cc-" .. path.filename(file):split(".scd")[1] .. ".7"
            miscs.scdoc_to_groff(file, out)
        end
	end)

target("docs")
	set_kind("phony")
	add_deps("programs-docs", "API-docs")
