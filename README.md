# ArduPilot WP_LOITER_RAD Controller

## Overview

This project provides an ArduPlane Lua script and optional custom AP_OSD firmware modification that allow a pilot to adjust and monitor waypoint loiter radius during flight.

The system allows the ArduPilot parameter `WP_LOITER_RAD` to be adjusted using an RC transmitter control while providing real-time confirmation of loiter radius and direction.

---

# Features

## Dynamic Loiter Radius Control

The Lua script (`LRAD.lua`) provides dynamic control of the waypoint loiter radius.

Features:

* RC transmitter control of `WP_LOITER_RAD`
* Adjustable minimum and maximum radius limits
* Support for positive and negative loiter radius values
* Positive values create right-hand loiters
* Negative values create left-hand loiters
* Increasing knob position always increases the physical loiter circle size
* Deadzone protection reduces unnecessary parameter updates
* Optional GCS radius notifications
* Configurable GCS message units (feet or meters)

The Lua script preserves ArduPilot's standard loiter direction convention.

Example GCS messages:

Right-hand loiter:

```
WPLR: 590
```

Left-hand loiter:

```
WPLR: -590
```

---

# Standalone Lua Operation

The `LRAD.lua` script can be used independently with standard ArduPilot firmware.

A custom firmware build is **not required** to use the dynamic waypoint loiter radius controller. The Lua script provides in-flight adjustment of `WP_LOITER_RAD` using an RC transmitter control on supported ArduPlane vehicles.

The custom AP_OSD firmware modification is optional and adds an on-screen display of the active loiter radius and direction for pilots who want real-time FPV confirmation.

---

# OSD Firmware Modification

The optional custom ArduPlane firmware modification adds a loiter radius display element to the OSD.

The OSD display:

* Reads the active `WP_LOITER_RAD` parameter
* Displays the current loiter radius during flight
* Preserves the positive or negative direction sign
* Displays positive values for right-hand loiters
* Displays negative values for left-hand loiters
* Allows pilots to verify loiter size and direction without relying on GCS messages
* Supports configurable display units

Example OSD display:

Right-hand loiter:

```
R:590
```

Left-hand loiter:

```
R:-590
```

Firmware build:

* Based on ArduPlane 4.7.x
* Custom AP_OSD modification for loiter radius display
* Compatible with DisplayPort OSD systems

---

# Included Files

```
ArduPilot-WP-Loiter-Radius-Controller

├── Firmware
│   └── arduplane-WPLR-OSD.apj
│
├── Lua
│   └── LRAD.lua
│
├── Patches
│   └── WP_LOITER_RAD_OSD.patch
│
└── Documentation
    ├── INSTALLATION.md
    ├── FIRMWARE_COMPATIBILITY.md
    └── BUILDING_CUSTOM_FIRMWARE.md
```

---

# Quick Start

## Lua Script

Copy:

```
Lua/LRAD.lua
```

to the ArduPilot scripts directory:

```
APM/scripts/
```

Configure the Lua parameters:

```
WPLR_GCS_MSG
WPLR_MIN_RADIUS
WPLR_MAX_RADIUS
WPLR_RADIUS_DZ
WPLR_UNITS
```

Assign:

```
RC Option 300
```

to a transmitter knob.

---

## Optional OSD Firmware

For pilots who want FPV display feedback, flash:

```
Firmware/arduplane-WPLR-OSD.apj
```

using Mission Planner or another compatible ArduPilot flashing tool.

Configure the OSD loiter radius display and unit selection according to:

```
Documentation/INSTALLATION.md
```

---

# Tested Hardware

Aircraft:

* AtomRC Swordfish

Flight Controller:

* TBS LUCID H7 WING

Video / OSD System:

* Walksnail Avatar Goggles X
* Walksnail Avatar Moonlight VTX

OSD:

* DisplayPort OSD integration

---

# Compatibility

## Lua Script

The Lua script is hardware independent and can be used on supported ArduPlane vehicles with Lua scripting enabled.

## Firmware

The included firmware:

```
Firmware/arduplane-WPLR-OSD.apj
```

is a custom ArduPlane 4.7.x build created for:

* TBS LUCID H7 WING

Users with other ArduPilot-supported flight controllers should build their own firmware using the included AP_OSD modification patch.

---

# Documentation

Detailed information is available in:

* Installation guide
  `Documentation/INSTALLATION.md`

* Firmware compatibility
  `Documentation/FIRMWARE_COMPATIBILITY.md`

* Custom firmware building
  `Documentation/BUILDING_CUSTOM_FIRMWARE.md`

* AP_OSD modification patch
  `Patches/WP_LOITER_RAD_OSD.patch`

---

# Purpose

This project is intended for FPV and autonomous aircraft applications where the pilot needs:

* Dynamic loiter radius adjustment
* Immediate confirmation of loiter size
* Visible confirmation of loiter direction
* Reduced dependence on ground station parameter changes

This project is provided as a community resource for ArduPilot users interested in dynamic waypoint loiter radius control.


