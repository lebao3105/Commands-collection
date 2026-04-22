includes("@builtin/xpack")

local package_formats = {
    "rpm", "deb", "dmg", "nsis", "targz",
    "srpm", "deb", "srczip", "srctargz"
}

xpack("commands-collection")
	set_formats(package_formats)
	set_title("Commands collection")
    set_inputkind("binary")
	set_author("lebao3105")
    set_maintainer("lebao3105 <lebao3105@invalid.mail>")
	set_description(
		"A pack of command-line utilities, found in daily usages. " ..
        "Bundled programs have cc prefix."
	)
	set_homepage("https://gitlab.com/lebao3105/commands-collection")
    set_license("GPL-3.0-or-later")
	set_licensefile("LICENSE")

    add_targets("API-docs", "programs")

    for _, program in ipairs(programs) do
        add_targets(program .. "-i18n", program .. "-docs", program)
    end
