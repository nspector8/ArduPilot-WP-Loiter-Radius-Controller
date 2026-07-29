WP_LOITER_RAD Controller Installation Guide

Overview

This guide explains installation and configuration of the ArduPilot
WP_LOITER_RAD Controller system.

The project consists of:

-   LRAD.lua
    -   Lua script that allows RC transmitter knob control of
        WP_LOITER_RAD
-   arduplane-WPLR-OSD.apj
    -   Custom ArduPlane firmware containing an AP_OSD modification to
        display loiter radius and direction

Tested Hardware

Aircraft: - AtomRC Swordfish

Flight Controller: - TBS Lucid H7 Wing

Video / OSD System: - Walksnail Avatar Goggles X - Walksnail Avatar
Moonlight VTX

OSD Connection: - DisplayPort OSD integration

Requirements

Firmware: - ArduPlane 4.7.x - Lua scripting enabled - DisplayPort OSD
support

Provided firmware: Firmware/arduplane-WPLR-OSD.apj

Firmware Installation

1.  Connect the flight controller to Mission Planner.
2.  Install arduplane-WPLR-OSD.apj using Mission Planner firmware
    upload.
3.  Allow the flight controller to reboot.
4.  Confirm the vehicle starts normally.

Lua Script Installation

Lua script: Lua/LRAD.lua

Copy the file to:

/APM/scripts/

After installation:

1.  Reboot the flight controller.
2.  Confirm scripting is running.
3.  Verify the GCS message:

WPLR: Loaded

Parameter Configuration

Enable Lua scripting:

SCR_ENABLE = 1

Assign a transmitter knob to:

RC Option 300

The knob controls:

WP_LOITER_RAD

WPLR Parameters

Minimum radius:

WPLR_MIN_RADIUS

Example: WPLR_MIN_RADIUS = -90

Maximum radius:

WPLR_MAX_RADIUS

Example: WPLR_MAX_RADIUS = -180

Radius deadzone:

WPLR_RADIUS_DZ

Example: WPLR_RADIUS_DZ = 2

WPLR_GCS_MSG

Controls WPLR GCS text notifications.

0 = GCS messages ON (default)
1 = GCS messages OFF

Set to 1 when using the WP_LOITER_RAD OSD display through FPV goggles to reduce duplicate telemetry notifications.

Example: WPLR_GCS_MSG = 1

OSD Loiter Radius Units

The custom firmware OSD loiter radius display units are controlled by:

`LOITRAD_UNITS`

Values:

- `0` = Feet (default)
- `1` = Meters

This parameter only affects the OSD loiter radius display. It is independent of the Lua script `WPLR_UNITS` parameter, which controls GCS text message units.

Loiter Direction

ArduPilot uses the sign of WP_LOITER_RAD to determine loiter direction.

Positive values: WP_LOITER_RAD = 180

Right-hand loiter.

Negative values: WP_LOITER_RAD = -180

Left-hand loiter.

The Lua script preserves this behavior while ensuring increasing
transmitter knob position always increases the physical loiter circle
size.

OSD Display

The custom firmware adds a loiter radius display element.

The OSD display:

-   Reads the active WP_LOITER_RAD value
-   Converts meters to feet
-   Preserves the positive or negative direction sign

Examples:

Right-hand loiter:

R:590

Left-hand loiter:

R:-590

Testing Procedure

Before flight testing:

1.  Confirm the Lua script loads.
2.  Move the transmitter knob.
3.  Verify the GCS message changes.

Examples:

WPLR: 300

or:

WPLR: -300

4.  Confirm the OSD displays the matching radius.

Examples:

R:984

or:

R:-984

5.  Perform initial testing in a safe area.

Notes

This project modifies ArduPilot behavior and should be tested carefully
before operational flight.

Always verify:

-   Correct loiter direction
-   Correct radius scaling
-   Correct RC control operation

before relying on the system in flight.
