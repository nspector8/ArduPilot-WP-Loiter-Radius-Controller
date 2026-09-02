--[[
ArduPlane Lua Script
Loiter Radius Controller + GCS Message Control

Target:
ArduPlane 4.7.x+

Features:
- RC knob controls WP_LOITER_RAD
- Initial knob position sets the starting loiter radius
- Adjustable minimum/maximum radius
- Supports positive or negative loiter radii
- Larger knob position always = larger loiter circle
- Deadzone protection
- External WP_LOITER_RAD changes are detected and accepted
- Knob movement takes control back after an external change
- Optional GCS message display

LRAD_GCS_MSG:
0 = GCS messages OFF
1 = GCS messages ON

LRAD_UNITS:
0 = Meters
1 = Feet (default)

OSD:
OSD functionality is handled by the ArduPilot firmware patch.
This Lua script does not directly access or control the OSD.
]]

local SCRIPT_NAME = "LRAD"
local SCRIPT_VERSION = "1.2"

local MAV_SEVERITY_INFO = 6
local RC_OPTION = 300

local UPDATE_RATE_MS = 200
local GCS_MSG_INTERVAL_MS = 1000

local M_TO_FT = 3.28084

local PARAM_TABLE_KEY = 91

assert(param:add_table(PARAM_TABLE_KEY, "LRAD_", 5),
    "Failed creating LRAD table")

assert(param:add_param(PARAM_TABLE_KEY, 1, "MIN_RADIUS", -90),
    "Failed creating MIN_RADIUS")

assert(param:add_param(PARAM_TABLE_KEY, 2, "MAX_RADIUS", -180),
    "Failed creating MAX_RADIUS")

assert(param:add_param(PARAM_TABLE_KEY, 3, "RADIUS_DZ", 2),
    "Failed creating RADIUS_DZ")

assert(param:add_param(PARAM_TABLE_KEY, 4, "GCS_MSG", 1),
    "Failed creating GCS_MSG")

assert(param:add_param(PARAM_TABLE_KEY, 5, "UNITS", 1),
    "Failed creating UNITS")

local min_radius = Parameter("LRAD_MIN_RADIUS")
local max_radius = Parameter("LRAD_MAX_RADIUS")
local radius_dz = Parameter("LRAD_RADIUS_DZ")
local gcs_msg_enable = Parameter("LRAD_GCS_MSG")
local lrad_units = Parameter("LRAD_UNITS")

local rc_chan = nil

local last_radius = nil

local external_override = false
local external_radius = nil
local takeover_radius = nil

local last_gcs_time = 0

local warned_zero = false
local warned_sign = false
local warned_minmax = false

local function format_radius(radius)

    local display_radius

    if lrad_units:get() == 1 then

        display_radius =
            math.floor(math.abs(radius) * M_TO_FT + 0.5)

    else

        display_radius =
            math.floor(math.abs(radius) + 0.5)

    end

    if radius < 0 then
        display_radius = -display_radius
    end

    return display_radius
end

local function gcs_msg(text)

    if gcs_msg_enable:get() ~= 1 then
        return
    end

    local now = millis()

    if now - last_gcs_time >= GCS_MSG_INTERVAL_MS then

        gcs:send_text(
            MAV_SEVERITY_INFO,
            "R:" .. text
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

local function calculate_knob_radius()

    local min_r = min_radius:get()
    local max_r = max_radius:get()

    if min_r == nil or max_r == nil then
        return nil, false
    end

    if min_r == 0 or max_r == 0 then

        if not warned_zero then

            gcs:send_text(
                MAV_SEVERITY_INFO,
                SCRIPT_NAME .. ": MIN/MAX cannot be zero"
            )

            warned_zero = true

        end

        return nil, true
    end

    if (min_r < 0 and max_r > 0)
    or (min_r > 0 and max_r < 0) then

        if not warned_sign then

            gcs:send_text(
                MAV_SEVERITY_INFO,
                SCRIPT_NAME .. ": MIN/MAX signs must match"
            )

            warned_sign = true

        end

        return nil, true
    end

    local knob = clamp(
        rc_chan:norm_input(),
        -1,
        1
    )

    local radius_sign = 1

    if min_r < 0 and max_r < 0 then
        radius_sign = -1
    end

    local min_abs = math.abs(min_r)
    local max_abs = math.abs(max_r)

    if min_abs > max_abs then

        if not warned_minmax then

            gcs:send_text(
                MAV_SEVERITY_INFO,
                SCRIPT_NAME .. ": MIN/MAX swapped"
            )

            warned_minmax = true

        end

        local temp = min_abs

        min_abs = max_abs
        max_abs = temp

    end

    local radius_abs =
        min_abs +
        ((knob + 1) * 0.5) *
        (max_abs - min_abs)

    local knob_radius =
        math.floor(radius_abs + 0.5) *
        radius_sign

    return knob_radius
end

local function update_loiter_radius()

    if not rc_chan then

        rc_chan = rc:find_channel_for_option(RC_OPTION)

        if not rc_chan then
            return
        end

    end

    local dz = radius_dz:get()

    if dz == nil then

        gcs:send_text(
            MAV_SEVERITY_INFO,
            SCRIPT_NAME .. ": parameter read failure"
        )

        return

    end

    if dz < 1 then
        dz = 1
    end

    local knob_radius, invalid_config = calculate_knob_radius()

    if knob_radius == nil then

        if not invalid_config then

            gcs:send_text(
                MAV_SEVERITY_INFO,
                SCRIPT_NAME .. ": parameter read failure"
            )

        end

        return

    end

    if last_radius == nil then

        param:set(
            "WP_LOITER_RAD",
            knob_radius
        )

        last_radius = knob_radius

        external_override = false
        external_radius = nil
        takeover_radius = nil

    else

        local actual_radius =
            param:get("WP_LOITER_RAD")

        if not external_override
            and actual_radius ~= nil
            and actual_radius ~= last_radius then

            external_override = true

            external_radius = actual_radius

            takeover_radius = knob_radius

        end


        if external_override then

            if actual_radius ~= nil
                and actual_radius ~= external_radius then

                external_radius = actual_radius

            end

            if takeover_radius ~= nil
                and knob_radius ~= takeover_radius then

                param:set(
                    "WP_LOITER_RAD",
                    knob_radius
                )

                last_radius = knob_radius

                external_override = false
                external_radius = nil
                takeover_radius = nil

                gcs_msg(
                    string.format(
                        "%d",
                        format_radius(knob_radius)
                    )
                )

            end

        else

            if math.abs(
                knob_radius - last_radius
            ) >= dz then

                param:set(
                    "WP_LOITER_RAD",
                    knob_radius
                )

                last_radius = knob_radius

                gcs_msg(
                    string.format(
                        "%d",
                        format_radius(knob_radius)
                    )
                )

            end

        end

    end
end

local unit_name = "Feet"

if lrad_units:get() == 0 then
    unit_name = "Meters"
end

gcs:send_text(
    MAV_SEVERITY_INFO,
    string.format(
        "%s v%s: Loaded (%s)",
        SCRIPT_NAME,
        SCRIPT_VERSION,
        unit_name
    )
)

local function update()

    update_loiter_radius()

    return update, UPDATE_RATE_MS
end

return update()
