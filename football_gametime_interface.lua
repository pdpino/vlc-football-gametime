--[[-----
Football Gametime VLC Interface

Shows the gametime as On Screen Display (OSD).

Author: @pdpino
--]] -----
-- FIXME: codeblock mostly copied from extension file,
-- with small modification: return numbers instead of strings
CONFIG_KEY = "bookmark10"

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

function _split_offsets(offsets)
    local _, _, raw_half1, raw_half2 = string.find(offsets, "^(%S*)-(%S*)$")

    local err1, half1 = parse_and_validate_gametime(raw_half1)
    local err2, half2 = parse_and_validate_gametime(raw_half2)

    if err1 or err2 then
        vlc.msg.err("Cannot parse offsets: " .. offsets)
        return -1, -1
    end

    return half1, half2
end

function load_offsets()
    kickoff_1half = -1
    kickoff_2half = -1

    offsets = vlc.config.get(CONFIG_KEY)

    if offsets ~= nil then
        kickoff_1half, kickoff_2half = _split_offsets(offsets)
    end
end

-- Finished copying from extension

OSD_POSITION = "top-left"

-- this could be reused? --> save prettier times
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
    vlc.msg.info("Running main loop")
    while true do
        if vlc.input.item() ~= nil and vlc.playlist.status() ~= "stopped" then
            -- if vlc.config.get(CONFIG_KEY) ~= nil then

            load_offsets()
            local elapsed_secs = round(vlc.var.get(vlc.object.input(), "time") / 1000000)
            vlc.msg.dbg("Elapsed: " .. tostring(elapsed_secs))
            vlc.osd.message(build_display_time(elapsed_secs), 123, OSD_POSITION, 10000000)
        end

        -- if vlc.playlist.status()=="stopped" then
        -- 	sleep(0.2)
        -- else
        -- end
        sleep(0.2)
    end
end

main_loop()
