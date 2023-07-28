--[[-----
Football Gametime VLC Interface
Author: @pdpino

The interface displays the gametime on the screen as On Screen Display (OSD).
Receives a "message" from the extension via a bookmark, which indicates the kickoff times and configurations.

The message format is detailed in the extension.

--]] -----
CONFIG_KEY = "bookmark10"
OSD_CHANNEL_ID = 123
DEFAULT_OSD_POSITION = "top-left"

function parse_and_validate_gametime(value)
    if value == nil or value == "" then
        return false, -1
    end

    local _, _, minutes, seconds = string.find(value, "^(%d+):(%d+)$")

    if minutes == nil or seconds == nil then
        _, _, seconds = string.find(value, "^(%d+)$")
        if seconds == nil then
            return true, -1
        end
        minutes = "0"
    end

    return false, tonumber(minutes) * 60 + tonumber(seconds)
end

function _read_message(message)
    local _, _, raw_position, raw_half1, raw_half2 = string.find(message, "^(%S+)%s*(%S*)-(%S*)$")

    local err1, half1 = parse_and_validate_gametime(raw_half1)
    local err2, half2 = parse_and_validate_gametime(raw_half2)
    -- vlc.msg.dbg("Decoded: " .. raw_position .. " " .. half1 .. " " .. half2)

    if err1 or err2 then
        vlc.msg.err("Cannot parse message: " .. message)
        return -1, -1
    end

    return raw_position, half1, half2
end

function load_config()
    osd_position = DEFAULT_OSD_POSITION
    kickoff_1half = -1
    kickoff_2half = -1

    message = vlc.config.get(CONFIG_KEY)

    if message ~= nil then
        osd_position, kickoff_1half, kickoff_2half = _read_message(message)
    end
end

function seconds_to_gametime(minutes, seconds)
    return string.format("%02d:%02d", minutes, seconds)
end

function build_display_time(elapsed_seconds)
    if kickoff_1half == -1 and kickoff_2half == -1 then
        return "no kickoff times"
    end

    if elapsed_seconds < kickoff_1half then
        return "T -" .. tostring(kickoff_1half - elapsed_seconds)
    end

    local is_first_half = kickoff_2half == -1 or elapsed_seconds < kickoff_2half
    local current_time = elapsed_seconds

    if is_first_half then
        current_time = current_time - kickoff_1half
    else
        current_time = current_time - kickoff_2half + 45 * 60
    end

    local minutes = math.floor(current_time / 60)
    local seconds = current_time % 60

    if is_first_half and minutes >= 45 then
        return "45+" .. seconds_to_gametime(minutes - 45, seconds)
    end

    if not is_first_half and minutes >= 90 then
        return "90+" .. seconds_to_gametime(minutes - 90, seconds)
    end

    return seconds_to_gametime(minutes, seconds)
end

function sleep(seconds)
    vlc.misc.mwait(vlc.misc.mdate() + seconds * 1000000)
end

function round(num)
    return math.floor(num + 0.5)
end

function main_loop()
    vlc.msg.info("Starting main loop")
    vlc.config.set(CONFIG_KEY, "") -- clear leftover values
    while true do
        local msg = vlc.config.get(CONFIG_KEY)
        if msg == nil or msg == "" then
            sleep(0.5)
        else
            if vlc.input.item() ~= nil and vlc.playlist.status() ~= "stopped" then
                load_config()
                local elapsed_secs = round(vlc.var.get(vlc.object.input(), "time") / 1000000)
                vlc.msg.dbg("Elapsed: " .. tostring(elapsed_secs))
                vlc.osd.message(build_display_time(elapsed_secs), OSD_CHANNEL_ID, osd_position, 10000000)
                -- msg, channel_id, position, duration_microseconds
            end
            sleep(0.2)
        end

    end
end

main_loop()
