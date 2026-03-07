target("update-locals")
	add_deps(programs)

	on_build(function (_)
		local xgettext = find_program("xgettext")
		local msgmerge = find_program("msgmerge")
		local potloc = "i18n/cc.pot"

		if xgettext == nil then
			error("Failed to find xgettext!")
			return
		end

		if msgmerge == nil then
			error("Failed to find msgmerge!")
			return
		end
		
		-- Start freshly
		if os.isfile(potloc) then
			os.rm(potloc)
		end
		os.touch(potloc)

		-- Generate a template
		for __, fullpath in ipairs(os.files("$(buildir)/**/*.rsj", { async = true }))
		do
			print("Found a .rsj file for localization: " .. fullpath)
			os.execv(xgettext, {"-o", potloc, "-E", "-i",
								"--add-comments=TRANSLATORS",
								"-j", fullpath })
		end

		-- Merge existing translations
		for __, fullpath in ipairs(os.dirs("i18n/*")) do
			local outpath = fullpath .. "/cc.po"
			if os.exists(outpath) then
				os.execv(msgmerge, { "-U", "-i", outpath, potloc })
			else
				os.cp(potloc, outpath)
			end
		end

	end)

target("compile-locals")
	on_build(function (_)
		local msgfmt = find_program("msgfmt")

		if msgfmt == nil then
			error("Failed to find msgfmt!")
			return
		end

		for __, fullpath in ipairs(os.dirs("i18n/*")) do
			os.execv(msgfmt, { fullpath .. "/cc.po", "-o", fullpath .. "/cc.mo" })
		end
	end)
