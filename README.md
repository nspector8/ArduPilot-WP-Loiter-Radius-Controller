# ArduPilot WP_LOITER_RAD Controller

## Overview

This project provides an ArduPlane Lua script and companion OSD firmware modification that allow a pilot to adjust and monitor the waypoint loiter radius during flight.

The system allows the ArduPilot parameter `WP_LOITER_RAD` to be adjusted using an RC transmitter knob while displaying the current loiter radius and direction through both GCS messages and the aircraft OSD.

---

# Features

## Lua Script - LRAD.lua

The Lua script provides dynamic control of the waypoint loiter radius.

Features:

- RC transmitter knob control of `WP_LOITER_RAD`
- Adjustable minimum and maximum radius limits
- Supports both positive and negative loiter radii
- Positive values create right-hand loiters
- Negative values create left-hand loiters
- Increasing knob position always increases the physical loiter circle size
- Deadzone protection reduces unnecessary parameter updates
- GCS messages display the current radius in selected units
- Optional GCS radius messages (can be disabled when using FPV goggles with OSD)

GCS examples:

Right-hand loiter:

    WPLR: 590

Left-hand loiter:

    WPLR: -590


---

# OSD Firmware Modification

A custom ArduPlane firmware modification adds a loiter radius display element to the OSD.

The modification allows the pilot to see the active `WP_LOITER_RAD` value directly in the FPV display while preserving the direction of the loiter.

The OSD display:

- Reads the current `WP_LOITER_RAD` parameter
- Displays the radius using the selected OSD units
- Preserves the positive or negative direction sign
- Displays positive values for right-hand loiters
- Displays negative values for left-hand loiters
- Allows the pilot to verify loiter size and direction during flight

The OSD display units are controlled by the firmware parameter:

`LOITRAD_UNITS`

Values:

- `0` = Feet (default)
- `1` = Meters

This parameter only affects the OSD loiter radius display.

Firmware build:

- Based on ArduPlane 4.7.x
- Custom AP_OSD modification for loiter radius display
- Compatible with DisplayPort OSD systems

OSD examples:

Right-hand loiter:

    R:590

Left-hand loiter:

    R:-590


---

# Tested Hardware

Aircraft:

AtomRC Swordfish

Flight Controller:

TBS Lucid H7 Wing

Video / OSD System:

Walksnail Avatar Goggles X

Walksnail Avatar Moonlight VTX

Connection: 

DisplayPort OSD integration


---

# Installation

## Lua Script

Copy:

    Lua/LRAD.lua

to the ArduPilot scripts directory on the aircraft.

Configure:

    WPLR_GCS_MSG
    WPLR_MIN_RADIUS
    WPLR_MAX_RADIUS
    WPLR_RADIUS_DZ
    WPLR_UNITS

### GCS Message Control

The Lua script can send the current `WP_LOITER_RAD` value through GCS text messages.

The parameter `WPLR_GCS_MSG` controls these notifications:

- `0` = GCS messages ON (default)
- `1` = GCS messages OFF

When using FPV goggles with the AP_OSD WP_LOITER_RAD display, set:

WPLR_GCS_MSG = 1

to prevent duplicate radius notifications. The OSD display will continue to operate normally.

Assign:

    RC Option 300

to a transmitter knob.


## Firmware

Flash:

    Firmware/arduplane-WPLR-OSD.apj

using Mission Planner or another compatible ArduPilot flashing tool.


---

# Project Files

    ArduPilot-WP-Loiter-Radius-Controller

    ├── README.md
    │
    ├── Firmware
    │   └── arduplane-WPLR-OSD.apj
    │
    ├── Lua
    │   └── LRAD.lua
    │
    └── Documentation


---

# Purpose

This project is intended for FPV and autonomous aircraft applications where the pilot needs:

- Dynamic loiter radius adjustment
- Immediate confirmation of loiter size
- Visible confirmation of loiter direction
- Reduced dependence on ground station parameter changes


---

# Notes

The Lua script modifies the ArduPilot parameter:

    WP_LOITER_RAD

The OSD firmware modification displays the active value directly from the parameter, allowing the pilot to verify loiter radius and direction in flight.

This project is provided as a community resource for ArduPilot users interested in dynamic loiter radius control.

------------------------------------------------------------------------

Firmware Compatibility

The included firmware:

Firmware/arduplane-WPLR-OSD.apj

is a custom ArduPlane 4.7.x build created for the TBS H7 Lucid Wing flight controller.

This firmware is a working example build and should only be installed on
compatible hardware.

Users with other ArduPilot-supported flight controllers should build
their own firmware using the documented AP_OSD modification.

See:

-   Documentation/FIRMWARE_COMPATIBILITY.md
-   Documentation/BUILDING_CUSTOM_FIRMWARE.md
-   Patches/WP_LOITER_RAD_OSD.patch

The Lua script:

Lua/LRAD.lua

is hardware independent and can be used on supported ArduPlane vehicles
with Lua scripting enabled.

The firmware modification is limited to the AP_OSD implementation and:

-   Reads the active WP_LOITER_RAD value
-   Preserves the positive or negative direction sign
-   Converts meters to feet
-   Displays the loiter radius through DisplayPort OSD

