import("lib.detect.find_program")

local xgettext = find_program("xgettext")
local msgmerge = find_program("msgmerge")
local msgfmt = find_program("msgfmt")

function generate_pot(resource_path, outpath, for_application)
    print('RSJ path: ' .. resource_path)
    if os.isfile(outpath) then
        os.rm(outpath)
    end
    os.touch(outpath)

    for __, fullpath in ipairs(os.files(resource_path .. "/*.rsj"))
    do
        local valid = not for_application
        if for_application then
            local fn = path.filename(fullpath)
            valid = (fn == "i18n.rsj") or ( not fn:startswith("cc."))
        end

        if valid then
            print("found " .. fullpath .. " file for localization: ")
            os.execv(xgettext, { "-o", outpath, "-E", "-i",
                                "--add-comments=TRANSLATORS",
                                "--sort-by-file", "--omit-header",
                                "-j", fullpath })
        end
    end
end

function merge_po_files(from, to)
    if os.exists(to) then
        os.execv(msgmerge, { "-i", "-E", "-N", "-U", to, from })
    else
        os.cp(from, to)
    end
end

function compile_po_files(from, to)
    os.execv(msgfmt, table.join(from, { "-o", to }))
end
