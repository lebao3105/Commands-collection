local api_docs_dir = "docs/api/"

-- Pasdoc 0.17 introduces a much nicer UI so why not using it
target("pasdoc")
	set_kind("binary")

	on_build(function (_)
		import("core.project.depend")
		depend.on_changed(
		function ()
			os.execv(find_program("make"), {"-C", "docs/pasdoc"})
		end,
			{ files = {"docs/pasdoc/source/**.pas", "docs/pasdoc/source/**.lpr",
					   "docs/pasdoc/source/**.inc", "docs/pasdoc/source/Makefile"} }
		)
	end)

	on_clean(function (_)
		os.execv(find_program("make"), {"-C", "docs/pasdoc", "clean"})
	end)

target("API-docs")
	set_kind("phony")
	add_files("../src/cc.*.pp")
	add_deps("pasdoc")

	on_clean(function (_)
		os.rm(api_docs_dir .. "*")
	end)

	on_build(function (target)
		import("core.project.depend")
		local args = {}

		if not os.isdir(api_docs_dir) then
			os.mkdir(api_docs_dir)
		end

		for line in io.lines("cc.cfg") do
			if line:startswith("-d") then
				table.append(args, '-D' .. line:split("-d")[1])
			end
		end

		table.append(args, "@docs/pasdoc.cfg")
		table.append(args, target:get("files"))
		table.append(args, "-X") -- Copyright header
        table.append(args, "-DPASDOC")

		depend.on_changed(
			function ()
				os.execv("docs/pasdoc/bin/pasdoc", args)
			end,
			{ files = { target:get("files") } }
		)
	end)

target("docs")
	set_kind("phony")
	for _, program in ipairs(programs) do
		add_deps(program .. "-docs")
	end
	add_deps("API-docs")
