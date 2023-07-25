--[[----------------------------------------
Football Gametime VLC Extension

Allows saving kick off times for each match.

Author: @pdpino
--]] ----------------------------------------
EXTENSION_TITLE = "Football gametime"
CONFIG_KEY = "bookmark10"

function descriptor()
    return {
        title = EXTENSION_TITLE,
        version = "0.1",
        author = "pdpino",
        --		url = "github??",
        shortdesc = EXTENSION_TITLE,
        description = [[
Football gametime.

Display the time of a football match by setting
kick-off times for each video.
]],
        capabilities = {"menu"}
    }
end

function parse_and_validate_gametime(value)
    if value == nil or value == "" then
        return false, ""
    end

    local _, _, minutes, seconds = string.find(value, "^(%d+):(%d+)$")

    if minutes == nil or seconds == nil then
        _, _, seconds = string.find(value, "^(%d+)$")
        if seconds == nil then
            return true, "wrong time format"
        end
        minutes = "0"
    end

    if tonumber(seconds) >= 60 then
        return true, "seconds cannot be larger than 60"
    end

    local gametime = minutes .. ":" .. seconds
    return false, gametime
end

function _get_current_file()
    local item = vlc.input.item()
    if item == nil then
        vlc.msg.warn("No item playing")
        return "default"
    end

    local key = item:name()
    if key == nil or key == "" then
        vlc.msg.err("Cannot access name: " .. key)
        return "default"
    end
    return key
end

function _get_meta_filepath()
    return vlc.config.userdatadir() .. "/football-gametime.data"
end

function _read_table()
    local f = vlc.io.open(_get_meta_filepath(), "rt")
    if f == nil then
        return {}
    end

    table = {}
    table["default"] = "00:00-"
    while true do
        local line = f:read()
        if line == nil then
            break
        end

        local _, _, key, offsets = string.find(line, "(.*)%s(%S*-%S*)$")
        if key ~= nil and key ~= "" and offsets ~= nil and offsets ~= "" then
            table[key] = offsets
        end
    end
    f:close()

    return table
end

function _save_table(table)
    local f = vlc.io.open(_get_meta_filepath(), "wt")
    for key, value in pairs(table) do
        f:write(key .. " " .. value .. "\n")
    end
    f:close()
end

function _split_offsets(offsets)
    local _, _, raw_half1, raw_half2 = string.find(offsets, "^(%S*)-(%S*)$")

    local err1, half1 = parse_and_validate_gametime(raw_half1)
    local err2, half2 = parse_and_validate_gametime(raw_half2)

    if err1 or err2 then
        vlc.msg.err("Cannot parse offsets: " .. offsets)
        return "", ""
    end

    return half1, half2
end

function _merge_offsets(half1, half2)
    return (half1 or "") .. "-" .. (half2 or "")
end

function save_offsets(offset_1half, offset_2half)
    local offsets = _merge_offsets(offset_1half, offset_2half)

    local table = _read_table()
    local key = _get_current_file()
    table[key] = offsets
    _save_table(table)

    vlc.msg.info("Saving to meta: " .. key .. " = " .. offsets)
end

function load_offsets()
    local value_1half = ""
    local value_2half = ""

    local key = _get_current_file()
    local table = _read_table()
    local offsets = table[key]

    if offsets ~= nil then
        value_1half, value_2half = _split_offsets(offsets)
    end

    return value_1half, value_2half
end

function click_save()
    local err1, result1 = parse_and_validate_gametime(text_input_1half:get_text())
    if err1 then
        error_input:set_text("Error: cannot parse 1st half: " .. (result1 or ""))
        return
    end

    local err2, result2 = parse_and_validate_gametime(text_input_2half:get_text())
    if err2 then
        error_input:set_text("Error: cannot parse 2nd half: " .. (result2 or ""))
        return
    end

    if result1 == "" and result2 == "" then
        error_input:set_text("Error: provide at least one kickoff time")
        return
    end

    save_offsets(result1, result2)
    send_to_worker(result1, result2)

    error_input:set_text("")
    main_dlg:delete()
end

function click_cancel()
    main_dlg:delete()
end

function clear_worker_msg()
    vlc.config.set(CONFIG_KEY, "")
end

function send_to_worker(value_1half, value_2half)
    vlc.config.set(CONFIG_KEY, _merge_offsets(value_1half, value_2half))
end

function create_dialog()
    main_dlg = vlc.dialog(EXTENSION_TITLE)

    main_dlg:add_label("Kick off times", 1, 1, 2, 1) -- col, row, colspan, rowspan

    local value_1half, value_2half = load_offsets()
    send_to_worker(value_1half, value_2half)

    main_dlg:add_label("1st half", 1, 2, 1, 1)
    text_input_1half = main_dlg:add_text_input(value_1half, 2, 2, 1, 1)

    main_dlg:add_label("2nd half", 1, 3, 1, 1)
    text_input_2half = main_dlg:add_text_input(value_2half, 2, 3, 1, 1)

    main_dlg:add_button("Save", click_save, 1, 4, 2, 1)
    main_dlg:add_button("Cancel", click_cancel, 1, 5, 2, 1)

    error_input = main_dlg:add_label("", 1, 6, 2, 1)

    main_dlg:show()
end

function activate()
    create_dialog()
end

function deactivate()
    clear_worker_msg()
    main_dlg:delete() -- FIXME: does not always work!
end

function close()
    clear_worker_msg()
end

function meta_changed()
    local value_1half, value_2half = load_offsets()
    send_to_worker(value_1half, value_2half)
end

function trigger_menu(id)
    if id == 1 then
        create_dialog()
    end
end

function menu()
    return {"Settings"}
end
