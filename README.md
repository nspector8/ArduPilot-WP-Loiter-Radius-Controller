# ArduPilot WP_LOITER_RAD Controller

## Overview

This project provides an ArduPlane Lua script and optional custom AP_OSD firmware modification that allow a pilot to adjust and monitor waypoint loiter radius during flight.

The system uses an RC transmitter control to adjust the ArduPilot parameter `WP_LOITER_RAD`. The Lua controller can operate independently with standard ArduPilot firmware. The optional firmware patch adds an on-screen loiter-radius display through the ArduPilot OSD system.

---

# Features

## Dynamic Loiter Radius Control

The Lua script (`LRAD_v1.2.lua`) provides dynamic control of the waypoint loiter radius.

Features:

* RC transmitter control of `WP_LOITER_RAD` using RC Option 300
* Initial transmitter knob position sets the starting loiter radius
* Adjustable minimum and maximum radius limits
* Support for positive and negative loiter radius values
* Positive values create right-hand loiters
* Negative values create left-hand loiters
* Increasing knob position always increases the physical loiter circle size
* Deadzone protection reduces unnecessary parameter updates
* Invalid zero-radius MIN/MAX configurations are rejected with a warning
* Mismatched MIN/MAX signs are rejected with a warning
* Reversed absolute MIN/MAX ranges are automatically swapped with a warning
* External `WP_LOITER_RAD` changes are detected and temporarily accepted
* Knob movement takes control back after an external parameter change
* Optional GCS radius notifications
* Configurable GCS message units (meters or feet)
* Startup message identifies the script version and selected units

The Lua script preserves ArduPilot's standard loiter direction convention.

### GCS Message Control

`LRAD_GCS_MSG` controls radius notifications:

```text
0 = GCS messages OFF
1 = GCS messages ON (default)
```

Radius messages use the format:

```text
R:300
R:-300
```

The script limits radius messages to approximately one per second.

### Lua Units

`LRAD_UNITS` controls the units used in Lua GCS radius messages:

```text
0 = Meters
1 = Feet (default)
```

The sign is preserved in the displayed value so that the loiter direction remains visible.

---

# Loiter Radius Control Behavior

The controller maps the transmitter knob position across the configured absolute radius range.

The important behavior is that **a larger knob position always corresponds to a larger physical loiter circle**, regardless of whether the configured radii are positive or negative.

For example, with:

```text
LRAD_MIN_RADIUS = -90
LRAD_MAX_RADIUS = -180
```

the controller treats the absolute values as a range from 90 to 180 meters and applies the negative sign to preserve left-hand loiter direction. The lower knob position produces the smaller circle and the higher knob position produces the larger circle.

The MIN/MAX configuration has three validation rules:

* Neither `LRAD_MIN_RADIUS` nor `LRAD_MAX_RADIUS` may be zero.
* The two values must have matching signs.
* If their absolute magnitudes are reversed, the script automatically swaps the range.

Invalid zero or mixed-sign configurations are rejected and the current `WP_LOITER_RAD` value is not changed by the controller until the configuration is corrected.

If the absolute values of the configured minimum and maximum are reversed, the script automatically swaps them and reports:

```text
LRAD: MIN/MAX swapped
```

The script also protects against invalid parameter reads and enforces a minimum effective deadzone of 1.

---

# External WP_LOITER_RAD Changes

The v1.2 controller detects changes to `WP_LOITER_RAD` that occur outside the Lua controller, such as a ground-station parameter change.

When an external change is detected:

1. The external value is accepted and tracked.
2. The Lua controller does not immediately overwrite it with the current knob position.
3. The current knob position is remembered as the takeover point.
4. The pilot must move the knob before the Lua controller takes control again.
5. Once the knob moves, `WP_LOITER_RAD` is updated to the new knob-selected value.

This prevents an external parameter change from being immediately overridden by a stationary transmitter knob.

---

# Standalone Lua Operation

The `LRAD_v1.2.lua` script can be used independently with standard ArduPilot firmware.

A custom firmware build is **not required** to use the dynamic waypoint loiter radius controller. The Lua script provides in-flight adjustment of `WP_LOITER_RAD` using an RC transmitter control on supported ArduPlane vehicles with Lua scripting enabled.

The OSD functionality is separate from the Lua script. The Lua script does **not** directly access or control the OSD. The optional AP_OSD firmware modification reads the active `WP_LOITER_RAD` parameter and provides the OSD display.

---

# OSD Firmware Modification

The optional custom ArduPlane firmware modification adds a loiter radius display element to the OSD.

The OSD modification:

* Reads the active `WP_LOITER_RAD` parameter
* Displays the current loiter radius during flight
* Preserves the positive or negative direction sign
* Converts the displayed value between feet and meters
* Provides configurable OSD display position and enable settings
* Allows pilots to verify loiter size and direction without relying on GCS messages

Example OSD display:

Right-hand loiter:

```text
R:590
```

Left-hand loiter:

```text
R:-590
```

The OSD units are controlled independently by the firmware parameter `LOITRAD_UNITS`:

```text
0 = Feet (default)
1 = Meters
```

Firmware build:

* Based on ArduPlane 4.7.x
* Custom AP_OSD modification for loiter radius display
* Compatible with supported DisplayPort OSD systems

---

# Included Files

```text
ArduPilot-WP-Loiter-Radius-Controller

├── Firmware
│   └── arduplane-WPLR-OSD.apj
│
├── Lua
│   └── LRAD_v1.2.lua
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

Copy the revised `LRAD_v1.2.lua` release asset to the ArduPilot scripts directory:

```text
/APM/scripts/
```

Enable Lua scripting and configure the LRAD parameters:

```text
LRAD_GCS_MSG
LRAD_MIN_RADIUS
LRAD_MAX_RADIUS
LRAD_RADIUS_DZ
LRAD_UNITS
```

Assign:

```text
RC Option 300
```

to a transmitter knob.

On startup, the script reports its version and selected units, for example:

```text
LRAD v1.2: Loaded (Feet)
```

See `Documentation/INSTALLATION.md` for complete setup and testing instructions.

---

## Optional OSD Firmware

For pilots who want FPV display feedback, flash:

```text
Firmware/arduplane-WPLR-OSD.apj
```

using Mission Planner or another compatible ArduPilot flashing tool **only if the firmware matches the target flight controller**.

Users with other flight controllers should build their own firmware using:

```text
Patches/WP_LOITER_RAD_OSD.patch
```

See `Documentation/BUILDING_CUSTOM_FIRMWARE.md` for build instructions.

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

The script targets ArduPlane 4.7.x+ and uses standard ArduPilot Lua scripting APIs.

## Firmware

The included firmware:

```text
Firmware/arduplane-WPLR-OSD.apj
```

is a custom ArduPlane 4.7.x build created for:

* TBS LUCID H7 WING

Users with other ArduPilot-supported flight controllers should build their own firmware using the included AP_OSD modification patch.

---

# Documentation

Detailed information is available in:

* Installation and Lua configuration
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
* A transmitter control with intuitive radius scaling
* External `WP_LOITER_RAD` changes without immediate knob override
* Immediate confirmation of loiter size
* Visible confirmation of loiter direction
* Reduced dependence on ground-station parameter changes

This project is provided as a community resource for ArduPilot users interested in dynamic waypoint loiter radius control.
