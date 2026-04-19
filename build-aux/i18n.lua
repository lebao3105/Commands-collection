import("lib.detect.find_program")

function generate_pot(resource_path, outpath)
    local xgettext = find_program("xgettext")
    print("Using this RSJ path for " .. resource_path)

    if xgettext == nil then
        print("Failed to find xgettext!")
        return
    end

    if os.isfile(outpath) then
        os.rm(outpath)
    end
    os.touch(outpath)

    for __, fullpath in ipairs(os.files(resource_path .. "/*.rsj"))
    do
        print("Found a .rsj file for localization: " .. fullpath)
        os.execv(xgettext, {"-o", outpath, "-E", "-i",
                            "--add-comments=TRANSLATORS",
                            "-j", fullpath })
    end
end

function merge_po_files(from, to)
    local msgmerge = find_program("msgmerge")

    if msgmerge == nil then
        print("Failed to find msgmerge!")
        return
    end

    if os.exists(to) then
        os.execv(msgmerge, { "-U", "-i", to, from })
    else
        os.cp(from, to)
    end
end

function compile_po_file(from, to)
    local msgfmt = find_program("msgfmt")

    if msgfmt == nil then
        print("Failed to find msgfmt!")
        return
    end

    os.execv(msgfmt, { from, "-o", to })
end
