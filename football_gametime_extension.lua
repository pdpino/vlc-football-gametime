--[[----------------------------------------
Extension...

TODO: docs
--]]----------------------------------------

EXTENSION_TITLE = "Football gametime"

function descriptor()
	return {
		title = EXTENSION_TITLE,
		version = "0.1",
		author = "pdpino",
--		url = "github??",
    shortdesc = EXTENSION_TITLE,
		description = [[
Football gametime.

TODO: description
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

	local gametime = minutes..":"..seconds
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
	local udata_dir = vlc.config.userdatadir()
	return udata_dir.."/football-gametime.data"
end

function _read_table()
	local f = vlc.io.open(_get_meta_filepath(), "rt")
	if f == nil then
		return {}
	end

	table = {}
	while true do
		local line = f:read()
		if line == nil then
			break
		end

		local _, _, key, offsets = string.find(line, "(.*)%s(%S+-%S+)$")
		if key ~= nil and key ~= "" and offsets ~= nil and offsets ~= "" then
			table[key] = offsets
		end
	end
	f:close()

	return table
end

function _save_table(table)
	local f = vlc.io.open(_get_meta_filepath(), "wt")
	for key,value in pairs(table) do
		f:write(key.." "..value.."\n")
	end
	f:close()
end

function _split_offsets(offsets)
  local _, _, raw_half1, raw_half2 = string.find(offsets, "^(%S+)-(%S+)$")
	if raw_half1 == nil or raw_half2 == nil then
		raw_half1 = offsets
		raw_half2 = nil
	end

	local err1, half1 = parse_and_validate_gametime(raw_half1)
	local err2, half2 = parse_and_validate_gametime(raw_half2)

	if err1 or err2 then
		vlc.msg.err("Cannot parse offsets: " .. offsets)
		return "", ""
	end

	return half1, half2
end

function save_offsets(offset_1half, offset_2half)
	local offsets = offset_1half.."-"..offset_2half

	local table = _read_table()
	local key = _get_current_file()
	table[key] = offsets
	_save_table(table)

	vlc.msg.info("Saving to meta: ".. key .. " = " .. offsets)
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
	elseif result1 == nil or result1 == "" then
		error_input:set_text("Error: 1st half cannot be empty")
		return
	end

	local err2, result2 = parse_and_validate_gametime(text_input_2half:get_text())
	if err2 then
		error_input:set_text("Error: cannot parse 2nd half: " .. (result2 or ""))
		return
	end

	save_offsets(result1, result2)

	error_input:set_text("")
	main_dlg:delete()
end

function click_cancel()
	main_dlg:delete()
end

function create_dialog()
	main_dlg = vlc.dialog(EXTENSION_TITLE)

	main_dlg:add_label("Kick off times", 1, 1, 2, 1) -- col, row, colspan, rowspan

	local value_1half, value_2half = load_offsets()

	main_dlg:add_label("1st half", 1, 2, 1, 1)
	text_input_1half = main_dlg:add_text_input(value_1half, 2, 2, 1, 1)

	main_dlg:add_label("2nd half", 1, 3, 1, 1)
	text_input_2half = main_dlg:add_text_input(value_2half, 2, 3, 1, 1)

	main_dlg:add_button("Cancel", click_cancel, 1, 4, 1, 1)
	main_dlg:add_button("Save", click_save, 2, 4, 1, 1)

	error_input = main_dlg:add_label("", 1, 5, 2, 1)

	main_dlg:show()
end

function activate()
	create_dialog()
end

function deactivate()
	-- main_dlg:delete()
end

function close()
	-- vlc.deactivate()
end

function trigger_menu(id)
	if id==1 then
		create_dialog()
	end
end

function menu()
	return {"Settings"}
end
