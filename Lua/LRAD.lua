--[[
ArduPlane Lua Script
Loiter Radius Controller + GCS Message Control

Target:
ArduPlane 4.7.x

Features:
- RC knob controls WP_LOITER_RAD
- Adjustable minimum/maximum radius
- Supports positive or negative loiter radii
- Larger knob position always = larger loiter circle
- Deadzone protection
- Optional GCS message display

WPLR_GCS_MSG:
0 = GCS messages ON
1 = GCS messages OFF

WPLR_UNITS:
0 = Feet (default)
1 = Meters
--]]

local SCRIPT_NAME = "WPLR"
local MAV_SEVERITY_INFO = 6
local RC_OPTION = 300
local UPDATE_RATE_MS = 200
local GCS_MSG_INTERVAL_MS = 1000
local M_TO_FT = 3.28084

local PARAM_TABLE_KEY = 76

assert(param:add_table(PARAM_TABLE_KEY, "WPLR_", 5),
       "Failed creating WPLR table")

assert(param:add_param(PARAM_TABLE_KEY, 1, "MIN_RADIUS", -90),
       "Failed creating MIN_RADIUS")

assert(param:add_param(PARAM_TABLE_KEY, 2, "MAX_RADIUS", -180),
       "Failed creating MAX_RADIUS")

assert(param:add_param(PARAM_TABLE_KEY, 3, "RADIUS_DZ", 2),
       "Failed creating RADIUS_DZ")

assert(param:add_param(PARAM_TABLE_KEY, 4, "GCS_MSG", 0),
       "Failed creating GCS_MSG")

assert(param:add_param(PARAM_TABLE_KEY, 5, "UNITS", 0),
       "Failed creating UNITS")

local min_radius = Parameter("WPLR_MIN_RADIUS")
local max_radius = Parameter("WPLR_MAX_RADIUS")
local radius_dz = Parameter("WPLR_RADIUS_DZ")
local gcs_msg_enable = Parameter("WPLR_GCS_MSG")
local wplr_units = Parameter("WPLR_UNITS")

local rc_chan = nil
local last_radius = param:get("WP_LOITER_RAD") or 60
local last_gcs_time = 0

local function gcs_msg(text)

    if gcs_msg_enable:get() ~= 0 then
        return
    end

    local now = millis()

    if now - last_gcs_time >= GCS_MSG_INTERVAL_MS then
        gcs:send_text(
            MAV_SEVERITY_INFO,
            SCRIPT_NAME .. ": " .. text
        )

        last_gcs_time = now
    end
end

local function clamp(v, low, high)

    if v < low then
        return low
    end

    if v > high then
        return high
    end

    return v
end

local function update_loiter_radius()

    if not rc_chan then
        rc_chan = rc:find_channel_for_option(RC_OPTION)

        if not rc_chan then
            return
        end
    end

    local min_r = min_radius:get()
    local max_r = max_radius:get()
    local dz = radius_dz:get()

    if dz < 1 then
        dz = 1
    end

    local knob = clamp(rc_chan:norm_input(), -1, 1)

    local radius_sign = 1

    if min_r < 0 and max_r < 0 then
        radius_sign = -1
    end

    local min_abs = math.abs(min_r)
    local max_abs = math.abs(max_r)

    if min_abs > max_abs then
        local temp = min_abs
        min_abs = max_abs
        max_abs = temp
    end

    local radius_abs =
        min_abs +
        ((knob + 1) * 0.5) *
        (max_abs - min_abs)

    local new_radius =
        math.floor(radius_abs + 0.5) * radius_sign

    if math.abs(new_radius - last_radius) >= dz then

        param:set("WP_LOITER_RAD", new_radius)

        last_radius = new_radius

        local display_radius

        if wplr_units:get() == 0 then
            display_radius =
                math.floor(math.abs(new_radius) * M_TO_FT + 0.5)
        else
            display_radius =
                math.floor(math.abs(new_radius) + 0.5)
        end

        if new_radius < 0 then
            display_radius = -display_radius
        end

        gcs_msg(string.format("%d", display_radius))
    end
end

gcs:send_text(
    MAV_SEVERITY_INFO,
    SCRIPT_NAME .. ": Loaded"
)

local function update()

    update_loiter_radius()

    return update, UPDATE_RATE_MS
end

return update()
