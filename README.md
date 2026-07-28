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
- GCS messages display the current radius in feet

GCS examples:

Right-hand loiter:

    WPLR: 590

Left-hand loiter:

    WPLR: -590


---

# OSD Firmware Modification

A custom ArduPlane firmware modification adds a loiter radius display element to the OSD.

The OSD display:

- Reads the current `WP_LOITER_RAD` value
- Converts meters to feet
- Preserves the positive or negative direction sign
- Allows the pilot to verify loiter size and direction directly from the FPV display

OSD examples:

Right-hand loiter:

    R:590

Left-hand loiter:

    R:-590


---

# Tested Hardware

Aircraft:

TBS Lucid H7 Wing

Video / OSD System:

Walksnail Moonlight DisplayPort


---

# Installation

## Lua Script

Copy:

    Lua/LRAD.lua

to the ArduPilot scripts directory on the aircraft.

Configure:

    WPLR_MIN_RADIUS
    WPLR_MAX_RADIUS
    WPLR_RADIUS_DZ

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
