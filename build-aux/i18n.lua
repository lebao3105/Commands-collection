import("lib.detect.find_program")

local xgettext = find_program("xgettext")
local msgmerge = find_program("msgmerge")
local msgfmt = find_program("msgfmt")

function generate_pot(resource_path, outpath)
    if xgettext == nil then
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
    if msgmerge == nil then
        return
    end

    if os.exists(to) then
        os.execv(msgmerge, { "-U", "-i", to, from })
    else
        os.cp(from, to)
    end
end

function compile_po_file(from, to)
    if msgfmt == nil then
        return
    end

    os.execv(msgfmt, { from, "-o", to })
end
